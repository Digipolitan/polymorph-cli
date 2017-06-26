//
//  PolymorphCLIError.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 25/06/2017.
//

import Foundation

public enum PolymorphCLIError: Error {

    case fileExistsAt(path: String)
    case fileNotFound(path: String)

    case classExists(name: String)
    case classNotFound(name: String)

    case objectNotFound(name: String)

    case propertyExists(name: String)
}
