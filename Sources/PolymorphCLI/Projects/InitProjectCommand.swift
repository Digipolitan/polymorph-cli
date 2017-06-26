//
//  InitProjectCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 19/06/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class InitProjectCommand: Command {

    public enum Keys {
        public static let package: String = "package"
        public static let copyright: String = "copyright"
        public static let author: String = "author"
        public static let documentation: String = "documentation"
        public static let version: String = "version"
        public static let name: String = "name"
    }

    public enum Options {
        public static let package = OptionDefinition(name: Keys.package, type: .string, alias: "p", isRequired: true, documentation: "The project main package")
        public static let copyright = OptionDefinition(name: Keys.copyright, type: .string, alias: "c", documentation: "Your company copyright")
        public static let version = OptionDefinition(name: Keys.version, type: .string, alias: "v", documentation: "The project version")
        public static let author = OptionDefinition(name: Keys.author, type: .string, alias: "a", documentation: "The author of all generated files")
        public static let documentation = OptionDefinition(name: Keys.documentation, type: .string, alias: "d", documentation: "Project information")
        public static let name = OptionDefinition(name: Keys.name, type: .string, isRequired: true, documentation: "The project name")
    }

    public enum Consts {
        public static let name: String = "init"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            Options.package,
            PolymorphCommand.Options.file,
            Options.author,
            Options.copyright,
            Options.version,
            Options.documentation,
            PolymorphCommand.Options.help
            ], main: Options.name, documentation: "The project starter")
    }()

    public func run(_ arguments: [String : Any]) throws {
        if let file = arguments[PolymorphCommand.Keys.file] as? String {
            if ProjectStorage.fileManager.fileExists(atPath: file) {
                throw PolymorphCLIError.fileExistsAt(path: file)
            }
            if let name = arguments[Keys.name] as? String,
                let package = arguments[Keys.package] as? String {

                let project = Project(name: name, package: try Package(string: package))

                if let author = arguments[Keys.author] as? String {
                    project.author = author
                }
                if let copyright = arguments[Keys.copyright] as? String {
                    project.copyright = copyright
                }
                if let version = arguments[Keys.version] as? String {
                    project.version = version
                }
                if let documentation = arguments[Keys.documentation] as? String {
                    project.documentation = documentation
                }

                try ProjectStorage.save(project: project, at: file)
            }
        }
    }
}
