//
//  Enum+Helpable.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 07/08/2017.
//

import Foundation
import CommandLineArgs
import PolymorphCore

extension Enum: Helpable {

    public func help() -> String {
        return self.help(verbose: false)
    }

    public func help(verbose: Bool) -> String {
        var part: [String] = []

        part.append((self.canonicalName ?? self.name).bold)

        if verbose {
            if let d = self.documentation {
                part.append(d)
            }
            part.append("Values:".underline)
            if self.values.count > 0 {
                part.append(contentsOf: self.values.map { $0.help() })
            } else {
                part.append("None")
            }
            part.append("") // new line between each enums on verbose
        }

        return part.joined(separator: "\n")
    }
}
