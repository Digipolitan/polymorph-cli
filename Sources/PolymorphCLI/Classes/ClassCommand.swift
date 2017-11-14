//
//  ClassCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 23/06/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class ClassCommand: Command {

    public enum Consts {
        public static let name: String = "class"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            PolymorphCommand.Options.help
            ], documentation: "Manage all classes from the given project")
    }()

    public func run(_ arguments: [String: Any]) throws {
        throw CommandLineError.unimplementedCommand
    }
}
