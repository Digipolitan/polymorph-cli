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
        guard
        let file = arguments[PolymorphCommand.Keys.file] as? String,
        let verbose = arguments[Keys.verbose] as? Bool else {
            return
        }
        let project = try ProjectStorage.open(at: file)

        if let search = arguments[Keys.search] as? String {
            print(project.models.searchClasses(matching: search).map { $0.help(verbose: verbose) }.joined(separator: "\n\n"))
        } else if let using = arguments[Keys.using] as? String {
            if let type = project.models.findClass(name: using) {
                print(project.models.searchClasses(linkedTo: type.id).map { $0.help(verbose: verbose) }.joined(separator: "\n\n"))
            } else {
                throw PolymorphCLIError.classNotFound(name: using)
            }
        } else {
            print(project.models.classes.map { $0.help(verbose: verbose) }.joined(separator: "\n"))
        }
    }
}
