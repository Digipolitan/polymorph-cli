//
//  NewEnumCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 07/08/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class NewEnumCommand: Command {

    public enum Keys {
        public static let name: String = "name"
        public static let rawType: String = "rawType"
        public static let package: String = "package"
        public static let documentation: String = "documentation"
    }

    public enum Options {
        public static let name = OptionDefinition(name: Keys.name, type: .string, isRequired: true, documentation: "The class name, must be unique")
        public static let package = OptionDefinition(name: Keys.package, type: .string, alias: "p", isRequired: true, documentation: "The package of the new enum")
        public static let rawType = OptionDefinition(name: Keys.rawType, type: .string, alias: "rt", defaultValue: "int", documentation: "The raw type of the enum (string or int are available)")
        public static let documentation = OptionDefinition(name: Keys.documentation, type: .string, alias: "d", documentation: "Description of the given enum")
    }

    public enum Consts {
        public static let name: String = "new"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.package,
            Options.rawType,
            PolymorphCommand.Options.file,
            Options.documentation,
            PolymorphCommand.Options.help
            ], main: Options.name, documentation: "Create a new enum")
    }()

    public func run(_ arguments: [String : Any]) throws {
        guard
            let file = arguments[PolymorphCommand.Keys.file] as? String,
            let name = arguments[Keys.name] as? String,
            let package = arguments[Keys.package] as? String,
            let rawTypeString = arguments[Keys.rawType] as? String else {
                return
        }
        let project = try ProjectStorage.open(at: file)

        if project.models.findEnum(name: name) != nil {
            throw PolymorphCLIError.enumExists(name: name)
        }
        guard let rawType = Enum.RawType(rawValue: rawTypeString) else {
            throw PolymorphCLIError.enumRawTypeInvalid(value: rawTypeString, info: "Valid type are string or int")
        }

        let e = Enum(name: name, package: try Package(string: package), rawType: rawType)

        if let documentation = arguments[Keys.documentation] as? String {
            e.documentation = documentation
        }

        project.models.addEnum(e)

        try ProjectStorage.save(project: project, at: file)
    }
}

