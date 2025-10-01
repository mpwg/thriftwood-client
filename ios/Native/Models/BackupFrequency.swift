//
//  BackupFrequency.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import Foundation
import SwiftUI

enum BackupFrequency: String, CaseIterable, Codable {
    case daily = "daily"
    case weekly = "weekly"
    case monthly = "monthly"
    case manual = "manual"
    
    var displayName: String {
        switch self {
        case .daily: return "Daily"
        case .weekly: return "Weekly" 
        case .monthly: return "Monthly"
        case .manual: return "Manual Only"
        }
    }
}