//
//  Transformer+Helpable.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 04/10/2017.
//

import Foundation
import CommandLineArgs
import PolymorphCore

extension Transformer: Helpable {

    public func help() -> String {
        return self.help(verbose: false)
    }

    public func help(verbose: Bool) -> String {
        var part: [String] = [self.name.bold]

        if verbose {
            part.append("Options:".underline)
            if self.options.count > 0 {
                part.append(contentsOf: self.options.map {
                    var option = "\($0.name.green)"
                    if !$0.required {
                        option += "?".green
                    }
                    if let v = $0.value {
                        option += " = \(v.red)"
                    }
                    return option
                })
            } else {
                part.append("None")
            }
            part.append("") // new line between each transfomers on verbose
        }

        return part.joined(separator: "\n")
    }
}
