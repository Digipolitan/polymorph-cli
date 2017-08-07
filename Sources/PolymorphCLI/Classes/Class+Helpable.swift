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
        var str = self.canonicalName ?? self.name
        if let extends = self.extends {
            if let parent = self.project?.models.findObject(uuid: extends) as? Class {
                parents.append(parent.name)
            } else {
                parents.append("#")
            }
        }
        if self.serializable {
            parents.append("Serializable")
        }

        if parents.count > 0 {
            str += ": " + parents.joined(separator: ", ")
        }

        part.append(str)

        if verbose {
            if let d = self.documentation {
                part.append(d)
            }
            if self.properties.count > 0 {
                part.append("PROPERTIES: ")
                part.append(contentsOf: self.properties.map { $0.help() })
            }
        }

        return part.joined(separator: "\n\n")
    }
}
