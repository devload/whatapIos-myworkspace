// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SessionReplaySample",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "SessionReplaySample",
            targets: ["SessionReplaySample"]),
    ],
    dependencies: [
        .package(path: "../WhatapSessionSnapshot"),
        .package(path: "../WhatapSessionRecorder"),
    ],
    targets: [
        .target(
            name: "SessionReplaySample",
            dependencies: [
                "WhatapSessionSnapshot",
                "WhatapSessionRecorder",
            ],
            path: "SessionReplaySample",
            exclude: ["Info.plist"]),
    ]
)
