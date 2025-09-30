//
//  ExternalModule.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import Foundation
import SwiftUI

@Observable
class ExternalModule: Codable, Identifiable {
    let id = UUID()
    var name: String
    var displayName: String
    var host: String
    var icon: String
    var isEnabled: Bool
    
    init(name: String, displayName: String, host: String, icon: String = "globe", isEnabled: Bool = true) {
        self.name = name
        self.displayName = displayName
        self.host = host
        self.icon = icon
        self.isEnabled = isEnabled
    }
}