import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:voice_recorder_app/recorder/recorder_page.dart';
import 'package:voice_recorder_app/recorder/store/recorder_store.dart';

void main() {
  getIt.registerLazySingleton<RecorderStore>(
    () => RecorderStore(),
  );
  runApp(const MyApp());
}

final GetIt getIt = GetIt.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Voice Recorder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RecorderPage(),
    );
  }
}
