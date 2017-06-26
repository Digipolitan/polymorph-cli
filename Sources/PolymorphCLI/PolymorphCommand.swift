//
//  PolymorphCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 23/06/2017.
//

import Foundation
import CommandLineArgs

public class PolymorphCommand: Command {

    public enum Keys {
        public static let help: String = CommandLineArgs.Consts.keys.help
        public static let file: String = "file"
    }

    public enum Options {
        public static let help = OptionDefinition(name: Keys.help, type: .boolean, documentation: "Show help banner of specified command")
        public static let file = OptionDefinition(name: Keys.file, type: .string, alias: "f", defaultValue: "polymorph.json", documentation: "The json file that will contains all project information")
    }

    public enum Consts {
        public static let name: String = "polymorph"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [Options.file, Options.help], documentation: "Command line tools to generate source code files")
    }()

    public func run(_ arguments: [String : Any]) throws {
        throw CommandLineError.unimplementedCommand
    }
}
