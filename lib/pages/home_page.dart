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
  // String dropDownButtonValue = 'Inggris';
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

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: _getLocaleId(inputLanguage),
    );
    setState(() {});
  }

  /// Get the locale identifier for the given language code
  String _getLocaleId(String languageCode) {
    switch (languageCode) {
      case 'fr':
        return 'fr_FR';
      case 'es':
        return 'es_ES';
      case 'de':
        return 'de_DE';
      case 'id':
        return 'id_ID';
      case 'en':
      default:
        return 'en_US';
    }
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    resultSpeech = _lastWords;
    await _speechToText.stop();
    setState(() {
      translateText();
    });
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
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
              const NamaAplikasi(),
              bagianInputSpeech(context),
              bagianSelectLanguage(),
              bagianTranslateOutput(context)
            ],
          ),
        ),
      ),
      // floatingActionButton: AvatarGlow(
      //   animate: _speechToText.isListening,
      //   glowColor: Colors.grey,
      //   child: FloatingActionButton(
      //     shape:
      //         RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      //     onPressed:
      //         // If not yet listening for speech start, otherwise stop
      //         _speechToText.isNotListening ? _startListening : _stopListening,
      //     tooltip: 'Listen',
      //     child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
      //   ),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                    onPressed:
                        // If not yet listening for speech start, otherwise stop
                        _speechToText.isNotListening
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
                  // If listening is active show the recognized words
                  _speechToText.isListening
                      ? _lastWords
                      : resultSpeech != ''
                          ? resultSpeech
                          // If listening isn't active but could be tell the user
                          // how to start it, otherwise indicate that speech
                          // recognition is not yet ready or not supported on
                          // the target device
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
          items: <String>['en', 'fr', 'es', 'de', 'id']
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
            });
            translateText();
            debugPrint(ttsLanguage);
          },
          items: <String>['en', 'fr', 'es', 'de', 'id']
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
        // ElevatedButton(
        //     style: ElevatedButton.styleFrom(
        //         foregroundColor: Colors.deepPurpleAccent),
        //     onPressed: () {
        //       translateText();
        //     },
        //     child: const Text(
        //       'Translate',
        //     )),
        // const SizedBox(
        //   height: 20,
        // ),
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

class NamaAplikasi extends StatelessWidget {
  const NamaAplikasi({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'SPEECH RECOGNITION',
            style: TextStyle(
              shadows: const [Shadow(blurRadius: 20, color: Colors.grey)],
              fontWeight: FontWeight.bold,
              color: Colors.deepPurpleAccent.withOpacity(0.6),
              fontSize: 20.0,
            ),
          ),
        ),
        Icon(
          Icons.mic,
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
