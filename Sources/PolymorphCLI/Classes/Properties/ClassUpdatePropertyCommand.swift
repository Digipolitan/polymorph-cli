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
        public static let const: String = "const"
        public static let ignored: String = "ignored"
        public static let transformer: String = "transformer"
        public static let defaultValue: String = "defaultValue"
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
        public static let const = OptionDefinition(name: Keys.const, type: .boolean, documentation: "Mark the property constant")
        public static let ignored = OptionDefinition(name: Keys.ignored, type: .boolean, documentation: "Ignore the property during the mapping")
        public static let transformer = OptionDefinition(name: Keys.transformer, type: .string, documentation: "Register a transformer for the given property ($ polymorph transformer list)")
        public static let defaultValue = OptionDefinition(name: Keys.defaultValue, type: .string, alias: "dv", documentation: "Set the defaultValue for the property")
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
            Options.const,
            Options.ignored,
            Options.transformer,
            Options.defaultValue,
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
            guard let typeId = project.findNative(name: type) ?? project.models.findObject(name: type)?.id else {
                throw PolymorphCLIError.objectNotFound(name: type)
            }
            if property.type != typeId {
                if property.mapping?.transformer != nil { // if the property type change, remove the associated transformer
                    property.mapping = Property.Mapping(key: property.mapping?.key)
                }
            }
            property.type = typeId
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
        if let const = arguments[Keys.const] as? Bool {
            property.isConst = const
        }
        if let defaultValue = arguments[Keys.defaultValue] as? String {
            property.defaultValue = PolymorphCommand.transformNil(string: defaultValue)
        }

        var isIgnored = false
        if let ignored = arguments[Keys.primary] as? Bool {
            if ignored {
                property.mapping = Property.Mapping.ignored()
                isIgnored = true
            } else if property.mapping?.isIgnored == true {
                property.mapping = nil
            }
        }
        if !isIgnored {
            var mappingKey: String? = nil
            var updateKey: Bool = false
            var updateTransformer: Bool = false
            if let key = arguments[Keys.key] as? String {
                updateKey = true
                mappingKey = PolymorphCommand.transformNil(string: key)
            }
            var transformerConfiguration: Property.Mapping.TransformerConfiguration? = nil
            if let transformer = arguments[Keys.transformer] as? String {
                updateTransformer = true
                if let newTransformer = PolymorphCommand.transformNil(string: transformer) {
                    transformerConfiguration = try TransformerConfigurationBuilder.build(project: project, name: newTransformer)
                }
            }
            if updateKey || updateTransformer {
                if !updateKey {
                    mappingKey = property.mapping?.key
                }
                if !updateTransformer {
                    transformerConfiguration = property.mapping?.transformer
                }
                if mappingKey != nil || transformerConfiguration != nil {
                    property.mapping = Property.Mapping(key: mappingKey, transformer: transformerConfiguration)
                } else {
                    property.mapping = nil
                }
            }
        }

        if let generics = arguments[Keys.genericTypes] as? [String] {
            property.genericTypes = try generics.map {
                guard let typeId = project.findNative(name: $0) ?? project.models.findObject(name: $0)?.id else {
                    throw PolymorphCLIError.objectNotFound(name: $0)
                }
                return typeId
            }
        }

        if let d = arguments[Keys.documentation] as? String {
            property.documentation = PolymorphCommand.transformNil(string: d)
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

