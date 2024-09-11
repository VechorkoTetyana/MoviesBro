// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Modules",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DesignSystem",
            targets: ["DesignSystem"]),
        .library(
            name: "MoviesBroMovies",
            targets: ["MoviesBroMovies"]),
        .library(
            name: "MoviesBroCore",
            targets: ["MoviesBroCore"]),
        
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "11.1.0"),
        .package(url: "https://github.com/airbnb/lottie-spm.git", from: "4.5.0"),
        .package(url: "https://github.com/marmelroy/PhoneNumberKit", from: "3.7.0"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1")),
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.1.0"),
        .package(url: "https://github.com/Swinject/Swinject.git", .upToNextMajor(from: "2.8.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DesignSystem",
            dependencies: [
                .product(name: "Lottie",package: "lottie-spm"),
                "SnapKit"
            ],
            resources: [
                .process(
                    "Resources"
                )
            ]
        ),
        .target(
            name: "MoviesBroMovies",
            dependencies: [
                "DesignSystem",
                "MoviesBroCore",
                "SDWebImage",
                "Swinject",
                "SnapKit",
                "PhoneNumberKit",
                .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
            ]
        ),
        .target(name: "MoviesBroCore"),
    ]
)
