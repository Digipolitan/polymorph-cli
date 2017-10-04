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
        var parts = ["- \(self.name)"]

        let options = self.options.map {
            var option = "  + \($0.name)"
            if !$0.required {
                option += "?"
            }
            if let v = $0.value {
                option += " = \(v)"
            }
            return option
            }.joined(separator: "\n")
        if options.count > 0 {
            parts.append(options)
        }

        return parts.joined(separator: "\n")
    }
}
