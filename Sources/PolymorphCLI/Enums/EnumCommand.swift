//
//  EnumCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 07/08/2017.
//

import Foundation

import Foundation
import PolymorphCore
import CommandLineArgs

public class EnumCommand: Command {

    public enum Consts {
        public static let name: String = "enum"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            PolymorphCommand.Options.help
            ], documentation: "Manage all enums from the given project")
    }()

    public func run(_ arguments: [String: Any]) throws {
        throw CommandLineError.unimplementedCommand
    }
}
