//
//  NewClassCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 26/06/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class NewClassCommand: Command {
    
    public enum Keys {
        public static let name: String = "name"
        public static let package: String = "package"
        public static let extends: String = "extends"
        public static let serializable: String = "serializable"
        public static let injectable: String = "injectable"
        public static let documentation: String = "documentation"
    }

    public enum Options {
        public static let name = OptionDefinition(name: Keys.name, type: .string, isRequired: true, documentation: "The class name, must be unique")
        public static let package = OptionDefinition(name: Keys.package, type: .string, alias: "p", isRequired: true, documentation: "The package of the new class")
        public static let extends = OptionDefinition(name: Keys.extends, type: .string, alias: "e", documentation: "The parent class")
        public static let serializable = OptionDefinition(name: Keys.serializable, type: .boolean, alias: "s", defaultValue: false, documentation: "Mark the class as serializable")
        public static let injectable = OptionDefinition(name: Keys.injectable, type: .boolean, alias: "i", defaultValue: false, documentation: "Mark the class as injectable")
        public static let documentation = OptionDefinition(name: Keys.documentation, type: .string, alias: "d", documentation: "Description of the given class")
    }

    public enum Consts {
        public static let name: String = "new"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.package,
            PolymorphCommand.Options.file,
            Options.extends,
            Options.serializable,
            Options.injectable,
            Options.documentation,
            PolymorphCommand.Options.help
            ], main: Options.name, documentation: "Create a new class")
    }()

    public func run(_ arguments: [String : Any]) throws {
        guard
        let file = arguments[PolymorphCommand.Keys.file] as? String,
        let name = arguments[Keys.name] as? String,
        let package = arguments[Keys.package] as? String,
        let serializable = arguments[Keys.serializable] as? Bool,
        let injectable = arguments[Keys.injectable] as? Bool else {
            return
        }
        let project = try ProjectStorage.open(at: file)

        if project.models.findClass(name: name) != nil {
            throw PolymorphCLIError.classExists(name: name)
        }

        let c = Class(name: name, package: try Package(string: package))

        if let extends = arguments[Keys.extends] as? String {
            if let parent = project.models.findClass(name: extends) {
                c.extends = parent.id
            } else {
                throw PolymorphCLIError.classNotFound(name: extends)
            }
        }

        c.serializable = serializable
        c.injectable = injectable

        if let documentation = arguments[Keys.documentation] as? String {
            c.documentation = documentation
        }

        project.models.addClass(c)

        try ProjectStorage.save(project: project, at: file)
    }
}
