# ARMusic Game

Welcome to the ARMusic Game repository! This project is an augmented reality music game that immerses players in music and jingle creation, utilizing the pentatonic scale and allowing for modifications of pitch and tempo. Players explore an interactive musical environment where they perceive changes in sound and visuals as they walk around their creations.

## Architecture

The project is designed using MV+ECS architecture with package orientation to ensure modularity and ease of deployment across multiple devices, including iPadOS.

### Project Structure

- **iPadOSTarget**: The main target for the game, optimized for iPadOS.
- **CorePackage**: Contains the core logic and utilities shared across the application.
- **ARPackage**: Manages the augmented reality features and functionalities.
- **AudioPackage**: Handles all audio-related functionalities, including music creation and playback.
- **DataPackage**: Manages data storage, retrieval, and manipulation.

## Packages

### Core Package
This package includes:
- Application utilities
- Core logic
- Shared resources

### AR Package
This package includes:
- AR scene management
- AR interaction handling
- AR visualization tools

### Audio Package
This package includes:
- Audio playback
- Music creation tools
- Pitch and tempo modification

### Data Package
This package includes:
- Data models
- Data persistence
- Data manipulation utilities

### Pull Request and Branch Schema

- **Branches**:
  - `main`: The main stable branch.
  - `develop`: Development branch for integrating features.
  - `feature/<feature-name>`: New features.
  - `bugfix/<bugfix-name>`: Bug fixes.
  - `release/<version>`: Release preparation.

- **Pull Request Process**:
  1. Create a branch from `develop` for your feature or bugfix.
  2. Implement your changes and commit them to your branch.
  3. Push your branch to the repository.
  4. Open a pull request against the `develop` branch.
  5. Request a review and address any feedback.
  6. Merge the pull request once approved.
