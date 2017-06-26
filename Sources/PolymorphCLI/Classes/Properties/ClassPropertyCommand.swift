//
//  ClassPropertyCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 26/06/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class ClassPropertyCommand: Command {

    public enum Consts {
        public static let name: String = "property"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            PolymorphCommand.Options.help
            ], documentation: "Manage all properties from the given class")
    }()

    public func run(_ arguments: [String : Any]) throws {
        throw CommandLineError.unimplementedCommand
    }
}


