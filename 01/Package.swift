// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GithubApp",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Domain", targets: ["Domain"]),
        .library(name: "AppFeature", targets: ["AppFeature"]),
        .library(name: "GithubClient", targets: ["GithubClient"]),
        .library(name: "GithubClientLive", targets: ["GithubClientLive"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.2.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0"),
        .package(url: "https://github.com/ishkawa/APIKit", from: "5.4.0")
    ],
    targets: [
        .target(
            name: "Domain",
            dependencies: [
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-strict-concurrency=complete"
                ])
            ]
        ),
        .target(
            name: "AppFeature",
            dependencies: [
                "Domain",
                "GithubClient"
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
                "Domain",
                .product(name: "Dependencies", package: "swift-dependencies")
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
                "Domain",
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
