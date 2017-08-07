//
//  EnumValueCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 07/08/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class EnumValueCommand: Command {

    public enum Consts {
        public static let name: String = "value"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            PolymorphCommand.Options.help
            ], documentation: "Manage all values from the given enum")
    }()

    public func run(_ arguments: [String : Any]) throws {
        throw CommandLineError.unimplementedCommand
    }
}
