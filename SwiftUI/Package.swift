// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GithubApp",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "SharedModel", targets: ["SharedModel"]),
        .library(name: "SearchRepositoriesFeature", targets: ["SearchRepositoriesFeature"]),
        .library(name: "RepositoryDetailFeature", targets: ["RepositoryDetailFeature"]),
        .library(name: "ApiClient", targets: ["ApiClient"]),
        .library(name: "GithubClient", targets: ["GithubClient"]),
        .library(name: "GithubClientLive", targets: ["GithubClientLive"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.5.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.1.2"),
        .package(url: "https://github.com/ishkawa/APIKit", from: "5.4.0")
    ],
    targets: [
        .target(
            name: "SharedModel",
            dependencies: [
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete"
                ])
            ]
        ),
        .target(
            name: "SearchRepositoriesFeature",
            dependencies: [
                "SharedModel",
                "GithubClient",
                "RepositoryDetailFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete"
                ])
            ]
        ),
        .testTarget(
            name: "SearchRepositoriesFeatureTests",
            dependencies: [
                "SearchRepositoriesFeature",
                "RepositoryDetailFeature",
            ]
        ),
        .target(
            name: "RepositoryDetailFeature",
            dependencies: [
                "SharedModel",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete"
                ])
            ]
        ),
        .target(
            name: "ApiClient",
            dependencies: [
                "SharedModel",
                .product(name: "APIKit", package: "APIKit")
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete"
                ])
            ]
        ),
        .target(
            name: "GithubClient",
            dependencies: [
                "SharedModel",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies")
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete"
                ])
            ]
        ),
        .target(
            name: "GithubClientLive",
            dependencies: [
                "SharedModel",
                "ApiClient",
                "GithubClient",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "APIKit", package: "APIKit")
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete"
                ])
            ]
        )
    ]
)
