// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GBHFacebookImagePicker",
    platforms: [.iOS(.v12)],
    products: [
        .library(name: "GBHFacebookImagePicker", targets: ["GBHFacebookImagePicker"]),
    ],
    
    dependencies: [
        .package(url: "https://github.com/facebook/facebook-ios-sdk",
                 from: "16.0.0")
    ],
    targets: [
        .target(name: "GBHFacebookImagePicker",
                dependencies: [
                    .product(name: "FacebookCore", package: "facebook-ios-sdk"),
                    .product(name: "FacebookLogin", package: "facebook-ios-sdk")
                ],
                resources: [.process("Resources")],
                publicHeadersPath: "."
        ),
    ]
)
