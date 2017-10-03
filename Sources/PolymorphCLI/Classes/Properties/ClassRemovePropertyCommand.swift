//
//  ClassRemovePropertyCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 07/08/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class ClassRemovePropertyCommand: Command {

    public enum Keys {
        public static let name: String = "name"
        public static let targetClass: String = "class"
    }

    public enum Options {
        public static let name = OptionDefinition(name: Keys.name, type: .string, isRequired: true, documentation: "The property name, must be unique by class")
        public static let targetClass = OptionDefinition(name: Keys.targetClass, type: .string, alias: "c", isRequired: true, documentation: "The property will be added to the given class")
    }

    public enum Consts {
        public static let name: String = "rm"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.targetClass,
            PolymorphCommand.Options.file,
            PolymorphCommand.Options.help
            ], main: Options.name, documentation: "Remove a property")
    }()

    public func run(_ arguments: [String : Any]) throws {
        guard
            let file = arguments[PolymorphCommand.Keys.file] as? String,
            let name = arguments[Keys.name] as? String,
            let targetClass = arguments[Keys.targetClass] as? String else {
                return
        }

        let project = try ProjectStorage.open(at: file)

        guard let target = project.models.findClass(name: targetClass) else {
            throw PolymorphCLIError.classNotFound(name: targetClass)
        }

        guard target.removeProperty(name: name) else {
            throw PolymorphCLIError.propertyNotFound(name: name)
        }

        try ProjectStorage.save(project: project, at: file)
    }
}
