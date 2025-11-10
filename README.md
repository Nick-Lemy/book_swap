# BookSwap App

A Flutter-based mobile marketplace application that enables students to exchange textbooks through a swap system. Built with Firebase for backend services and implements real-time synchronization of listings and swap offers.

## Project Description

BookSwap is a peer-to-peer textbook exchange platform where students can:

- List textbooks they want to exchange
- Browse available books from other students
- Initiate swap offers with other users
- Communicate through an integrated chat system
- Track swap history and manage their book inventory

## Features

### Core Features

- **User Authentication**: Email/password authentication with email verification
- **Book Management (CRUD)**:
  - Create: Post books with title, author, condition, category, and cover image
  - Read: Browse all available listings with search and filter
  - Update: Edit your own book listings
  - Delete: Remove your listings
- **Swap System**:
  - Request swaps by selecting a book to offer in exchange
  - Accept or reject incoming swap offers
  - Real-time status updates (Pending, Accepted, Rejected)
- **Chat System**: Real-time messaging between users after swap acceptance
- **User Profiles**: View your profile and other users' profiles with their listings
- **Swap History**: Track completed book exchanges

### Technical Features

- Real-time data synchronization with Firebase Firestore
- State management using Provider pattern
- Image upload and storage via Cloudinary
- Responsive UI with bottom navigation
- Clean architecture with separation of concerns

## Project Structure

```
book_swap/
├── android/                 # Android-specific files
├── lib/
│   ├── constants/          # App constants
│   ├── models/             # Data models
│   ├── providers/          # State management
│   ├── screens/            # UI screens
│   ├── services/           # Backend services
│   ├── widgets/            # Reusable widgets
│   ├── firebase_options.dart
│   └── main.dart
├── web/
├── pubspec.yaml
└── README.md
```

## Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Firebase account
- Cloudinary account (for image uploads)
- Android Studio / VS Code
- Git

## Firebase Setup

### 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project"
3. Enter project name: `book-swap`
4. Follow the setup wizard

### 2. Enable Firebase Services

**Authentication:**

1. In Firebase Console, go to Authentication
2. Click "Get started"
3. Enable "Email/Password" sign-in method

**Firestore Database:**

1. Go to Firestore Database
2. Click "Create database"
3. Start in production mode
4. Choose your region

**Create Firestore Indexes:**

Go to Firestore Database > Indexes and create these composite indexes:

1. Collection: `books`
   - Fields: `category` (Ascending), `createdAt` (Descending)
2. Collection: `books`

   - Fields: `ownerId` (Ascending), `createdAt` (Descending)

3. Collection: `swap_offers`

   - Fields: `receiverId` (Ascending), `dateOffered` (Descending)

4. Collection: `swap_offers`

   - Fields: `requesterId` (Ascending), `dateOffered` (Descending)

5. Collection: `messages`
   - Fields: `conversationId` (Ascending), `timestamp` (Descending)

**Firestore Security Rules:**

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

### 3. Add Firebase to Flutter App

1. Install Firebase CLI:

```bash
npm install -g firebase-tools
```

2. Login to Firebase:

```bash
firebase login
```

3. Install FlutterFire CLI:

```bash
dart pub global activate flutterfire_cli
```

4. Configure Firebase for your Flutter project:

```bash
cd /path/to/book_swap
flutterfire configure
```

5. Select your Firebase project and platforms (Android, iOS, Web)

This will generate `firebase_options.dart` automatically.

### 4. Cloudinary Setup

1. Sign up at [Cloudinary](https://cloudinary.com/)
2. Get your Cloud Name and create an Upload Preset
3. Update `lib/services/cloudinary_service.dart`:

```dart
static const String _cloudName = 'YOUR_CLOUD_NAME';
static const String _uploadPreset = 'YOUR_UPLOAD_PRESET';
```

## Installation and Running

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/book_swap.git
cd book_swap
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

**On Emulator:**

```bash
flutter run
```

**On Physical Device:**

```bash
# Enable USB debugging on your device
flutter devices  # List connected devices
flutter run -d <device-id>
```

## Database Schema

### Collections

**users**

```
{
  uid: String (document ID)
  name: String
  email: String
  avatar: String (optional)
  activeListings: Number
  completedSwaps: Number
  rating: Number
  memberSince: Timestamp
  lastSeen: Timestamp
}
```

**books**

```
{
  id: String (document ID)
  title: String
  author: String
  category: String
  condition: String (New, Like New, Good, Used)
  imageUrl: String (optional)
  ownerId: String
  ownerName: String
  ownerEmail: String
  isAvailable: Boolean
  createdAt: Timestamp
  updatedAt: Timestamp
}
```

**swap_offers**

```
{
  id: String (document ID)
  requesterId: String
  requesterName: String
  requesterEmail: String
  receiverId: String
  receiverName: String
  receiverEmail: String
  requestedBookId: String
  requestedBookTitle: String
  offeredBookId: String
  offeredBookTitle: String
  status: String (pending, accepted, rejected, cancelled)
  dateOffered: Timestamp
  dateResponded: Timestamp (optional)
}
```

**conversations**

```
{
  conversationId: String (document ID)
  participants: Array[String] (user IDs)
  lastMessage: String
  lastMessageTime: Timestamp
  createdAt: Timestamp
}
```

**messages**

```
{
  messageId: String (document ID)
  conversationId: String
  senderId: String
  senderName: String
  message: String
  timestamp: Timestamp
  isRead: Boolean
}
```

**swap_history**

```
{
  id: String (document ID)
  userId: String
  swapPartnerId: String
  swapPartnerName: String
  bookReceivedId: String
  bookReceivedTitle: String
  bookGivenId: String
  bookGivenTitle: String
  swapDate: Timestamp
  rating: Number (optional)
}
```

## State Management

This app uses the Provider pattern for state management:

- **AuthProvider**: Manages authentication state and user sessions
- **BookProvider**: Handles book listings, filtering, and CRUD operations
- **SwapProvider**: Manages swap offers and their states
- **ChatProvider**: Handles conversations and messaging
