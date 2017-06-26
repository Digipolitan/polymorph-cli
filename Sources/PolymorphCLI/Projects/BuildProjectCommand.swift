//
//  BuildProjectCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 21/06/2017.
//

import Foundation
import CommandLineArgs

public class BuildProjectCommand: Command {

    public enum Keys {
        public static let gen: String = "gen"
        public static let platforms: String = "platforms"
    }

    public enum Options {
        public static let gen = OptionDefinition(name: Keys.gen, type: .string, alias: "g", isMultiple: true, documentation: "Select what part of the project to generate such as models, network, etc")
        public static let platforms = OptionDefinition(name: Keys.platforms, type: .string, alias: "p", isMultiple: true, documentation: "Select target platforms, such as ios, android, etc")
    }

    public enum Consts {
        public static let name: String = "build"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.gen,
            Options.platforms,
            PolymorphCommand.Options.help
            ], main: PolymorphCommand.Options.file, documentation: "Generate source code from the given project")
    }()

    public func run(_ arguments: [String : Any]) throws {
        print("BUILD \(arguments)")
    }
}

