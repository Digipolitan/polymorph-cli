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
        var str = (self.isTransient ? "transient " : "").magenta

        if self.isConst {
            str += "const "
        } else {
            str += "var "
        }
        
        str += self.name.green

        if let typeName = self.project?.natives[self.type]?.name ?? self.project?.models.findObject(uuid: self.type)?.name {
            str += " \(typeName)".magenta
        } else {
            str += " #".red
        }

        if let generics = self.genericTypes {
            str += "<\(generics.map { (self.project?.natives[$0]?.name ?? self.project?.models.findObject(uuid: $0)?.name ?? "#").magenta }.joined(separator: ", "))>"
        }

        if !self.isNonnull {
            str += "?".magenta
        }

        if let defaultValue = self.defaultValue {
            str += " = \(defaultValue.red)"
        }

        if self.isPrimary {
            str += " [PK]".bold
        }

        if let mapping = self.mapping {
            var part: [String] = []
            if mapping.isIgnored {
                part.append("ignored: \("true".magenta)")
            } else {
                if let key = mapping.key {
                    part.append("key: " + "\"\(key)\"".red)
                }
                if let configuration = mapping.transformer,
                    let transformer = self.project?.transformers[configuration.id] {
                    part.append("transformer: \(transformer.name.magenta)")
                }
            }
            str += " {\(part.joined(separator: ", "))}"
        }

        if let d = self.documentation {
            str += "\n  \(d)"
        }

        return str
    }
}
