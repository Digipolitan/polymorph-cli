// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.


import PackageDescription

let package = Package(
    name: "PolymorphCLI",
    dependencies: [
        .package(url: "https://github.com/Digipolitan/polymorph-core.git", .branch("master")),
        .package(url: "https://github.com/Digipolitan/command-line-args.git", .branch("master")),
        .package(url: "https://github.com/Digipolitan/polymorph-swift-gen.git", .branch("master")),
        .package(url: "https://github.com/Digipolitan/polymorph-android-gen.git", .branch("master"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "PolymorphCLI",
            dependencies: [
                "PolymorphCore",
                "CommandLineArgs",
                "PolymorphSwiftGen",
                "PolymorphAndroidGen"
            ]),
    ]
)
