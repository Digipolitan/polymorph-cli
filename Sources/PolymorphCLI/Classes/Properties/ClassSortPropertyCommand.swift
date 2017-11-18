//
//  ClassSortPropertyCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 18/11/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class ClassSortPropertyCommand: Command {

    public enum Keys {
        public static let name: String = "name"
        public static let index: String = "index"
        public static let targetClass: String = "class"
    }

    public enum Options {
        public static let name = OptionDefinition(name: Keys.name, type: .string, documentation: "The property name to reorganized, must be unique by class")
        public static let index = OptionDefinition(name: Keys.index, type: .int, alias: "i", documentation: "The property index in the given class")
        public static let targetClass = OptionDefinition(name: Keys.targetClass, type: .string, alias: "c", documentation: "The targeted class")
    }

    public enum Consts {
        public static let name: String = "sort"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.targetClass,
            Options.index,
            PolymorphCommand.Options.file,
            PolymorphCommand.Options.help
            ], main: Options.name, documentation: "Sort properties of the givent class")
    }()

    public func run(_ arguments: [String: Any]) throws {
        guard let file = arguments[PolymorphCommand.Keys.file] as? String else {
            return
        }

        let project = try ProjectStorage.open(at: file)

        if let name = arguments[Keys.name] as? String {
            guard let targetClass = arguments[Keys.targetClass] as? String else {
                throw PolymorphCLIError.missingConditionalParameter(name: Keys.targetClass)
            }
            guard let target = project.models.findClass(name: targetClass) else {
                throw PolymorphCLIError.classNotFound(name: targetClass)
            }
            guard let property = target.findProperty(name: name) else {
                throw PolymorphCLIError.propertyNotFound(name: name)
            }
            guard let index = arguments[Keys.index] as? Int else {
                throw PolymorphCLIError.missingConditionalParameter(name: Keys.index)
            }
            guard index >= 0 && index < target.properties.count else {
                throw PolymorphCLIError.propertySortInvalidIndex(value: index, info: "Invalid property index in \(target.name), available range [0 ..< \(target.properties.count)]")
            }
            target.arrangeProperty(property, at: index)
        } else {
            if let targetClass = arguments[Keys.targetClass] as? String {
                guard let target = project.models.findClass(name: targetClass) else {
                    throw PolymorphCLIError.classNotFound(name: targetClass)
                }
                print("\(PolymorphCommand.Consts.name) will reorganise all properties in the \(target.name) class, are you sure ? (y/n) : ".yellow, terminator: "")
                guard let line = readLine() else {
                    throw PolymorphCLIError.standardInputError
                }
                let value = line.count > 0 ? line : nil
                guard value == "y" || value == "yes" else {
                    return
                }
                self.sortProperties(in: target, using: self.buildPropertyComparisons())
            } else {
                print("\(PolymorphCommand.Consts.name) will reorganise all properties in all your classes, are you sure ? (y/n) : ".yellow, terminator: "")
                guard let line = readLine() else {
                    throw PolymorphCLIError.standardInputError
                }
                let value = line.count > 0 ? line : nil
                guard value == "y" || value == "yes" else {
                    return
                }
                let propertyComparisons = self.buildPropertyComparisons()
                project.models.classes.values.forEach({ (target) in
                    self.sortProperties(in: target, using: propertyComparisons)
                })
            }
        }
        try ProjectStorage.save(project: project, at: file)
    }

    private func sortProperties(`in` `class`: Class, using comparisons: [(Property, Property) -> ComparisonResult]) {
        try? `class`.sortProperties { (p1, p2) -> Bool in
            for comparison in comparisons {
                let res = comparison(p1, p2)
                if res != .orderedSame {
                    return res == .orderedAscending ? true : false
                }
            }
            return p1.name < p2.name
        }
    }

    private func buildPropertyComparisons() -> [(Property, Property) -> ComparisonResult] {
        var comparisons: [(Property, Property) -> ComparisonResult] = []
        comparisons.append { (p1: Property, p2: Property) -> ComparisonResult in
            if p1.isPrimary == p2.isPrimary {
                return .orderedSame
            }
            return p1.isPrimary ? .orderedAscending : .orderedDescending
        }
        comparisons.append { (p1: Property, p2: Property) -> ComparisonResult in
            if p1.isConst == p2.isConst {
                return .orderedSame
            }
            return p1.isConst ? .orderedAscending : .orderedDescending
        }
        comparisons.append { (p1: Property, p2: Property) -> ComparisonResult in
            if p1.isNonnull == p2.isNonnull {
                return .orderedSame
            }
            return p1.isNonnull ? .orderedAscending : .orderedDescending
        }
        return comparisons
    }
}
