//
//  UserDefaultsStorageService.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import Foundation
import Flutter

class UserDefaultsStorageService: StorageService {
    private let userDefaults = UserDefaults.standard
    
    func save<T: Codable>(_ object: T, forKey key: String) async throws {
        let encoder = JSONEncoder()
        let data = try encoder.encode(object)
        userDefaults.set(data, forKey: key)
    }
    
    func load<T: Codable>(_ type: T.Type, forKey key: String) async throws -> T? {
        guard let data = userDefaults.data(forKey: key) else { return nil }
        
        let decoder = JSONDecoder()
        return try decoder.decode(type, from: data)
    }
    
    func delete(forKey key: String) async throws {
        userDefaults.removeObject(forKey: key)
    }
}