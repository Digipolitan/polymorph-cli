//
//  External+Helpable.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 13/11/2017.
//

import Foundation
import CommandLineArgs
import PolymorphCore

extension External: Helpable {

    public func help() -> String {
        return self.help(verbose: false)
    }

    public func help(verbose: Bool) -> String {
        return "\(self.name): \(self.type.rawValue)"
    }
}
