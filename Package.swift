// swift-tools-version: 5.6

import PackageDescription

let package = Package(
  name: "WYrand",
  products: [
    .library(name: "WYrand", targets: ["WYrand"]),
  ],
  dependencies: [],
  targets: [
    .target(name: "WYrand", dependencies: []),
    .testTarget(name: "WYrandTests", dependencies: ["WYrand"]),
  ]
)
