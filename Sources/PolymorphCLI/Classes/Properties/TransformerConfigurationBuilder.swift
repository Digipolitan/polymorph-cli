//
//  TransformerConfigurationBuilder.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 04/10/2017.
//

import Foundation
import PolymorphCore

public class TransformerConfigurationBuilder {

    public static func build(project: Project, name: String) throws -> Property.Mapping.TransformerConfiguration {
        guard let uuid = project.findTransformer(name: name),
            let transformer = project.transformers[uuid] else {
            throw PolymorphCLIError.transformerNotFound(name: name)
        }
        let options = transformer.options
        if options.count > 0 {
            print("Transformer '\(name)' options setup".green)
            let output: [Transformer.Option] = try options.map {
                var title = $0.name
                if let v = $0.value {
                    title += " (\(v))"
                }
                var value: String? = nil
                repeat {
                    print("\(title) : ".yellow, terminator: "")
                    guard let line = readLine() else {
                        throw PolymorphCLIError.standardInputError
                    }
                    value = line.count > 0 ? line : nil
                    if value == nil && $0.required && $0.value == nil {
                        print("[!] The option \($0.name) is required, please define a value".red)
                    } else {
                        break
                    }
                } while true
                return .init(name: $0.name, required: $0.required, value: value)
            }.filter { $0.value != nil }
            return .init(id: uuid, options: output)
        }
        return .init(id: uuid)
    }
}
