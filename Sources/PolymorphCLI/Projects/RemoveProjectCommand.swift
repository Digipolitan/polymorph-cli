//
//  RemoveProjectCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 19/06/2017.
//

import Foundation
import CommandLineArgs

public class RemoveProjectCommand: Command {

    public enum Consts {
        public static let name: String = "rm"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [PolymorphCommand.Options.help], main: PolymorphCommand.Options.file, documentation: "Delete the polymorph project")
    }()

    public func run(_ arguments: [String : Any]) throws {
        guard let file = arguments[PolymorphCommand.Keys.file] as? String else {
            return
        }
        _ = try ProjectStorage.open(at: file)
        try ProjectStorage.fileManager.removeItem(atPath: file)
    }
}

