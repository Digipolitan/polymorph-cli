//
//  UpdateExternalCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 14/11/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class UpdateExternalCommand: Command {

    public enum Keys {
        public static let name: String = "name"
        public static let rename: String = "rename"
        public static let package: String = "package"
        public static let type: String = "type"
        public static let documentation: String = "documentation"
    }

    public enum Options {
        public static let name = OptionDefinition(name: Keys.name, type: .string, isRequired: true, documentation: "The external name, must be unique")
        public static let rename = OptionDefinition(name: Keys.rename, type: .string, documentation: "The new external name, must be unique")
        public static let package = OptionDefinition(name: Keys.package, type: .string, alias: "p", documentation: "The package of external")
        public static let type = OptionDefinition(name: Keys.type,
                                                  type: .string,
                                                  alias: "t",
                                                  documentation: "The type of the external object (\(External.ExternalType.all().map { $0.rawValue }.joined(separator: ", ")))")
        public static let documentation = OptionDefinition(name: Keys.documentation, type: .string, alias: "d", documentation: "Description of the given external")
    }

    public enum Consts {
        public static let name: String = "update"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.rename,
            Options.package,
            PolymorphCommand.Options.file,
            Options.type,
            Options.documentation,
            PolymorphCommand.Options.help
            ], main: Options.name, documentation: "Update external information")
    }()

    public func run(_ arguments: [String: Any]) throws {
        guard
            let file = arguments[PolymorphCommand.Keys.file] as? String,
            let name = arguments[Keys.name] as? String else {
                return
        }
        let project = try ProjectStorage.open(at: file)

        guard let e = project.models.findExternal(name: name) else {
            throw PolymorphCLIError.externalNotFound(name: name)
        }

        if let rename = arguments[Keys.rename] as? String {
            e.name = rename
        }

        if let package = arguments[Keys.package] as? String {
            e.package = try Package(string: package)
        }

        if let externalTypeString = arguments[Keys.type] as? String {
            guard let extType = External.ExternalType(rawValue: externalTypeString) else {
                throw PolymorphCLIError.externalTypeInvalid(value: externalTypeString, info: "Valid type are \(External.ExternalType.all().map { $0.rawValue }.joined(separator: ", "))")
            }
            e.type = extType
        }

        if let documentation = arguments[Keys.documentation] as? String {
            e.documentation = PolymorphCommand.transformNil(string: documentation)
        }

        try ProjectStorage.save(project: project, at: file)
    }
}
