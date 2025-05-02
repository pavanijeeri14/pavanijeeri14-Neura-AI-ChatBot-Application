# 🤖✨ Neura AI Chatbot

An intelligent AI-powered chatbot app built using **Flutter**, **Firebase**, and **OpenAI APIs**.  
This app includes multi-modal AI features like image-to-text, text-to-image generation, voice interaction, translation, summarization, and more.

---

## 🚀 Features

- 💬 Conversational AI chatbot (ChatGPT & Gemini)
- 🖼️ Image-to-text using Firebase ML Kit
- 🎨 Text-to-image using HuggingFace API
- ✂️ Text summarization & AI content generation
- 🌍 Multilingual language translator (Google Translate)
- 🗣️ Voice-to-text & text-to-speech (speech module)
- 🧠 Chat history stored in Firebase Firestore
- ✨ Beautiful and responsive UI with Lottie animations

---

## 🧠 APIs & Services Used

 🔹 **Gemini API** – Conversational AI & text summarization  
 🔹 **OpenAI API** – Optional text generation  
 🔹 **HuggingFace API** – Text-to-image generation  
 🔹 **Firebase** – Authentication, Firestore, and ML Kit  
 🔹 **Google Translate API** – Language translation support  

---

## 📦 Flutter Packages Used

```yaml
# Core Flutter
flutter:
  sdk: flutter

# Firebase
firebase_core: ^2.0.0
firebase_auth: ^4.0.0
cloud_firestore: ^4.0.0

# ML & AI
google_mlkit_text_recognition: ^0.4.0
http: ^0.13.4

# AI Chat + APIs
flutter_dotenv: ^5.0.2
provider: ^6.0.0

# Text-to-Speech / Speech-to-Text
flutter_tts: ^3.5.2
speech_to_text: ^5.4.0

# UI/UX
lottie: ^2.2.0
google_fonts: ^4.0.3
font_awesome_flutter: ^10.4.0
animated_text_kit: ^4.2.2
