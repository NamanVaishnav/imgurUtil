// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "imgurUtil",
    platforms: [
        .iOS(.v13), .macOS(.v12), .macCatalyst(.v13), .tvOS(.v13), .watchOS(.v8)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "imgurUtil",
            targets: ["imgurUtil"]),
        .executable(name: "ImgurUtilExec", targets: ["ImgurUtilExec"])
        
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "imgurUtil"),
        .executableTarget(name: "ImgurUtilExec", 
                          dependencies: ["imgurUtil"]),
        .testTarget(
            name: "imgurUtilTests",
            dependencies: ["imgurUtil"]),
    ]
)
