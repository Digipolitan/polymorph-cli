//
//  RemoveProjectCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 19/06/2017.
//

import Foundation
import CommandLineArgs

public class RemoveProjectCommand: Command {

    public lazy var definition: CommandDefinition = {
        let mainOption = OptionDefinition(name: "file", type: .string, alias: "f", defaultValue: "polymorph.json", documentation: "The project file to remove")

        return CommandDefinition(name: "rm", main: mainOption, documentation: "Delete the polymorph project")
    }()

    public func run(_ arguments: [String : Any]) throws {
        print("RM \(arguments)")

    }
}

