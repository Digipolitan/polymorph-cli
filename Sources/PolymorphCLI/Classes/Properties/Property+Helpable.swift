//
//  Property+Helpable.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 28/06/2017.
//

import Foundation
import CommandLineArgs
import PolymorphCore

extension Property: Helpable {

    public func help() -> String {
        var str = self.isTransient ? "transient " : ""
        str += self.name
        
        if let type = self.project?.natives[self.type] as? Object ?? self.project?.models.findObject(uuid: self.type) {
            str += " \(type.name)"
        } else {
            str += " #"
        }

        if let generics = self.genericTypes {
            str += "<\(generics.map { self.project?.natives[$0]?.name ?? self.project?.models.findObject(uuid: $0)?.name ?? "#" }.joined(separator: ", "))>"
        }

        if !self.isNonnull {
            str += "?"
        }

        if let d = self.documentation {
            str += "\n  \(d)"
        }

        return str
    }
}
