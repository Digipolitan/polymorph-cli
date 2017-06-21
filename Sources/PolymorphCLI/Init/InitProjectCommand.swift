//
//  InitProjectCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 19/06/2017.
//

import Foundation
import CommandLineArgs

public class InitProjectCommand: Command {

    public lazy var definition: CommandDefinition = {
        var options: [OptionDefinition] = []
        options.append(OptionDefinition(name: "package", type: .string, alias: "p", isRequired: true, documentation: "The project main package"))
        options.append(OptionDefinition(name: "copyright", type: .string, alias: "c", documentation: "Your company copyright"))
        options.append(OptionDefinition(name: "author", type: .string, alias: "a", documentation: "The author of all generated files"))
        options.append(OptionDefinition(name: "documentation", type: .string, alias: "d", documentation: "Project information"))
        options.append(OptionDefinition(name: "file", type: .string, alias: "f", defaultValue: "polymorph.json", documentation: "The json file that will contains all project information"))

        let mainOption = OptionDefinition(name: "name", type: .string, documentation: "The project name")

        return CommandDefinition(name: "init", definitions: options, main: mainOption, documentation: "The project started")
    }()

    public func run(_ arguments: [String : Any]) throws {
        print("INIT \(arguments)")

    }
}
