//
//  TransformerListCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 04/10/2017.
//

import Foundation
import PolymorphCore
import CommandLineArgs

public class ListTransformerCommand: Command {

    public enum Consts {
        public static let name: String = "list"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [
            PolymorphCommand.Options.file,
            PolymorphCommand.Options.help
            ], documentation: "Search all transformers in the project")
    }()

    public func run(_ arguments: [String : Any]) throws {
        guard
            let file = arguments[PolymorphCommand.Keys.file] as? String else {
                return
        }
        let project = try ProjectStorage.open(at: file)

        print(project.transformers.values.map { $0.help() }.joined(separator: "\n"))
    }
}

