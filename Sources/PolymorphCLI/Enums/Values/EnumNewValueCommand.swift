//
//  EnumNewValueCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 07/08/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class EnumNewValueCommand: Command {

    public enum Keys {
        public static let name: String = "name"
        public static let numeric: String = "numeric"
        public static let targetEnum: String = "enum"
        public static let documentation: String = "documentation"
    }

    public enum Options {
        public static let name = OptionDefinition(name: Keys.name, type: .string, isRequired: true, documentation: "The value name, must be unique by enum")
        public static let targetEnum = OptionDefinition(name: Keys.targetEnum, type: .string, alias: "e", isRequired: true, documentation: "The value will be added to the given enum")
        public static let numeric = OptionDefinition(name: Keys.numeric, type: .int, alias: "n", documentation: "the numeric value associated to the enum")
        public static let documentation = OptionDefinition(name: Keys.documentation, type: .string, alias: "d", documentation: "Description of the given property")
    }

    public enum Consts {
        public static let name: String = "new"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.targetEnum,
            PolymorphCommand.Options.file,
            Options.numeric,
            Options.documentation,
            PolymorphCommand.Options.help
            ], main: Options.name, documentation: "Create a new value")
    }()

    public func run(_ arguments: [String : Any]) throws {
        guard
            let file = arguments[PolymorphCommand.Keys.file] as? String,
            let name = arguments[Keys.name] as? String,
            let targetEnum = arguments[Keys.targetEnum] as? String else {
                return
        }

        let project = try ProjectStorage.open(at: file)

        guard var target = project.models.findEnum(name: targetEnum) else {
            throw PolymorphCLIError.enumNotFound(name: targetEnum)
        }

        var numeric: Int = 0
        if let n = arguments[Keys.numeric] as? Int {
            numeric = n
        } else if let last = target.values.last {
            numeric = last.numeric + 1
        }

        var value = Enum.Value(name: name, numeric: numeric)

        if let d = arguments[Keys.documentation] as? String {
            value.documentation = d
        }

        guard target.addValue(value) else {
            throw PolymorphCLIError.enumValueExists(name: name)
        }

        project.models.updateObject(target)

        try ProjectStorage.save(project: project, at: file)
    }
}

