# SwiftUI Cinema TCA

![Alt text](https://i.ibb.co/V3JGCb3/makephotogallery-net-1715010578033.png)


SwiftUI Cinema TCA is a modular iOS application developed with SwiftUI and The Composable Architecture. This application demonstrates a sophisticated approach to managing state, actions, and the environment using TCA, structured in a modular way to support scalability and maintainability.

## Features

- **Browse Content**: Users can explore a variety of movies and TV shows categories.
- **Detailed Information**: Details about each movie or TV show.
- **Search Capability**: Includes a feature to search content by title.
- **Similar**: Suggestions to related content (movie / TV show)

## Modules

The application is structured into several modules, each responsible for handling specific aspects:

- **Network**: Manages all network communications.
- **NetworkLogger**: Provides network request and response logging.
- **TMDBCore**: Core module for interacting with The Movie Database (TMDB).
- **TMDBMock**: Supplies mock data for testing.
- **AppFeature**: Incorporates the main features of the app.
- **Discover**: Manages discovery features for new content.
- **CategoryPagination**: Handles pagination within specific categories.
- **Pagination**: General functionality for pagination.
- **Search**: Implements the search functionality.
- **Details**: Provides detailed views of movies and TV shows.
- **DependencyKeys**: Manages keys for dependency injections.
- **Entities**: Defines entities used throughout the app.
- **Common**: Shared utilities, helper functions and views.
- **Extensions**: Extensions for Swift types to enhance functionality.
- **Resources**: Handles static resources like fonts and images.

## Installation

Clone the repository and open the project in Xcode to get started

## Dependencies

This project makes use of:

- **[Alamofire](https://github.com/Alamofire/Alamofire)**: For network requests.
- **[The Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)**: For managing application state in a reactive manner.
- **[SDWebImageSwiftUI](https://github.com/SDWebImage/SDWebImageSwiftUI)**: For efficient image handling in SwiftUI.

## Contributing

Contributions to SwiftUI Cinema TCA are welcome! Please consider contributing if you think you can improve the app or implement new features.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
