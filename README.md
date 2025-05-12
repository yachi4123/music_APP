# Music-App


https://github.com/user-attachments/assets/95a58fba-fd8e-4451-8238-42a6988a01d8



MusicApp is a dynamic Flutter application designed to provide an exceptional music experience. It allows users to explore a vast collection of songs and artists through an API, create personalized home pages, manage profiles, add friends, share songs, download music for offline listening, and more.

## Features

- **Dynamic Song and Artist Fetching**: Access a wide range of songs and artists through an API.
- **Personalized Home Page**: Enjoy a home page tailored to your music preferences.
- **Profile Management**: Create and manage your personal profile.
- **Friend System**: Add friends, share songs, and explore music together.
- **Song Sharing**: Share your favorite songs with friends.
- **Offline Listening**: Download songs for offline listening anytime, anywhere.
- **Firebase Authentication**: Securely log in and manage user authentication using Firebase.

## Setup Instructions

### Prerequisites

Before you begin, ensure you have met the following requirements:

- **Flutter**: Make sure Flutter is installed on your system. You can download and install Flutter from [Flutter's official website](https://flutter.dev/docs/get-started/install).
- **Dart**: Dart should be installed along with Flutter. Verify the installation with `flutter doctor`.
- **Android Studio or Xcode**: For building and running the app on Android and iOS devices respectively.

### Installation

1. **Clone the Repository**:
    ```sh
    git clone https://github.com/yourusername/Music-App.git
    cd Music-App
    ```

2. **Install Dependencies**:
    ```sh
    flutter pub get
    ```

3. **Set Up Firebase**:
    - Go to the [Firebase Console](https://console.firebase.google.com/).
    - Create a new project or select an existing project.
    - Add an Android/iOS app to your Firebase project and follow the instructions to download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) file.
    - Place the `google-services.json` file in the `android/app` directory.
    - Place the `GoogleService-Info.plist` file in the `ios/Runner` directory.
    - Ensure your `android/build.gradle` and `android/app/build.gradle` files are updated as per Firebase setup instructions.
    - Update your `ios/Runner/Info.plist` as per Firebase setup instructions.

4. **Configure API Keys**:
    - Ensure you have the necessary API keys for accessing song and artist data.
    - Store your API keys securely and update the relevant parts of the code to use these keys.

### Running the App

1. **Run on an Emulator/Simulator**:
    - **Android**: Open Android Studio, create an Android Virtual Device (AVD), and start the emulator.
    - **iOS**: Open Xcode, create an iOS Simulator, and start the simulator.

2. **Run the App**:
    ```sh
    flutter run
    ```

