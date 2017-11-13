//
//  ExternalCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 13/11/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class ExternalCommand: Command {

    public enum Consts {
        public static let name: String = "external"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            PolymorphCommand.Options.help
            ], documentation: "Manage all polymorph external type")
    }()

    public func run(_ arguments: [String: Any]) throws {
        throw CommandLineError.unimplementedCommand
    }
}
