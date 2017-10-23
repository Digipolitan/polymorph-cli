//
//  EnumNewValueCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 07/08/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs
import StringCase

public class EnumNewValueCommand: Command {

    public enum Keys {
        public static let name: String = "name"
        public static let raw: String = "raw"
        public static let targetEnum: String = "enum"
        public static let documentation: String = "documentation"
    }

    public enum Options {
        public static let name = OptionDefinition(name: Keys.name, type: .string, isRequired: true, documentation: "The value name, must be unique by enum")
        public static let targetEnum = OptionDefinition(name: Keys.targetEnum, type: .string, alias: "e", isRequired: true, documentation: "The value will be added to the given enum")
        public static let raw = OptionDefinition(name: Keys.raw, type: .string, alias: "r", documentation: "the raw value associated to the enum")
        public static let documentation = OptionDefinition(name: Keys.documentation, type: .string, alias: "d", documentation: "Description of the given property")
    }

    public enum Consts {
        public static let name: String = "new"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.targetEnum,
            PolymorphCommand.Options.file,
            Options.raw,
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

        guard let target = project.models.findEnum(name: targetEnum) else {
            throw PolymorphCLIError.enumNotFound(name: targetEnum)
        }

        var rawString = arguments[Keys.raw] as? String
        if target.rawType == .int {
            if let raw = rawString, Int(raw) == nil { // reset the rawString if the user write a string with a enum raw type int
                rawString = nil
            }
            if rawString == nil {
                if let last = target.values.last {
                    if let numeric = Int(last.raw) {
                        rawString = "\(numeric + 1)"
                    }
                } else {
                    rawString = "0"
                }
            }
        } else if target.rawType == .string {
            if rawString == nil {
                rawString = name.snakeCased()
            }
        }
        guard let raw = rawString else {
            throw PolymorphCLIError.enumCaseNilValue(name: name)
        }

        var value = Enum.Value(name: name, raw: raw)

        if let d = arguments[Keys.documentation] as? String {
            value.documentation = d
        }

        guard target.addValue(value) else {
            throw PolymorphCLIError.enumValueExists(name: name)
        }

        try ProjectStorage.save(project: project, at: file)
    }
}

