//
//  ProjectStorage.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 26/06/2017.
//

import Foundation
import PolymorphCore

public class ProjectStorage {

    public static let fileManager = FileManager()

    private static let decoder: JSONDecoder = JSONDecoder()
    private static let encoder: JSONEncoder = JSONEncoder()

    public static func open(at path: String) throws -> Project {
        if self.fileManager.fileExists(atPath: path),
            let data = self.fileManager.contents(atPath: path) {
            return try self.decoder.decode(Project.self, from: data)
        }
        throw PolymorphCLIError.fileNotFound(path: path)
    }

    public static func save(project: Project, at path: String) throws {
        self.fileManager.createFile(atPath: path, contents: try self.encoder.encode(project))
    }
}
