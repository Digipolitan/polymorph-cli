//
//  RemoveProjectCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 19/06/2017.
//

import Foundation
import CommandLineArgs

public class RemoveProjectCommand: Command {

    public enum Keys {
        public static let file: String = "file"
    }

    public enum Options {
        public static let file = OptionDefinition(name: Keys.file, type: .string, alias: "f", defaultValue: "polymorph.json", documentation: "The project file to remove")
    }

    public enum Consts {
        public static let name: String = "rm"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [PolymorphCommand.Options.help], main: Options.file, documentation: "Delete the polymorph project")
    }()

    public func run(_ arguments: [String : Any]) throws {
        print("RM \(arguments)")
    }
}

