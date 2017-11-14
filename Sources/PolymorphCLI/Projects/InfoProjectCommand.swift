//
//  InfoProjectCommand.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 04/10/2017.
//

import Foundation
import CommandLineArgs

public class InfoProjectCommand: Command {

    public enum Consts {
        public static let name: String = "info"
    }

    public lazy var definition: CommandDefinition = {
        return CommandDefinition(name: Consts.name, options: [PolymorphCommand.Options.help], main: PolymorphCommand.Options.file, documentation: "Display the polymorph project")
    }()

    public func run(_ arguments: [String: Any]) throws {
        guard let file = arguments[PolymorphCommand.Keys.file] as? String else {
            return
        }
        let project = try ProjectStorage.open(at: file)

        print("Name: \(project.name)")
        print("Package: \(project.package.value)")
        print("Copyright: \(project.copyright ?? "")")
        print("Author: \(project.author ?? "")")
        print("Documentation: \(project.documentation ?? "")")
    }
}
