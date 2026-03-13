// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SessionReplayIOS",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "WhatapSessionSnapshot", targets: ["WhatapSessionSnapshot"]),
        .library(name: "WhatapSessionRecorder", targets: ["WhatapSessionRecorder"]),
    ],
    targets: [
        .target(
            name: "WhatapSessionSnapshot",
            dependencies: [],
            path: "WhatapSessionSnapshot/Sources"),
        .target(
            name: "WhatapSessionRecorder",
            dependencies: ["WhatapSessionSnapshot"],
            path: "WhatapSessionRecorder/Sources"),
    ]
)
