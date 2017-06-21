//
//  UseProjectCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 21/06/2017.
//

import Foundation
import CommandLineArgs

public class UseProjectCommand: Command {

    public lazy var definition: CommandDefinition = {
        let mainOption = OptionDefinition(name: "file", type: .string, alias: "f", defaultValue: "polymorph.json", documentation: "The json file that will contains all project information")

        return CommandDefinition(name: "use", definitions: [OptionDefinition(name: "help", type: .boolean, documentation: "Display this help")], main: mainOption, documentation: "Select the project to edit")
    }()

    public func run(_ arguments: [String : Any]) throws {
        print("USE \(arguments)")
    }
}
