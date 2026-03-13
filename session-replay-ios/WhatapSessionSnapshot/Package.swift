// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WhatapSessionSnapshot",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "WhatapSessionSnapshot",
            targets: ["WhatapSessionSnapshot"]),
    ],
    targets: [
        .target(
            name: "WhatapSessionSnapshot",
            dependencies: []),
    ]
)
