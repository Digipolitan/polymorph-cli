//
//  NewServiceCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 25/10/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class NewServiceCommand: Command {

    public enum Keys {
        public static let name: String = "name"
        public static let package: String = "package"
        public static let serializer: String = "serializer"
        public static let parser: String = "parser"
        public static let documentation: String = "documentation"
    }

    public enum Options {
        public static let name = OptionDefinition(name: Keys.name, type: .string, isRequired: true, documentation: "The service name, must be unique")
        public static let package = OptionDefinition(name: Keys.package, type: .string, alias: "p", isRequired: true, documentation: "The package of the new service")
        public static let serializer = OptionDefinition(name: Keys.serializer,
                                                        type: .string,
                                                        defaultValue: "json",
                                                        documentation: "Set the default input serializer format for all endpoints (\(Service.Transformer.all().map { $0.rawValue }.joined(separator: ", ")))")
        public static let parser = OptionDefinition(name: Keys.parser,
                                                    type: .string,
                                                    defaultValue: "json",
                                                    documentation: "Set the default output parser format for all endpoints (\(Service.Transformer.all().map { $0.rawValue }.joined(separator: ", ")))")
        public static let documentation = OptionDefinition(name: Keys.documentation, type: .string, alias: "d", documentation: "Description of the given service")
    }

    public enum Consts {
        public static let name: String = "new"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.package,
            PolymorphCommand.Options.file,
            Options.serializer,
            Options.parser,
            Options.documentation,
            PolymorphCommand.Options.help
            ], main: Options.name, documentation: "Create a new service")
    }()

    public func run(_ arguments: [String: Any]) throws {
        /*

        guard
            let file = arguments[PolymorphCommand.Keys.file] as? String,
            let name = arguments[Keys.name] as? String,
            let package = arguments[Keys.package] as? String,
            let serializer = arguments[Keys.serializer] as? String,
            let parser = arguments[Keys.parser] as? String else {
                return
        }
        let project = try ProjectStorage.open(at: file)

        if project.models.findClass(name: name) != nil {
            throw PolymorphCLIError.classExists(name: name)
        }
        Service.Transformer.all().map { $0.rawValue }.joined(separator: ", ")

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
 */
    }
}
