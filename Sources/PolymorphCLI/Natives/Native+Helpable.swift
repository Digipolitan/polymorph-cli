//
//  Native+Helpable.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 04/10/2017.
//

import Foundation
import CommandLineArgs
import PolymorphCore

extension Native: Helpable {

    public func help() -> String {
        return self.help(verbose: false)
    }

    public func help(verbose: Bool) -> String {
        return self.name
    }
}

