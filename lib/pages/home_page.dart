import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String dropDownButtonValue = 'Inggris';
  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  String resultSpeech = '';
  String resultTranslate = '';
  final translator = GoogleTranslator();
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
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    resultSpeech = _lastWords;
    await _speechToText.stop();
    setState(() {});
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
          padding: EdgeInsets.only(top: 70, left: 50, right: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Speech Recognition:',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Icon(
                Icons.mic,
                size: 60,
                color: Colors.deepPurpleAccent,
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(
                    // If listening is active show the recognized words
                    _speechToText.isListening
                        ? '$_lastWords'
                        : resultSpeech != ''
                            ? '$resultSpeech'
                            // If listening isn't active but could be tell the user
                            // how to start it, otherwise indicate that speech
                            // recognition is not yet ready or not supported on
                            // the target device
                            : _speechEnabled
                                ? 'Tap the microphone to start listening...'
                                : 'Speech not available',
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
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
                  Icon(Icons.arrow_forward_rounded),
                  DropdownButton<String>(
                    value: outputLanguage,
                    onChanged: (newValue) {
                      setState(() {
                        outputLanguage = newValue!;
                        if (outputLanguage == 'en') {
                          ttsLanguage = 'en-US';
                        } else if (outputLanguage == "fr") {
                          ttsLanguage = "fr-FR";
                        } else if (outputLanguage == "es") {
                          ttsLanguage = "es-ES";
                        } else if (outputLanguage == "de") {
                          ttsLanguage = "de-DE";
                        } else {
                          ttsLanguage = "id-ID";
                        }
                      });
                      print(ttsLanguage);
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
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.deepPurpleAccent),
                  onPressed: () {
                    translateText();
                  },
                  child: Text(
                    'Translate',
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 150,
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Text(resultTranslate),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              IconButton(
                  onPressed: () {
                    speak(resultTranslate);
                  },
                  icon: Icon(Icons.volume_up))
            ],
          ),
        ),
      ),
      floatingActionButton: AvatarGlow(
        animate: _speechToText.isListening,
        glowColor: Colors.grey,
        child: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
          onPressed:
              // If not yet listening for speech start, otherwise stop
              _speechToText.isNotListening ? _startListening : _stopListening,
          tooltip: 'Listen',
          child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
// _speechToText.isNotListening ? _startListening : _stopListening,