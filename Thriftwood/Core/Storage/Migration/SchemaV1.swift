//
//  SchemaV1.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 04.10.25.
//


import Foundation
import SwiftData

/// Version 1 schema - Initial release
enum SchemaV1: VersionedSchema {
    static var versionIdentifier: Schema.Version {
        return Schema.Version(1, 0, 0)
    }
    
    static var models: [any PersistentModel.Type] {
        return [
            Profile.self,
            AppSettings.self,
            ServiceConfiguration.self,
            Indexer.self,
            ExternalModule.self
        ]
    }
}