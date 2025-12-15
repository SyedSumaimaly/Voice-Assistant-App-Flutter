import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart' show SpeechRecognitionResult;
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant_app/feature_box.dart';
import 'package:voice_assistant_app/pallete.dart';
// import 'package:flutter/foundation.dart';
import 'openai_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late final speechToText = SpeechToText();
  String lastWords = '';
  final OpenAIService openAIService = OpenAIService();
  final  flutterTts = FlutterTts();
  String? generatedContent;
  String? generatedImageUrl;
  bool isLoading = false;
  int start = 200;
  int delay = 200;


  @override
  void initState() {
    super.initState();
    initSpeechToText();
    initTextToSpeech();
  }

  Future<void> initTextToSpeech() async{
    await flutterTts.setSharedInstance(true);
    setState(() {});
  }

  Future <void> initSpeechToText() async{
    await speechToText.initialize();
    setState(() {});
  }

  Future <void> startListening() async {
    lastWords = '';
    generatedContent = null;
    generatedImageUrl = null;
    await speechToText.listen(onResult: onSpeechResult);
    setState(() {});
  }

  Future <void> stopListening() async {
    await speechToText.stop();
    setState(() {
      isLoading = true;
    });

    if (lastWords.isNotEmpty) {
      await processSpeechCommand(lastWords);
    } else {
      setState(() {
        isLoading = false;
        generatedContent = "I didn't catch that. Please try again.";
      });
      await systemSpeak(generatedContent!);
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> processSpeechCommand(String command) async {
    final speech = await openAIService.geminiChatAPI(command);

    if(speech.contains('https')){
      generatedImageUrl = speech;
      generatedContent = null;
      setState(() {});
      await systemSpeak("Here is the image you requested.");
    } else {
      generatedImageUrl = null;
      generatedContent = speech;
      setState(() {});
      await systemSpeak(speech);
    }
  }


  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  Future<void> systemSpeak(String content) async{
    await flutterTts.speak(content);

  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
    flutterTts.stop();
  }

  @override
  Widget build(BuildContext context) {
    final displayContent = generatedContent == null
        ? 'Good Morning, what task can I do for you?'
        : generatedContent!;

    final fontSize = generatedContent == null ? 25.0 : 18.0;

    return Scaffold(
      appBar: AppBar(
        title: BounceInDown(child: const Text('Allen')),
        leading: const Icon(Icons.menu),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Part
            ZoomIn(
              child: Stack(
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
            ),
            //   Chat Bubble
            FadeInRight(
              child: Visibility(
                // Show text bubble if there is content OR if we are showing the default welcome message. Hide if image is shown.
                visible: generatedContent != null || generatedImageUrl == null,
                child: Container(
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
              
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child:  Text(
                        // Use the determined display content
                        generatedContent == null && generatedImageUrl != null
                            ? "Here is the image you requested."
                            : displayContent,
                        style: TextStyle(
                          color: Pallete.mainFontColor,
                          fontSize: fontSize,
                          fontFamily: 'Cera Pro',
                        ),
                      ),
                    )
                ),
              ),
            ),

           

            // Loading Indicator
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),

            // Image display logic
            if(generatedImageUrl != null) Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  generatedImageUrl!,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => const Text('Failed to load image'),
                ),
              ),
            ),
            // Features header
            SlideInLeft(
              child: Visibility(
                visible: generatedContent ==  null && generatedImageUrl == null && !isLoading,
                child: Container(
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
              ),
            ),
            //   Features  List
            Visibility(
              visible: generatedContent == null && generatedImageUrl == null && !isLoading,
              child: Column(
                children: [
                  SlideInLeft(
                    delay: Duration(milliseconds: start),
                    child: const FeatureBox(color: Pallete.firstSuggestionBoxColor,
                      headerText: 'Chat GPT',
                      descriptionText: 'A smarter way to stay organized and informed with Chat GPT',
                    ),
                  ),

                  SlideInLeft(
                    delay: Duration(milliseconds: start + delay),
                    child: const FeatureBox(color: Pallete.secondSuggestionBoxColor,
                      headerText: 'Dall-E',
                      descriptionText: 'Get inspired and stay creative with your personal assistant powered by Dall-E',
                    ),
                  ),

                  SlideInLeft(
                    delay: Duration(milliseconds: start + 2 * delay),
                    child: const FeatureBox(color: Pallete.thirdSuggestionBoxColor,
                      headerText: 'Smart Voice Assitant',
                      descriptionText: 'Get the best of both worlds with a voice assistant powered by Dall-E and Chat GPT',
                    ),
                  )

                ],
              ),
            )
          ],
        ),
      ),

      floatingActionButton: ZoomIn(
        child: FloatingActionButton(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if (speechToText.isListening){
              await stopListening();
            } else if (await speechToText.hasPermission && speechToText.isNotListening){
              await startListening();
            } else{
              await initSpeechToText();
            }
          },
          child: Icon(speechToText.isListening ? Icons.stop : Icons.mic),
        ),
      ),
    );
  }
}