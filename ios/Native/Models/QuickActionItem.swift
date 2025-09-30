//
//  QuickActionItem.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import Foundation
import SwiftUI

@Observable
class QuickActionItem: Codable, Identifiable {
    let id = UUID()
    var title: String
    var icon: String
    var route: String
    var isEnabled: Bool
    
    init(title: String, icon: String, route: String, isEnabled: Bool = true) {
        self.title = title
        self.icon = icon
        self.route = route
        self.isEnabled = isEnabled
    }
}