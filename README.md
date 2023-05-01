# TMDB Movie Search App

This is a sample iOS app that allows users to search for movies using the TMDB API.

## Prerequisites

To build and run this app, you will need the following:

- Xcode 14.3 or later
- Install the TMDB API client library

## Getting Started

To get started, follow these steps:

1. Clone this repository to your local machine.
2. Install the TMDB API client library using CocoaPods or Swift Package Manager. To use CocoaPods, run `pod install` in the project directory. To use Swift Package Manager, open the project in Xcode and go to File > Swift Packages > Add Package Dependency. Enter the URL of the TMDB API client library and follow the prompts to install it.
3. Set up an API key for the TMDB API. Follow the instructions in the TMDB API documentation to create an account and get an API key.
4. Open the project in Xcode by double-clicking the .xcworkspace file.
5. In Xcode, open the Constants.swift file and replace the `TMDB_API_KEY` constant with your own API key.
6. Build and run the app using the Xcode simulator or a physical device.

## Usage

To use the app, follow these steps:

1. Launch the app on your device or simulator.
2. Use the search bar to enter a query for a movie you want to search for.
3. The app will display a list of search results matching your query. Tap on a search result to view additional details about the movie, including its synopsis and cast members.
4. To add a movie to your favorites, tap on the heart icon.

## Acknowledgments

This app uses the TMDB API to retrieve movie search results. For more information about the TMDB API, see the [official documentation](https://developers.themoviedb.org/3).

## License

This project is licensed under the MIT License. See the LICENSE file for details.
