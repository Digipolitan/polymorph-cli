//
//  ClassNewPropertyCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 26/06/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class ClassNewPropertyCommand: Command {

    public enum Keys {
        public static let name: String = "name"
        public static let type: String = "type"
        public static let genericTypes: String = "genericTypes"
        public static let nonnull: String = "nonnull"
        public static let primary: String = "primary"
        public static let transient: String = "transient"
        public static let targetClass: String = "class"
        public static let documentation: String = "documentation"
    }

    public enum Options {
        public static let name = OptionDefinition(name: Keys.name, type: .string, isRequired: true, documentation: "The property name, must be unique by class")
        public static let type = OptionDefinition(name: Keys.type, type: .string, alias: "t", isRequired: true, documentation: "The property type")
        public static let targetClass = OptionDefinition(name: Keys.targetClass, type: .string, alias: "c", isRequired: true, documentation: "The property will be added to the given class")
        public static let genericTypes = OptionDefinition(name: Keys.genericTypes, type: .string, alias: "gts",  isMultiple: true, documentation: "List of generic types")
        public static let nonnull = OptionDefinition(name: Keys.nonnull, type: .boolean, alias: "nn", defaultValue: false, documentation: "Mark the property nonnull")
        public static let primary = OptionDefinition(name: Keys.primary, type: .boolean, alias: "p", defaultValue: false, documentation: "Mark the property primary")
        public static let transient = OptionDefinition(name: Keys.transient, type: .boolean, defaultValue: false, documentation: "Mark the property transient")
        public static let documentation = OptionDefinition(name: Keys.documentation, type: .string, alias: "d", documentation: "Description of the given property")
    }

    public enum Consts {
        public static let name: String = "new"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.type,
            Options.targetClass,
            PolymorphCommand.Options.file,
            Options.genericTypes,
            Options.nonnull,
            Options.primary,
            Options.transient,
            Options.documentation,
            PolymorphCommand.Options.help
            ], main: Options.name, documentation: "Create a new property")
    }()

    public func run(_ arguments: [String : Any]) throws {
        guard
        let file = arguments[PolymorphCommand.Keys.file] as? String,
        let name = arguments[Keys.name] as? String,
        let type = arguments[Keys.type] as? String,
        let targetClass = arguments[Keys.targetClass] as? String,
        let nonnull = arguments[Keys.nonnull] as? Bool,
        let primary = arguments[Keys.primary] as? Bool,
        let transient = arguments[Keys.transient] as? Bool else {
            return
        }

        let project = try ProjectStorage.open(at: file)

        guard let typeObject = project.models.findObject(name: type) else {
            throw PolymorphCLIError.objectNotFound(name: type)
        }
        guard var target = project.models.findClass(name: targetClass) else {
            throw PolymorphCLIError.classNotFound(name: targetClass)
        }

        var property = Property(name: name, type: typeObject.id)
        property.isNonnull = nonnull
        property.isTransient = transient
        property.isPrimary = primary

        if let generics = arguments[Keys.genericTypes] as? [String] {
            property.genericTypes = try generics.map {
                if let type = project.models.findObject(name: $0) {
                    return type.id
                }
                throw PolymorphCLIError.objectNotFound(name: type)
            }
        }

        if let d = arguments[Keys.documentation] as? String {
            property.documentation = d
        }

        guard target.addProperty(property) else {
            throw PolymorphCLIError.propertyExists(name: name)
        }

        project.models.updateObject(target)

        try ProjectStorage.save(project: project, at: file)
    }
}
