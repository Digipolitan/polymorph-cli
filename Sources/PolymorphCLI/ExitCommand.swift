//
//  PolymorphCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 23/06/2017.
//

import Foundation
import CommandLineArgs

public class ExitCommand: Command {

    public enum Consts {
        public static let name: String = "exit"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, documentation: "Exit polymorph command")
    }()

    public func run(_ arguments: [String : Any]) throws {
        exit(0)
    }
}

