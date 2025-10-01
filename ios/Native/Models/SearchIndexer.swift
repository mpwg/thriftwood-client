//
//  SearchIndexer.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import Foundation
import SwiftUI

@Observable
class SearchIndexer: Codable, Identifiable {
    let id = UUID()
    var name: String
    var displayName: String
    var host: String
    var apiKey: String
    var isEnabled: Bool
    var supportsCategories: [SearchCategory]
    var priority: Int
    
    init(name: String, displayName: String, host: String = "", apiKey: String = "", isEnabled: Bool = true, supportsCategories: [SearchCategory] = [], priority: Int = 0) {
        self.name = name
        self.displayName = displayName
        self.host = host
        self.apiKey = apiKey
        self.isEnabled = isEnabled
        self.supportsCategories = supportsCategories
        self.priority = priority
    }
}