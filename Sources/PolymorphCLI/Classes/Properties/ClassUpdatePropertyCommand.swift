//
//  ClassUpdatePropertyCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 26/06/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class ClassUpdatePropertyCommand: Command {

    public enum Keys {
        public static let name: String = "name"
        public static let rename: String = "rename"
        public static let type: String = "type"
        public static let key: String = "key"
        public static let genericTypes: String = "genericTypes"
        public static let nonnull: String = "nonnull"
        public static let primary: String = "primary"
        public static let transient: String = "transient"
        public static let targetClass: String = "class"
        public static let documentation: String = "documentation"
    }

    public enum Options {
        public static let name = OptionDefinition(name: Keys.name, type: .string, isRequired: true, documentation: "The property name to be updated")
        public static let rename = OptionDefinition(name: Keys.rename, type: .string, documentation: "The new property name, must be unique by class")
        public static let type = OptionDefinition(name: Keys.type, type: .string, alias: "t", documentation: "The property type")
        public static let targetClass = OptionDefinition(name: Keys.targetClass, type: .string, alias: "c", isRequired: true, documentation: "The property will be added to the given class")
        public static let key = OptionDefinition(name: Keys.key, type: .string, alias: "k", documentation: "The property mapping key")
        public static let genericTypes = OptionDefinition(name: Keys.genericTypes, type: .string, alias: "gts",  isMultiple: true, documentation: "List of generic types")
        public static let nonnull = OptionDefinition(name: Keys.nonnull, type: .boolean, alias: "nn", documentation: "Mark the property nonnull")
        public static let primary = OptionDefinition(name: Keys.primary, type: .boolean, alias: "p", documentation: "Mark the property primary")
        public static let transient = OptionDefinition(name: Keys.transient, type: .boolean, documentation: "Mark the property transient")
        public static let documentation = OptionDefinition(name: Keys.documentation, type: .string, alias: "d", documentation: "Description of the given property")
    }

    public enum Consts {
        public static let name: String = "update"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.rename,
            Options.type,
            Options.key,
            Options.targetClass,
            PolymorphCommand.Options.file,
            Options.genericTypes,
            Options.nonnull,
            Options.primary,
            Options.transient,
            Options.documentation,
            PolymorphCommand.Options.help
            ], main: Options.name, documentation: "Update given property")
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

        guard let property = target.findProperty(name: name) else {
            throw PolymorphCLIError.propertyNotFound(name: name)
        }

        if let type = arguments[Keys.type] as? String {
            guard let typeObject = project.findNative(name: type) as? Object ?? project.models.findObject(name: type) else {
                throw PolymorphCLIError.objectNotFound(name: type)
            }
            property.type = typeObject.id
        }

        if let nonnull = arguments[Keys.nonnull] as? Bool {
            property.isNonnull = nonnull
        }
        if let transient = arguments[Keys.transient] as? Bool {
            property.isTransient = transient
        }
        if let primary = arguments[Keys.primary] as? Bool {
            property.isPrimary = primary
        }
        if let key = arguments[Keys.key] as? String {
            property.mapping = Property.Mapping(key: key)
        }

        if let generics = arguments[Keys.genericTypes] as? [String] {
            property.genericTypes = try generics.map {
                guard let type = project.findNative(name: $0) as? Object ?? project.models.findObject(name: $0) else {
                    throw PolymorphCLIError.objectNotFound(name: $0)
                }
                return type.id
            }
        }

        if let d = arguments[Keys.documentation] as? String {
            property.documentation = d
        }

        if let rename = arguments[Keys.rename] as? String {
            guard target.findProperty(name: rename) == nil else {
                throw PolymorphCLIError.propertyExists(name: rename)
            }
            property.name = rename
        }

        try ProjectStorage.save(project: project, at: file)
    }
}

