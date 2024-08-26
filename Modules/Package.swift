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
            name: "MoviesBroAuthentication",
            targets: ["MoviesBroAuthentication"]),
        .library(
            name: "MoviesBroCore",
            targets: ["MoviesBroCore"]),
        .library(
            name: "MoviesBroLogin",
            targets: ["MoviesBroLogin"]),
        .library(
            name: "MoviesBroSettings",
            targets: ["MoviesBroSettings"]),
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
            name: "MoviesBroAuthentication",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk")
            ]
        ),
        
        .target(name: "MoviesBroCore"),
        
        .target(
            name: "MoviesBroLogin",
            dependencies: [
            "MoviesBroAuthentication",
            "MoviesBroCore",
            "DesignSystem",
            "PhoneNumberKit",
            "Swinject",
            "SnapKit"
            ],
            resources: [
                .process("Resources")
            ]
        ),
     
        .target(
            name: "MoviesBroSettings",
            dependencies: [
            "DesignSystem",
            "MoviesBroAuthentication",
            "MoviesBroCore",
            "SnapKit",
            "Swinject",
            "SDWebImage",
            .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
            .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
            .product(name: "FirebaseStorage", package: "firebase-ios-sdk")
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
