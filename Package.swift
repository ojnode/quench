// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "quench",
    platforms: [
        .iOS(.v14) // Adjust according to your project's requirements
    ],
    products: [
        .library(
            name: "quench",
            targets: ["quench"]),
    ],
    dependencies: [
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.15.3"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0") // Use the proper version
    ],
    targets: [
        .target(
            name: "quench",
            dependencies: [
                "SQLite",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseDatabase", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk")
                // Add other Firebase products as needed
            ]),
        .testTarget(
            name: "quenchTests",
            dependencies: ["quench"]),
    ]
)
