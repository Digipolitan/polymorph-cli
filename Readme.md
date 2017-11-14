PolymorphCLI
=================================

[![Swift Version](https://img.shields.io/badge/swift-4.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Swift Package Manager](https://rawgit.com/jlyonsmith/artwork/master/SwiftPackageManager/swiftpackagemanager-compatible.svg)](https://swift.org/package-manager/)
[![Twitter](https://img.shields.io/badge/twitter-@Digipolitan-blue.svg?style=flat)](http://twitter.com/Digipolitan)

## Installation

* From source

First Download the source code & unzip it, after that run the following command inside the root directory
```sh
$ swift build -c release -Xswiftc -static-stdlib
```

This command build the polymorph application in the following directory
`./.build/x86_64-apple-macosx10.10/release/PolymorphCLI`

After that move this binary inside the `/usr/local/bin` directory as follow
```sh
$ sudo mv ./.build/x86_64-apple-macosx10.10/release/PolymorphCLI /usr/local/bin/polymorph
```

* With artifact

Download the artifact associated to the GitHub release and move it to `/usr/local/bin/polymorph` in your computer

## usage

```sh
$ polymorph --help
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for more details!

This project adheres to the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).
By participating, you are expected to uphold this code. Please report
unacceptable behavior to [contact@digipolitan.com](mailto:contact@digipolitan.com).

## License

PolymorphCLI is licensed under the [BSD 3-Clause license](LICENSE).
