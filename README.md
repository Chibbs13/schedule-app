# AI-Powered Schedule Optimizer

An intelligent scheduling application built with Flutter that uses AI to create optimal schedules based on user preferences and constraints.

## Features

- Beautiful, responsive UI with Material Design
- AI-powered schedule optimization
- Real-time schedule visualization
- Export functionality for optimized schedules
- Cross-platform support (iOS, Android, Web)

## Tech Stack

- Frontend: Flutter
- Backend: Python with FastAPI
- AI/ML: Python optimization libraries
- Database: SQLite (for development)

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Python 3.8 or higher
- pip (Python package manager)
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository
2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Install backend dependencies:
   ```bash
   cd backend
   pip install -r requirements.txt
   ```

### Running the Application

1. Start the backend server:
   ```bash
   cd backend
   uvicorn main:app --reload
   ```
2. Run the Flutter app:
   ```bash
   flutter run
   ```

## Project Structure

```
schedule-app/
├── lib/              # Flutter application code
│   ├── screens/     # UI screens
│   ├── widgets/     # Reusable widgets
│   ├── models/      # Data models
│   ├── services/    # API services
│   └── utils/       # Utility functions
├── backend/         # FastAPI backend server
└── README.md       # Project documentation
```

## License

MIT
