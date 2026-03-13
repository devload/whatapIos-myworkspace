// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WhatapSessionRecorder",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "WhatapSessionRecorder",
            targets: ["WhatapSessionRecorder"]),
    ],
    dependencies: [
        .package(path: "../WhatapSessionSnapshot"),
    ],
    targets: [
        .target(
            name: "WhatapSessionRecorder",
            dependencies: ["WhatapSessionSnapshot"]),
    ]
)
