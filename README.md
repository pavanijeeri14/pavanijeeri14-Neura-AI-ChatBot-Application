# Neura AI Chatbot 🤖✨

A smart AI chatbot built using **Flutter**, **Firebase**, and **OpenAI API**.  
It includes features like text/image-based queries, speech input, summarization, and more.

---

## 🚀 Features

- Conversational AI chatbot (OpenAI)
- Image-to-text using ML Kit
- Text-to-image using Lexica API
- Text summarizer & content generator
- Language translator
- Voice-to-text & text-to-speech (speech module)
- User authentication (Sign up / Sign in with Firebase)
- Chat history stored in Firebase
- Responsive UI with Lottie animations

---

## 📱 Tech Stack

- **Flutter**
- **Dart**
- **Firebase (Auth, Firestore, ML Kit)**
- **OpenAI API**
- **Google Translate API**
- **Lexica API**

---

## 🧠 APIs Used

| API          | Use Case                  |
|--------------|---------------------------|
| OpenAI       | AI Responses & Generation |
| Firebase     | Auth + Firestore storage  |
| ML Kit       | Image-to-Text (OCR)       |
| Lexica       | Text-to-Image generation  |
| Google Translate | Translation support   |

---

## 🛠 Packages Used

```yaml
# pubspec.yaml (only list important ones)
http: ^0.13.4
firebase_core: ^2.0.0
firebase_auth: ^4.0.0
cloud_firestore: ^4.0.0
google_mlkit_text_recognition: ^0.4.0
flutter_tts: ^3.5.2
speech_to_text: ^5.4.0
lottie: ^2.2.0
