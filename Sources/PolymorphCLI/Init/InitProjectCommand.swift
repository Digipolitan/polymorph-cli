//
//  InitProjectCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 19/06/2017.
//

import Foundation
import CommandLineArgs

public class InitProjectCommand: Command {

    public enum Keys {
        public static let package: String = "package"
        public static let copyright: String = "copyright"
        public static let author: String = "author"
        public static let documentation: String = "documentation"
        public static let file: String = "file"
        public static let name: String = "name"
    }

    public enum Options {
        public static let package = OptionDefinition(name: Keys.package, type: .string, alias: "p", isRequired: true, documentation: "The project main package")
        public static let copyright = OptionDefinition(name: Keys.copyright, type: .string, alias: "c", documentation: "Your company copyright")
        public static let author = OptionDefinition(name: Keys.author, type: .string, alias: "a", documentation: "The author of all generated files")
        public static let documentation = OptionDefinition(name: Keys.documentation, type: .string, alias: "d", documentation: "Project information")
        public static let file = OptionDefinition(name: Keys.file, type: .string, alias: "f", documentation: "The json file that will contains all project information")
        public static let name = OptionDefinition(name: Keys.name, type: .string, documentation: "The project name")
    }

    public enum Consts {
        public static let name: String = "init"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.package,
            Options.file,
            Options.author,
            Options.copyright,
            Options.documentation,
            PolymorphCommand.Options.help
            ], main: Options.name, documentation: "The project starter")
    }()

    public func run(_ arguments: [String : Any]) throws {
        print("INIT \(arguments)")
    }
}
