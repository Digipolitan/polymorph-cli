//
//  UpdateProjectCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 23/06/2017.
//

import Foundation
import CommandLineArgs

public class UpdateProjectCommand: Command {

    public enum Consts {
        public static let name: String = "update"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            InitProjectCommand.Options.package,
            InitProjectCommand.Options.author,
            InitProjectCommand.Options.copyright,
            InitProjectCommand.Options.documentation,
            InitProjectCommand.Options.name,
            PolymorphCommand.Options.help
            ], documentation: "Update project informations")
    }()

    public func run(_ arguments: [String : Any]) throws {
        print("UPDATE \(arguments)")
    }
}

