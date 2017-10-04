//
//  BuildCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 21/06/2017.
//

import Foundation
import PolymorphCore
import PolymorphGen
import PolymorphSwiftGen
//import PolymorphAndroidGen
import CommandLineArgs

public class BuildCommand: Command {

    fileprivate let platforms: [PlatformGen.Type] = [
        SwiftPlatformGen.self,
        //AndroidPlatformGen.self,
    ]

    public enum Keys {
        public static let gen: String = "gen"
        public static let platforms: String = "platforms"
    }

    public enum Options {
        public static let gen = OptionDefinition(name: Keys.gen, type: .string, alias: "g", isMultiple: true, documentation: "Select what part of the project to generate such as models, network, etc")
    }

    public enum Consts {
        public static let name: String = "build"
    }

    public lazy var definition: CommandDefinition = {

        let platforms = OptionDefinition(name: Keys.platforms, type: .string, alias: "p", isMultiple: true, documentation: "Select target platforms: \(self.platforms.map { $0.name.lowercased() }.joined(separator: ", ")), ignore this options to build all platforms")

        return CommandDefinition(name: Consts.name, options: [
            Options.gen,
            platforms,
            PolymorphCommand.Options.help
            ], main: PolymorphCommand.Options.file, documentation: "Generate source code from the given project")
    }()

    public func run(_ arguments: [String : Any]) throws {
        guard
            let file = arguments[PolymorphCommand.Keys.file] as? String else {
                return
        }
        let project = try ProjectStorage.open(at: file)

        let platforms = self.platforms(using: arguments[Keys.platforms] as? [String])
        guard platforms.count > 0 else {
            print("No platform found to build using your filter")
            return
        }
        let generator = PolymorphGen(platforms: platforms)
        try generator.generate(project, options: .init(path: "./build"))
        print("Successfully build \(platforms.map { $0.name }.joined(separator: ", ")) platform(s)")
    }

    fileprivate func platforms(using filters: [String]?) -> [PlatformGen.Type] {
        guard let filters = filters else {
            return self.platforms
        }
        return self.platforms.filter({ (platform) -> Bool in
            for name in filters {
                if platform.name.lowercased() == name.lowercased() {
                    return true
                }
            }
            return false
        })
    }
}
