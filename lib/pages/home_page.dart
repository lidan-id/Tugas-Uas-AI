import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GoogleTranslator translator = GoogleTranslator();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String resultSpeech = '';
  String resultTranslate = '';
  String inputLanguage = 'en';
  String outputLanguage = 'fr';
  Future<void> translateText() async {
    final translated = await translator.translate(resultSpeech,
        from: inputLanguage, to: outputLanguage);
    setState(() {
      resultTranslate = translated.text;
    });
  }

  final FlutterTts flutterTts = FlutterTts();
  String ttsLanguage = "fr-FR";
  speak(String text) async {
    await flutterTts.setLanguage(ttsLanguage);
    await flutterTts.setPitch(1);
    await flutterTts.speak(text);
  }

  bool _isTranslateVoice = false;
  void _translateVoice() {
    setState(() {
      _isTranslateVoice = !_isTranslateVoice;
    });
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: _getLocaleId(inputLanguage),
    );
    setState(() {});
  }

  String _getLocaleId(String languageCode) {
    switch (languageCode) {
      case 'id':
        return 'id_ID';
      case 'fr':
        return 'fr_FR';
      case 'es':
        return 'es_ES';
      case 'de':
        return 'de_DE';
      case 'ja':
        return 'ja_JP';
      case 'ko':
        return 'ko_KR';
      case 'en':
      default:
        return 'en_US';
    }
  }

  void _stopListening() async {
    resultSpeech = _lastWords;
    await _speechToText.stop();
    setState(() {
      translateText();
    });
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 70, left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const NamaFitur(
                namaFitur: 'SPEECH RECOGNITION ',
                ikon: Icons.mic,
              ),
              bagianInputSpeech(context),
              bagianSelectLanguage(),
              bagianTranslateOutput(context),
              const NamaFitur(
                  namaFitur: 'TRANSLATE & TTS ', ikon: Icons.g_translate)
            ],
          ),
        ),
      ),
    );
  }

  Column bagianInputSpeech(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AvatarGlow(
                  animate: _speechToText.isListening,
                  glowColor: Colors.grey,
                  child: FloatingActionButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    onPressed: _speechToText.isNotListening
                        ? _startListening
                        : _stopListening,
                    tooltip: 'Listen',
                    child: Icon(_speechToText.isNotListening
                        ? Icons.mic_off
                        : Icons.mic),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  _speechToText.isListening
                      ? _lastWords
                      : resultSpeech != ''
                          ? resultSpeech
                          : _speechEnabled
                              ? 'Tap the microphone to start listening...'
                              : 'Speech not available',
                  style: TextStyle(
                      color: resultSpeech.isEmpty ? Colors.grey : Colors.black),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Row bagianSelectLanguage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        DropdownButton<String>(
          value: inputLanguage,
          onChanged: (newValue) {
            setState(() {
              inputLanguage = newValue!;
            });
          },
          items: <String>[
            'en',
            'id',
            'fr',
            'es',
            'de',
            'ja',
            'ko',
          ]
              .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                        ),
                      ))
              .toList(),
        ),
        const Icon(Icons.arrow_forward_rounded),
        DropdownButton<String>(
          value: outputLanguage,
          onChanged: (newValue) {
            setState(() {
              outputLanguage = newValue!;
              if (outputLanguage == 'en') {
                ttsLanguage = 'en-US';
              }
              if (outputLanguage == "fr") {
                ttsLanguage = "fr-FR";
              }
              if (outputLanguage == "es") {
                ttsLanguage = "es-ES";
              }
              if (outputLanguage == "de") {
                ttsLanguage = "de-DE";
              }
              if (outputLanguage == "id") {
                ttsLanguage = "id-ID";
              }
              if (outputLanguage == "ja") {
                ttsLanguage = "ja-JP";
              }
              if (outputLanguage == "ko") {
                ttsLanguage = "ko-KR";
              }
            });
            translateText();
            debugPrint(ttsLanguage);
          },
          items: <String>[
            'en',
            'id',
            'fr',
            'es',
            'de',
            'ja',
            'ko',
          ]
              .map<DropdownMenuItem<String>>(
                  (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                        ),
                      ))
              .toList(),
        ),
      ],
    );
  }

  Column bagianTranslateOutput(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 250,
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: resultTranslate.isEmpty
                ? const Column(children: [
                    Text(
                      "No speech detected",
                      style: TextStyle(color: Colors.grey),
                    )
                  ])
                : Column(
                    children: [
                      AvatarGlow(
                        animate: _isTranslateVoice,
                        glowColor: Colors.grey,
                        child: FloatingActionButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100)),
                          onPressed: () async {
                            _translateVoice();
                            await speak(resultTranslate);
                            Future.delayed(
                                const Duration(seconds: 3), _translateVoice);
                          },
                          tooltip: 'Speak',
                          child: const Icon(Icons.volume_up),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        resultTranslate,
                        style: const TextStyle(color: Colors.black),
                      )
                    ],
                  ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class NamaFitur extends StatelessWidget {
  const NamaFitur({super.key, required this.namaFitur, required this.ikon});

  final String namaFitur;
  final IconData ikon;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            namaFitur,
            style: TextStyle(
              shadows: const [Shadow(blurRadius: 20, color: Colors.grey)],
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent.withOpacity(0.6),
              fontSize: 20.0,
            ),
          ),
        ),
        Icon(
          ikon,
          size: 20,
          shadows: const [Shadow(blurRadius: 20, color: Colors.grey)],
          color: Colors.deepPurpleAccent.withOpacity(0.6),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
