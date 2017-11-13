//
//  NewExternalCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 13/11/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class NewExternalCommand: Command {

    public enum Keys {
        public static let name: String = "name"
        public static let package: String = "package"
        public static let type: String = "type"
        public static let documentation: String = "documentation"
    }

    public enum Options {
        public static let name = OptionDefinition(name: Keys.name, type: .string, isRequired: true, documentation: "The external name, must be unique")
        public static let package = OptionDefinition(name: Keys.package, type: .string, alias: "p", isRequired: true, documentation: "The package of the new external")
        public static let type = OptionDefinition(name: Keys.type,
                                                  type: .string,
                                                  alias: "t",
                                                  defaultValue: External.ExternalType.class.rawValue,
                                                  documentation: "The type of the external object (\(External.ExternalType.all().map { $0.rawValue }.joined(separator: ", ")))")
        public static let documentation = OptionDefinition(name: Keys.documentation, type: .string, alias: "d", documentation: "Description of the given external")
    }

    public enum Consts {
        public static let name: String = "new"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.package,
            PolymorphCommand.Options.file,
            Options.type,
            Options.documentation,
            PolymorphCommand.Options.help
            ], main: Options.name, documentation: "Create a new external object")
    }()

    public func run(_ arguments: [String: Any]) throws {
        guard
            let file = arguments[PolymorphCommand.Keys.file] as? String,
            let name = arguments[Keys.name] as? String,
            let package = arguments[Keys.package] as? String,
            let externalTypeString = arguments[Keys.type] as? String else {
                return
        }
        let project = try ProjectStorage.open(at: file)

        if project.models.findExternal(name: name) != nil {
            throw PolymorphCLIError.externalExists(name: name)
        }

        guard let extType = External.ExternalType(rawValue: externalTypeString) else {
            throw PolymorphCLIError.externalTypeInvalid(value: externalTypeString, info: "Valid type are \(External.ExternalType.all().map { $0.rawValue }.joined(separator: ", "))")
        }

        let e = External(name: name, package: try Package(string: package), type: extType)

        if let documentation = arguments[Keys.documentation] as? String {
            e.documentation = documentation
        }

        project.models.addExternal(e)

        try ProjectStorage.save(project: project, at: file)
    }
}
