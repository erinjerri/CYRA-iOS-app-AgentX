# Create Your Reality Agent (CYRA) App
* Initial prototype with OpenAI. Later version with OpenAI Operator.
* Built for UC Berkeley LLM Agents (Advanced) course, after a hackathon last year (VisionDevCamp winning Best Productivity app for app concept) and undergoing Women in Big Data solopreneurship program.
* This project actually tries to build a real prototype with real data.
This project is a quick MVP for computer use agents and will use Lambda.

### Future Directions
* We also have a web app (Flask), but this has been deprioritized. 
* We will attempt to use iOS with simulator storing task created by user speech input, converted to text (JSON for web app, native iOS eventual macOS and VisionOS app UI with storable text that is saved in Apple Private Cloud via CloudKit). This is then integrated with Instacart to test out performance abilities using Playwright to see if an AI agent is able to handle storing a log of a task, completing a task and switching to another web application.

# Updated File Structure - Tree

CYRA-iOS-app-AgentX/
├── AppDelegate.swift
├── SceneDelegate.swift
├── ViewController.swift
├── AudioRecorder.swift
├── WhisperManager.swift
├── NetworkManager.swift
├── Resources/
│   └── whisper-1.tflite
├── Info.plist
├── .env
├── .gitignore
└── ...

# To-Do List (in this app)
- Audio Recorder in Swift (AVFoundation) - Transcribe audio into iOS
- Whisper + GPT-4o call with audio
- TestFlight deployment

# To-Do List (Future)
-POST data to Flask backend (this is already in other app here: )
-Screenshot to JPEG SwiftUI
-JSON response rendered in UI
 
-Integrate Storage in Lambda to train, LlamaIndex for retrival, Vector DB with Chroma
-Adapt Audio Recorder to VisionOS - cross platform - Transcribe audio from user in Apple Vision Pro - VisionOS
-Handwriting Recognition via MNIST/CoreML (requires entitlements - Apple Office Hours approval
-LangGraph tracing
-Novel 3D Spatial Dataset / Benchmark for tasks emulating WebArena/OSWorld benchmark
