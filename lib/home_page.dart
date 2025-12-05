import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart' show SpeechRecognitionResult;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant_app/feature_box.dart';
import 'package:voice_assistant_app/pallete.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final speechToText = SpeechToText();
  String lastWords = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSpeechToText();
  }

  Future <void> initSpeechToText() async{
    await speechToText.initialize();
    setState(() {});
  }

  Future <void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future <void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }
  
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Allen'),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Part
            Stack(
              children: [
                Center(
                child: Container(
                  height: 120,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    color: Pallete.assistantCircleColor,
                    shape: BoxShape.circle,
                  ),
                )
            ),
                Container(
                  height: 123,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage("assets/images/virtualAssistant.png"))
                  ),
                )
              ],
            ),
          //   Chat Bubble
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 40).copyWith(
                top: 30,
              ),
        
              decoration: BoxDecoration(
                border: Border.all(
                  color: Pallete.borderColor,
                ),
                borderRadius: BorderRadius.circular(20).copyWith(
                  topLeft: Radius.zero,
                )
              ),
        
              child: const Padding(
                padding:  EdgeInsets.symmetric(vertical: 10.0),
                child:  Text('Good Morning, what task can I do for you?',
                style: TextStyle(
                  color: Pallete.mainFontColor,
                  fontSize: 25,
                  fontFamily: 'Cera Pro',
                ),
                ),
              )
            ),
        
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(
              top: 10,
              left: 22,
            ),
            alignment: Alignment.centerLeft,
            child: const Text('Here are few features:',
            style: TextStyle(
              fontFamily: 'Cera Pro',
              color: Pallete.mainFontColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            ),
          ),
          //   Features  List
          Column(
            children: [
              FeatureBox(color: Pallete.firstSuggestionBoxColor,
              headerText: 'Chat GPT',
              descriptionText: 'A smarter way to stay organized and informed with Chat GPT',
              ),
        
              FeatureBox(color: Pallete.secondSuggestionBoxColor,
                headerText: 'Dall-E',
                descriptionText: 'Get inspired and stay creative with your personal assistant powered by Dall-E',
              ),
        
              FeatureBox(color: Pallete.thirdSuggestionBoxColor,
                headerText: 'Smart Voice Assitant',
                descriptionText: 'Get the best of both worlds with a voice assistant powered by Dall-E and Chat GPT',
              )
        
            ],
          )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Pallete.firstSuggestionBoxColor,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening){
            await startListening();
          }else if(speechToText.isListening){
            await stopListening();
          }else{
            initSpeechToText();
          }
        },
        child: const Icon(Icons.mic),
      ),

    );
  }
}