// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PolymorphCLI",
    dependencies: [
        .package(url: "https://github.com/Digipolitan/command-line-args.git", from: "1.0.0"),
        .package(url: "https://github.com/Digipolitan/polymorph-swift-gen.git", from: "1.1.0")
        //.package(url: "https://github.com/Digipolitan/polymorph-android-gen.git", .branch("develop"))
    ],
    targets: [
        .target(
            name: "PolymorphCLI",
            dependencies: [
                "CommandLineArgs",
                "PolymorphSwiftGen"
                //"PolymorphAndroidGen"
            ])
    ]
)
