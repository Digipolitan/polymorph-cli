//
//  ServiceCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 25/10/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class ServiceCommand: Command {

    public enum Consts {
        public static let name: String = "service"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            PolymorphCommand.Options.help
            ], documentation: "Manage all services from the given project")
    }()

    public func run(_ arguments: [String : Any]) throws {
        throw CommandLineError.unimplementedCommand
    }
}

