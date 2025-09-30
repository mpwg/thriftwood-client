//
//  CalendarStartDay.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import Foundation
import SwiftUI

enum CalendarStartDay: String, CaseIterable, Codable {
    case sunday = "sunday"
    case monday = "monday"
    
    var displayName: String {
        switch self {
        case .sunday: return "Sunday"
        case .monday: return "Monday"
        }
    }
}