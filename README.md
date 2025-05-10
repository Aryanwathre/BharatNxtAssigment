markdown

# Bharat Nxt

Bharat Nxt is a Flutter app that fetches and displays a list of articles from a public API.
It offers a smooth and responsive UI with various features, including article search and a detailed view for each article.

## Features
- Display a list of articles fetched from an external API
- Search functionality to filter articles based on keywords
- Detailed view of each article with more information
- Favourite articles feature to save articles for later
- Fully responsive UI that adapts to different screen sizes

## Setup Instructions
1. Clone the repo:
   git clone https://github.com/Aryanwathre/BharatNxtAssigment.git
   cd BharatNxtAssigment
2. Install dependencies:
   flutter pub get
3. Run the app:
   flutter run

## Tech Stack
- Flutter SDK:  3.29.3
- State Management: Bloc (with Flutter Bloc for event-driven state management)
- HTTP Client: http (for fetching articles from the API)
- Persistence: shared_preferences (for storing liked articles locally)

- ## State Management Explanation
Bloc is used for state management in this app, as it offers a clear and scalable approach to managing the app's state.
We define events (user actions) and states (UI representations) to separate the business logic from the UI code.
This ensures the app is easy to test and maintain, especially as it scales.
The flow of data is handled via Bloc's emit and add methods, making it easy to manage the state of articles, likes, and other user interactions.

## Known Issues / Limitations
- The search functionality only supports basic string matching and may not be fully optimized for larger datasets.
- The app currently does not have pagination for displaying articles, so it may have performance issues with large numbers of articles.
- Error handling for network requests could be improved for a smoother user experience in case of connectivity issues.