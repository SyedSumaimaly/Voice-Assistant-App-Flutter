# 🗣️ Voice Assistant App - Flutter

This repository hosts a mobile application built with **Flutter** that serves as a **Voice Assistant**. It enables users to interact with the app using voice commands, leveraging Speech-to-Text (STT) and Text-to-Speech (TTS) technologies. This application demonstrates the integration of conversational AI into a cross-platform mobile environment.

-----

## ✨ Features

The application provides a seamless voice-activated experience, potentially including:

  * **🎙️ Voice Input:** Uses the device microphone to capture user speech in real-time (Speech-to-Text).
  * **🤖 Intelligent Response:** Processes the voice input, often via an external AI service (like a custom API or a service like OpenAI's ChatGPT/Gemini), to generate a relevant text response.
  * **🔊 Voice Output:** Converts the generated text response back into natural-sounding speech (Text-to-Speech) for an audible reply.
  * **UI Feedback:** Provides visual cues and animations when the assistant is listening or processing a command.
  * **Cross-Platform Support:** Built with Flutter for deployment on both **Android** and **iOS** platforms.

-----

## 🛠️ Technology Stack

| Category | Technology | Description |
| :--- | :--- | :--- |
| **Framework** | **Flutter** | UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase. |
| **Language** | **Dart** | The programming language used by Flutter. |
| **Core Packages** | `speech_to_text`, `flutter_tts` | Common libraries for handling STT and TTS functionalities. |
| **AI/API Integration** | (Likely **`http`** or **`dio`** package) | Used to communicate with a third-party AI service (e.g., OpenAI, Google Gemini, or a custom backend). |

-----

## 🚀 Getting Started

Follow these steps to set up and run the Voice Assistant application locally.

### Prerequisites

1.  **Flutter SDK:** Ensure Flutter is installed and configured correctly.
2.  **IDE:** Visual Studio Code or Android Studio with Flutter/Dart plugins installed.
3.  **API Key:** If the application uses a third-party service (e.g., OpenAI), you will need to obtain and configure the necessary API key.

### Installation

1.  **Clone the repository:**

    ```bash
    git clone https://github.com/SyedSumaimaly/Voice-Assistant-App-Flutter.git
    cd Voice-Assistant-App-Flutter
    ```

2.  **Install dependencies:**

    ```bash
    flutter pub get
    ```

3.  **Set Environment Variables (If Applicable):**
    If the project uses environment variables (e.g., for an OpenAI or Gemini API Key), you'll need to create a configuration file (like a `.env` file) and provide the keys.

4.  **Configure Permissions (Crucial for Voice Apps):**

      * **Android:** Ensure the `android/app/src/main/AndroidManifest.xml` file contains the required audio recording permission:
        ```xml
        <uses-permission android:name="android.permission.RECORD_AUDIO" />
        ```
      * **iOS:** Add a description for microphone usage in `ios/Runner/Info.plist`:
        ```xml
        <key>NSMicrophoneUsageDescription</key>
        <string>This app needs access to your microphone to listen for your voice commands.</string>
        ```

5.  **Run the App:**
    Connect a device or launch an emulator, then run the app:

    ```bash
    flutter run
    ```

-----

## 💡 Usage

1.  Tap the dedicated microphone button (or wait for the app to enter listening mode).
2.  Speak your command or question clearly.
3.  The app will display the transcribed text and speak the AI's response.

-----

## 📧 Contact

Syed Sumaim Aly - [www.linkedin.com/in/syed-sumaim-ali]

Project Link: [https://github.com/SyedSumaimaly/Voice-Assistant-App-Flutter](https://github.com/SyedSumaimaly/Voice-Assistant-App-Flutter)

