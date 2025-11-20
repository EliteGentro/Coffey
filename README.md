# Coffey ☕

A SwiftUI-based iOS application for cooperative financial education and management, built with SwiftData for local persistence and REST API synchronization.

## Overview

Coffey is designed to help coffee cooperative members learn about financial literacy, track their finances, and manage their learning progress. The app features separate interfaces for administrators and users (cooperative members), with comprehensive sync capabilities between local SwiftData storage and a remote backend.

## Features

### For Users (Cooperative Members)
- 📚 **Learning Modules** - Access educational content about financial literacy, savings culture, and investment
- 📊 **Finance Tracking** - Record and categorize income and expenses
- ✅ **Progress Tracking** - Monitor learning progress across different content modules
- 📝 **Quizzes** - Test knowledge with AI-generated quizzes based on content
- 🎬 **Multimedia Content** - Watch videos and read PDFs directly in the app
- ⚙️ **Accessibility** - Adjustable font sizes for better readability

### For Administrators
- 👥 **User Management** - Add and manage cooperative members
- 📖 **Content Management** - Manage educational content library
- 🔄 **Synchronization** - Sync data between local storage and remote server
- 🔐 **PIN Authentication** - Secure access with encrypted PIN storage

## Architecture

### MVVM Pattern
The app follows the Model-View-ViewModel (MVVM) architecture:

```
Coffey/
├── Model/              # Data models with SwiftData persistence
├── View/              # SwiftUI views
│   ├── AdminViews/    # Administrator interface
│   ├── UserViews/     # User interface
│   └── SharedViews/   # Reusable components
├── ViewModel/         # Business logic and state management
└── Utils/            # Helper utilities and sync infrastructure
```

### Core Technologies
- **SwiftUI** - Modern declarative UI framework
- **SwiftData** - Apple's native persistence framework
- **Combine** - Reactive programming for async operations
- **URLSession** - Network communication with REST API

## Data Models

All models support CRUD operations with automatic timestamp tracking (`updatedAt`, `deletedAt`):

- **User** - Cooperative members with learning scores
- **Admin** - Administrative users with secure PIN authentication
- **Content** - Educational materials (videos, PDFs)
- **Finance** - Income and expense records
- **Progress** - Learning progress tracking
- **Preference** - User settings and preferences
- **Cooperativa** - Cooperative organization details

## Synchronization System

The app features a robust sync system that:

1. **Local-First** - Works offline with SwiftData persistence
2. **Conflict Resolution** - Uses timestamps to resolve sync conflicts
3. **Incremental Sync** - Only syncs changed data
4. **Soft Delete** - Marks items as deleted before removing them

### Sync Architecture

```swift
// Generic sync protocol
protocol Syncable {
    var remoteID: IDType { get set }
    var updatedAt: Date? { get set }
    var deletedAt: Date? { get set }
}

// API protocol for each model
protocol SyncAPI {
    func fetchAll() async throws -> [Model]
    func fetchDeleted() async throws -> [Model]
    func create(_ local: Model) async throws -> Model
    func update(_ local: Model) async throws
    func delete(_ local: Model) async throws
}
```

## API Integration

Base URL: `https://coffey-api.vercel.app`

### Endpoints
- `/admin` - Admin management
- `/user` - User management
- `/content` - Learning content
- `/finance` - Financial records
- `/progress` - Learning progress
- `/preference` - User preferences
- `/cooperativa` - Cooperative details

Each endpoint supports:
- `GET /` - Fetch all records
- `GET /deleted` - Fetch soft-deleted records
- `POST /` - Create new record
- `PATCH /:id` - Update existing record
- `DELETE /:id` - Soft delete record

## Setup & Installation

### Prerequisites
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Dependencies
- **KeychainSwift** - Secure PIN storage
- **PDFKit** - PDF viewing
- **AVKit** - Video playback

### Installation

1. Clone the repository:
```bash
git clone https://github.com/EliteGentro/Coffey.git
cd Coffey
```

2. Open the project in Xcode:
```bash
open Coffey.xcodeproj
```

3. Build and run the project (⌘R)

## Testing

The project includes unit tests for:
- Model validation
- API connectivity
- Data decoding
- Financial calculations

Run tests with ⌘U in Xcode or:
```bash
xcodebuild test -scheme Coffey -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Security Features

- **PIN Authentication** - Admins protected by hashed PIN codes stored in Keychain
- **Local Data Encryption** - SwiftData encrypted storage
- **Secure API Communication** - HTTPS for all network requests

## Key Components

### Content Management
- Download and cache multimedia content
- Track download status per content item
- Support for both video and PDF formats

### Financial Tracking
- Categorized income/expense tracking
- Date validation (no future dates)
- User-specific financial records

### Learning Progress
- Three status levels: Not Started, In Progress, Completed
- Grade tracking for completed quizzes
- Content-specific progress per user

## Code Quality

### Swift 6 Compliance
- Removed `@preconcurrency` attributes for SwiftData models
- Separated Codable conformance to avoid Sendable conflicts
- Proper concurrency handling with `@MainActor`

### Patterns Used
- Repository pattern for data access
- Protocol-oriented programming for sync system
- Dependency injection for testability
- Extension-based feature organization

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Future Enhancements

- [ ] Background sync with `BackgroundTasks`
- [ ] Push notifications for new content
- [ ] Export financial reports to CSV/PDF
- [ ] Multi-language support (Spanish, English)
- [ ] Dark mode optimization
- [ ] Analytics dashboard for admins
- [ ] Offline quiz generation caching

## License

This project is part of academic work at [Your Institution]. All rights reserved.

## Authors

- Humberto Genaro Cisneros Salinas

## Acknowledgments

- Coffee cooperative organizations for domain expertise
- Apple SwiftData team for the modern persistence framework
- Open source community for various utility libraries

---

**Version:** 1.0  
**Last Updated:** November 2025  
**Platform:** iOS 17.0+
