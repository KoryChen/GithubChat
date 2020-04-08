//
//  DateCenter.swift
//  GitHubDM
//
//  Created by Kory on 2020/3/9.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import Foundation

protocol DataCenter {
    associatedtype DataType: Codable
    var fileKey: String { get }
}

extension DataCenter {
    
    func save(data: DataType) {
        let filename = getDocumentsDirectory().appendingPathComponent(fileKey)
        do {
            let data = try JSONEncoder().encode(data)
            try data.write(to: filename, options: .atomic)
        } catch {
            //TODO : handle error
        }
    }
    
    func load() throws -> DataType? {
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileKey)
        guard FileManager.default.fileExists(atPath: fileURL.path),
            let data = FileManager.default.contents(atPath: fileURL.path) else {
                throw GeneralError.notFound
        }
        
        return try JSONDecoder().decode(DataType.self, from: data)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
