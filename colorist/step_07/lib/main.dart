// Copyright 2025 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_text_to_speech/cloud_text_to_speech.dart';
import 'package:colorist_ui/colorist_ui.dart';
import 'package:colorist_ui/src/cubit/chat_cubit.dart';
import 'package:colorist_ui/src/cubit/color_cubit.dart';
import 'package:colorist_ui/src/cubit/log_cubit.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_speech/google_speech.dart';
import 'package:http/http.dart' as http;
import 'package:record/record.dart';
import 'package:waveform_recorder/waveform_recorder.dart';

import 'providers/gemini.dart';
import 'services/gemini_chat_service.dart';

ServiceAccount? serviceAccount;
SpeechToText? speechToText;
RecognitionConfig? config;
final player = AudioPlayer();

final _waveController = WaveformRecorderController();
final record = AudioRecorder();
VoiceGoogle? voice;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Check and request permission if needed
  await dotenv.load(fileName: ".env");
  await record.hasPermission();
  TtsUniversal.init(
    provider: 'google',
    withLogs: true,
    google: InitParamsGoogle(apiKey: dotenv.env['GOOGLEAPIKEY'] ?? ''),
    microsoft: InitParamsMicrosoft(subscriptionKey: '', region: ''),
  );
  //Get voices
  final voicesResponse = await TtsGoogle.getVoices();

  final voices = voicesResponse.voices;

  //Pick an English Voice
  voice = voices
      .where((element) => element.locale.code.startsWith("en-"))
      .toList(growable: false)
      .first;

  runApp(
    ProviderScope(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<ColorCubit>(create: (_) => ColorCubit()),
          BlocProvider<ChatCubit>(create: (_) => ChatCubit()),
          BlocProvider<LogCubit>(create: (_) => LogCubit()),
        ],
        child: MainApp(),
      ),
    ),
  );
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final model = ref.watch(geminiModelProvider);
    final conversationState = ref.watch(conversationStateProvider);

    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: model.when(
        data: (data) {
          final ValueNotifier valueNotifierIsRecording = ValueNotifier(false);

          return Column(
            children: [
              Expanded(
                child: MainScreen(
                  conversationState: conversationState,
                  onPressedVoiceOutput: (text) async {
                    TtsParamsGoogle ttsParams = TtsParamsGoogle(
                      voice: voice!,
                      audioFormat: AudioOutputFormatGoogle.mp3,
                      text: text,
                    );
                    final ttsResponse = await TtsGoogle.convertTts(ttsParams);
                    //Get the audio bytes.
                    final audioBytes = ttsResponse.audio.buffer.asUint8List();
                    unawaited(player.play(BytesSource(audioBytes)));
                  },
                  notifyColorSelection: (color) {
                    ref
                        .read(geminiChatServiceProvider)
                        .notifyColorSelection(color);
                  },
                  sendMessage: (text) {
                    ref.read(geminiChatServiceProvider).sendMessage(text);
                  },
                  onRecordPressed: () async {
                    // await record.start(
                    //   const RecordConfig(),
                    //   path: 'aFullPath/myFile.m4a',
                    // );
                    final String fileContents = await XFile(
                      'assets/firebase.json',
                    ).readAsString();
                    serviceAccount = ServiceAccount.fromString(fileContents);

                    speechToText = SpeechToText.viaServiceAccount(
                      serviceAccount!,
                    );
                    config = RecognitionConfig(
                      encoding: AudioEncoding.LINEAR16,
                      model: RecognitionModel.basic,
                      enableAutomaticPunctuation: true,
                      sampleRateHertz: 16000,
                      languageCode: 'en-US',
                    );

                    Future.delayed(const Duration(milliseconds: 700), () {
                      valueNotifierIsRecording.value = true;
                    });
                    await _waveController.startRecording();
                  },
                ),
              ),
              ValueListenableBuilder(
                valueListenable: valueNotifierIsRecording,
                builder: (context, value, child) {
                  if (!value) {
                    return const SizedBox.shrink();
                  }
                  return Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.stop_circle),
                        onPressed: () async {
                          await _waveController.stopRecording();
                          final fileToAdd = await XFile(
                            _waveController.file!.path,
                          ).readAsBytes();

                          final response = await http.post(
                            Uri.parse(
                              'https://speech.googleapis.com/v1/speech:recognize?key=${dotenv.env['GOOGLEAPIKEY'] ?? ''}',
                            ),
                            headers: {'Content-Type': 'application/json'},
                            body: jsonEncode({
                              "config": {
                                "encoding": "LINEAR16",
                                "languageCode": "en-US",
                              },
                              "audio": {"content": base64Encode(fileToAdd)},
                            }),
                          );

                          await ref
                              .read(geminiChatServiceProvider)
                              .sendMessage(
                                jsonDecode(
                                  response.body,
                                )['results'][0]['alternatives'][0]['transcript'],
                              );
                        },
                      ),
                      SizedBox(
                        width: (MediaQuery.of(context).size.width / 2) - 20,
                        height: 70,
                        child: WaveformRecorder(
                          height: 70,
                          controller: _waveController,
                          onRecordingStopped: () {
                            valueNotifierIsRecording.value = false;
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          );
        },
        loading: () => LoadingScreen(message: 'Initializing Gemini Model'),
        error: (err, st) => ErrorScreen(error: err),
      ),
    );
  }
}
