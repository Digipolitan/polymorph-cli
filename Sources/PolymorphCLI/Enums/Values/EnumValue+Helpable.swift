//
//  EnumValue+Helpable.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 07/08/2017.
//

import Foundation
import CommandLineArgs
import PolymorphCore

extension Enum.Value: Helpable {

    public func help() -> String {
        var str = "\(self.name.green) = \(self.raw.red)"
        if let d = self.documentation {
            str += "\n  \(d)"
        }
        return str
    }
}
