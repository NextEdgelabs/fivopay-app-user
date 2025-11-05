import 'dart:developer';

import 'package:flutter_tts/flutter_tts.dart';

class TTSService {
  static final FlutterTts _tts = FlutterTts();

  static Future<void> init() async {

    await _tts.setLanguage("hi-IN");
    await _tts.setVoice(  {
    "locale": "hi-IN",
    "quality": "default",
    "name": "Lekha",
    "gender": "female",
    "identifier": "com.apple.voice.compact.hi-IN.Lekha"
  },); // Indian English voice
    await _tts.setSpeechRate(0.4);   // 0.0 to 1.0
    await _tts.setVolume(1.0);
    // await _tts.setVoice("en-in-x-1");
    await _tts.setPitch(0.9);


        List<dynamic> voices = await _tts.getVoices;
    log(voices.toString());
    
  }

  static Future<void> speak(String text) async {
    await _tts.speak(text);
  }

  static Future<void> stop() async {
    await _tts.stop();
  }
}

