# Coffey ☕

A comprehensive iOS learning and financial management platform designed for coffee cooperative members and administrators. Built with SwiftUI and SwiftData, Coffey combines educational content delivery, AI-powered assessments, and personal finance tracking in a single, accessible application.

## Features

### 👥 User Management
- **Dual Role System**: Separate interfaces for cooperative administrators and learners
- **Profile Management**: User profiles with learning scores and progress tracking
- **Cooperative Integration**: Multi-cooperative support with cooperative-specific administration

### 📚 Learning Management
- **Content Delivery**: 
  - Video-based learning modules
  - PDF document support
  - Offline content download and caching
  - Progress tracking (Not Started, In Progress, Completed)
- **AI-Powered Assessments**:
  - Automatic quiz generation using MLX AI models
  - Foundation Models integration for structured quiz creation
  - Real-time scoring and feedback
  - Content-specific questions based on video transcripts

### 💰 Financial Management
- **Personal Finance Tracking**:
  - Income and expense categorization
  - Date-based financial records
  - Category-based organization (Home, Personal, etc.)
  - Receipt scanning with OCR text recognition
  - Financial history and analytics

### 🤖 AI Integration
- **MLX AI Models**: 
  - On-device AI processing using Apple's MLX framework
  - Multiple model support (Llama, Qwen, SmolLM, Gemma)
  - Real-time token streaming
  - Model download progress tracking
  - Custom prompt testing interface
- **Foundation Models**:
  - Structured data generation for quizzes
  - Type-safe AI responses

### 👨‍💼 Administrative Features
- **Content Management**:
  - Upload and manage learning materials
  - Content categorization and organization
  - Download management for offline access
- **User Administration**:
  - View all cooperative members
  - Track individual user progress
  - Monitor learning scores and completion rates
- **Data Synchronization**:
  - Cloud-based data sync with remote API
  - Offline-first architecture
  - Automatic conflict resolution
  - Real-time updates

## Architecture

### Data Layer
- **SwiftData**: Modern persistence framework for local data storage
- **Model Synchronization**: Bidirectional sync between local and remote databases
- **Offline Support**: Full functionality without internet connectivity

### Key Models
- `User`: Learner profiles with progress and scores
- `Admin`: Administrator accounts with cooperative association
- `Content`: Learning materials (videos, PDFs) with metadata
- `Finance`: Personal financial transactions and records
- `Progress`: Content completion tracking per user
- `Quiz`: AI-generated assessments with questions and answers
- `Preference`: User preferences including font size settings

### Services
- **MLXService**: Manages AI model loading, caching, and text generation
- **DownloadManager**: Handles content downloads and offline storage
- **SyncManager**: Coordinates data synchronization across the app
- **APIUtil**: Network communication with REST API backend
- **TextRecognizer**: OCR functionality for receipt scanning

## Technology Stack

- **Framework**: SwiftUI for modern, declarative UI
- **Persistence**: SwiftData for type-safe data management
- **AI/ML**: 
  - MLX (Apple's ML framework) for on-device inference
  - MLXLMCommon for language model operations
  - Foundation Models for structured AI responses
- **Security**: KeychainSwift for secure credential storage
- **Image Processing**: Vision framework for text recognition
- **Networking**: URLSession with async/await

## API Integration

Coffey connects to a REST API backend hosted at `https://coffey-api.vercel.app` with endpoints for:
- User management (`/user`)
- Admin operations (`/admin`)
- Content distribution (`/content`)
- Financial records (`/finance`)
- Progress tracking (`/progress`)
- Preferences (`/preference`)
- Cooperative data (`/cooperativa`)

All endpoints support:
- CRUD operations (GET, POST, PATCH, DELETE)
- Soft deletion with `deletedAt` timestamps
- Optimistic updates with local-first architecture

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+
- Active internet connection for initial setup and sync

## Installation

1. Clone the repository:
```bash
git clone https://github.com/EliteGentro/Coffey.git
cd Coffey
```

2. Open the project in Xcode:
```bash
open Coffey.xcodeproj
```

3. Install Swift Package Dependencies:
   - MLX Swift (Apple's ML framework)
   - MLX Swift Examples (LLM/VLM models)
   - KeychainSwift (Secure storage)

4. Build and run on your device or simulator

## Project Structure

```
Coffey/
├── Model/
│   ├── User.swift, Admin.swift, Content.swift
│   ├── Finance.swift, Progress.swift, Preference.swift
│   ├── Quiz.swift, QuizQuestion.swift, Message.swift
│   └── Extensions/
│       └── Syncable protocols for data synchronization
├── View/
│   ├── AdminViews/
│   │   ├── Content management and user administration
│   │   └── MLXAITest.swift (AI model testing interface)
│   ├── UserViews/
│   │   └── Learning modules, finance tracking, quizzes
│   └── SharedViews/
│       └── Reusable components (PDF viewer, video player)
├── ViewModel/
│   ├── MLXModelViewModel.swift (AI model coordination)
│   ├── QuizViewModel.swift (Assessment generation)
│   └── Data-specific ViewModels for each domain
├── Utils/
│   ├── MLXService.swift (AI model operations)
│   ├── DownloadManager.swift (Content caching)
│   ├── TextRecognizer.swift (OCR functionality)
│   └── Sync/
│       └── API clients and synchronization logic
└── Assets.xcassets/
    └── App icons and images
```

## Key Features in Detail

### AI-Powered Learning
The app uses on-device AI models to generate personalized quizzes based on course content. The MLX framework enables efficient inference directly on the device, ensuring privacy and offline capability.

### Offline-First Architecture
All features work offline with automatic synchronization when connectivity is restored. Content can be downloaded for offline viewing, and all data changes are queued for sync.

### Accessibility
- Customizable font sizes for improved readability
- Text-to-speech support for learning content
- High-contrast UI elements
- VoiceOver compatibility

### Receipt Scanning
Advanced OCR technology extracts financial information from receipt photos, automatically populating transaction details to streamline expense tracking.

## License

This project is proprietary software developed for coffee cooperatives. All rights reserved.

## Contributors

- Humberto Genaro Cisneros Salinas - Developper
- Jorge Adrián De la Garza Flores - Developper
- Daniel Antonio Melgar Orellana - Developper
- José Augusto Orozco Blas - Developper
- Diego Hernández Herrera - Developper

## Support

For issues, questions, or feature requests, please contact the development team or open an issue in the repository.

---

**Built with ❤️ for coffee cooperatives worldwide**
