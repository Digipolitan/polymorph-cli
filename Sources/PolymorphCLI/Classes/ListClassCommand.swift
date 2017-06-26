//
//  ListClassCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 26/06/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class ListClassCommand: Command {

    public enum Keys {
        public static let search: String = "search"
        public static let using: String = "using"
        public static let verbose: String = "verbose"
    }

    public enum Options {
        public static let search = OptionDefinition(name: Keys.search, type: .string, alias: "s", documentation: "Search classes matching this value")
        public static let using = OptionDefinition(name: Keys.using, type: .string, alias: "u", documentation: "Search classes using this value, such as extends or contains property of this type")
        public static let verbose = OptionDefinition(name: Keys.verbose, type: .boolean, alias: "v", defaultValue: false, documentation: "Display all information about classes")
    }

    public enum Consts {
        public static let name: String = "list"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.search,
            Options.using,
            Options.verbose,
            PolymorphCommand.Options.file,
            PolymorphCommand.Options.help
            ], documentation: "Search classes in the project")
    }()

    public func run(_ arguments: [String : Any]) throws {
        if let file = arguments[PolymorphCommand.Keys.file] as? String,
            let verbose = arguments[Keys.verbose] as? Bool {
            let project = try ProjectStorage.open(at: file)

            if let search = arguments[Keys.search] as? String {
                print(try project.models.searchClasses(matching: search).map { try help(of: $0, from: project, verbose: verbose) }.joined(separator: "\n\n"))
            } else if let using = arguments[Keys.using] as? String {
                if let type = project.models.findClass(name: using) {
                    print(try project.models.searchClasses(linkedTo: type.id).map { try help(of: $0, from: project, verbose: verbose) }.joined(separator: "\n\n"))
                } else {
                    throw PolymorphCLIError.classNotFound(name: using)
                }
            } else {
                print(try project.models.classes.map { try help(of: $0, from: project, verbose: verbose) }.joined(separator: "\n"))
            }
        }
    }

    public func help(of c: Class, from project: Project, verbose: Bool) throws -> String {
        var part: [String] = []

        var parents: [String] = []
        var str = try c.canonicalName(from: project)
        if let extends = c.extends {
            if let parent = project.models.findObject(uuid: extends) as? Class {
                parents.append(parent.name)
            } else {
                parents.append("#")
            }
        }
        if c.serializable {
            parents.append("Serializable")
        }

        if parents.count > 0 {
            str += ": " + parents.joined(separator: ", ")
        }

        part.append(str)

        if verbose {
            if let d = c.documentation {
                part.append(d)
            }
            if c.properties.count > 0 {
                part.append("PROPERTIES: ")
                part.append(contentsOf: c.properties.map { self.help(of: $0, from: project) })
            }
        }

        return part.joined(separator: "\n\n")
    }

    public func help(of property: Property, from project: Project) -> String {
        var str = property.name
        if let type = project.models.findObject(uuid: property.type) {
            str += " \(type.name)"
        } else {
            str += " #"
        }

        if let generics = property.genericTypes {
            str += "<\(generics.map { project.models.findObject(uuid: $0)?.name ?? "#" }.joined(separator: ", "))>"
        }

        if !property.isNonnul {
            str += "?"
        }

        if let d = property.documentation {
            str += "\n  \(d)"
        }

        return str
    }
}
