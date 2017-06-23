//
//  UseProjectCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 21/06/2017.
//

import Foundation
import CommandLineArgs

public class UseProjectCommand: Command {

    public enum Keys {
        public static let file: String = "file"
    }

    public enum Options {
        public static let file = OptionDefinition(name: Keys.file, type: .string, alias: "f", defaultValue: "polymorph.json", documentation: "The project file to remove")
    }

    public enum Consts {
        public static let name: String = "use"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            PolymorphCommand.Options.help
            ], main: Options.file, documentation: "Select the project to edit")
    }()

    public func run(_ arguments: [String : Any]) throws {
        print("USE \(arguments)")
    }
}
