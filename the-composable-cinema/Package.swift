// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "the-composable-cinema",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "Network", targets: ["Network"]),
        .library(name: "NetworkLogger", targets: ["NetworkLogger"]),
        .library(name: "TMDBCore", targets: ["TMDBCore"]),
        .library(name: "TMDBMock", targets: ["TMDBMock"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "Discover", targets: ["Discover"]),
        .library(name: "CategoryPagination", targets: ["CategoryPagination"]),
        .library(name: "Pagination", targets: ["Pagination"]),
        .library(name: "Search", targets: ["Search"]),
        .library(name: "Details", targets: ["Details"]),
        .library(name: "DependencyKeys", targets: ["DependencyKeys"]),
        .library(name: "Entities", targets: ["Entities"]),
        .library(name: "Common", targets: ["Common"]),
        .library(name: "Extensions", targets: ["Extensions"]),
        .library(name: "Resources", targets: ["Resources"])
        
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", exact: "5.9.0"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", exact: "1.9.3"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", exact: "3.0.4")
    ],
    
    targets: [
        .target(
            name: "Network",
            dependencies: [
                "NetworkLogger",
                "TMDBCore",
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]),
        .testTarget(
            name: "NetworkTests",
            dependencies: ["Network"]),
        .target(
          name: "NetworkLogger",
          dependencies: [
            .product(name: "Alamofire", package: "Alamofire")
          ]
        ),
        .target(
          name: "TMDBCore",
          dependencies: [
            .product(name: "Alamofire", package: "Alamofire")
          ]
        ),
        .target(
          name: "TMDBMock",
          dependencies: [
            "Network",
            "TMDBCore"
          ],
          resources: [
              .process("JSONs")
          ]
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "Discover",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .target(
            name: "Discover",
            dependencies: [
                "Network",
                "Entities",
                "DependencyKeys",
                "Common",
                "CategoryPagination",
                "Pagination",
                "Search",
                "Details",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI")
            ]
        ),
        .testTarget(
            name: "DiscoverFeatureTests",
            dependencies: [
                "Discover",
            ]),
        .target(
            name: "CategoryPagination",
            dependencies: [
                "Pagination",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "CategoryPaginationFeatureTests",
            dependencies: [
                "CategoryPagination",
                "Entities",
                "Pagination"
            ]),
        .target(
            name: "Pagination",
            dependencies: [
                "Network",
                "TMDBCore",
                "Entities",
                "DependencyKeys",
                "Common",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ]
        ),
        .testTarget(
            name: "PaginationFeatureTests",
            dependencies: ["Pagination"]
        ),
        .target(
            name: "Search",
            dependencies: [
                "Network",
                "TMDBCore",
                "Entities",
                "DependencyKeys",
                "Pagination",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Alamofire", package: "Alamofire")
            ]
        ),
        .testTarget(
            name: "SearchFeatureTests",
            dependencies: ["Search"]
        ),
        .target(
            name: "Details",
            dependencies: [
                "Network",
                "Entities",
                "DependencyKeys",
                "Common",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Alamofire", package: "Alamofire"),
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI")
            ]
        ),
        .testTarget(
            name: "DetailsFeatureTests",
            dependencies: [
                "Details",
            ]),
        .target(
            name: "DependencyKeys",
            dependencies: [
                "Network",
                "TMDBCore",
                "TMDBMock",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "Entities",
            dependencies: [
                "Network",
                "Extensions",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]
        ),
        .target(
            name: "Common",
            dependencies: [
                "TMDBCore",
                "Entities",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "SDWebImageSwiftUI", package: "SDWebImageSwiftUI")
            ]
        ),
        .target(
            name: "Extensions",
            dependencies: [
                "Resources"
            ]
        ),
        .target(
            name: "Resources",
            resources: [
                .process("Fonts")
            ]
        )
    ]
)

