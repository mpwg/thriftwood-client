//
//  DownloadClientConfiguration.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import Foundation
import SwiftUI

@Observable
class DownloadClientConfiguration: Codable, Identifiable {
    let id = UUID()
    var name: String
    var enabled: Bool
    var host: String
    var username: String
    var password: String
    var apiKey: String
    var customHeaders: [String: String]
    var icon: String
    var strictTLS: Bool
    
    init(name: String) {
        self.name = name
        self.enabled = false
        self.host = ""
        self.username = ""
        self.password = ""
        self.apiKey = ""
        self.customHeaders = [:]
        self.strictTLS = true
        self.icon = "gearshape.fill"
    }
}
