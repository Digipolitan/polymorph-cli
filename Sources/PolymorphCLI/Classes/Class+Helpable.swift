//
//  Class+Helpable.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 28/06/2017.
//

import Foundation
import CommandLineArgs
import PolymorphCore

extension Class: Helpable {

    public func help() -> String {
        return self.help(verbose: false)
    }

    public func help(verbose: Bool) -> String {
        var part: [String] = []

        var parents: [String] = []
        var str = (self.canonicalName ?? self.name).bold
        if let extends = self.extends {
            if let parent = self.project?.models.findObject(uuid: extends) as? Class {
                parents.append(parent.name.magenta)
            } else {
                parents.append("#".red)
            }
        }
        if self.serializable {
            parents.append("Serializable")
        }
        if self.injectable {
            parents.append("Injectable")
        }

        if parents.count > 0 {
            str += ": " + parents.joined(separator: ", ")
        }

        part.append(str)

        if verbose {
            if let d = self.documentation {
                part.append(d)
            }
            part.append("Properties:".underline)
            if self.properties.count > 0 {
                part.append(contentsOf: self.properties.map { $0.help() })
            } else {
                part.append("None")
            }
            part.append("") // new line between each enums on verbose
        }

        return part.joined(separator: "\n")
    }
}
