//
//  NativeCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 04/10/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

import Foundation
import PolymorphCore
import CommandLineArgs

public class NativeCommand: Command {

    public enum Consts {
        public static let name: String = "native"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            PolymorphCommand.Options.help
            ], documentation: "Manage all polymorph native type")
    }()

    public func run(_ arguments: [String : Any]) throws {
        throw CommandLineError.unimplementedCommand
    }
}




