//
//  CalendarStartType.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import Foundation
import SwiftUI

enum CalendarStartType: String, CaseIterable, Codable {
    case today = "today"
    case thisWeek = "thisWeek"
    case thisMonth = "thisMonth"
    
    var displayName: String {
        switch self {
        case .today: return "Today"
        case .thisWeek: return "This Week"
        case .thisMonth: return "This Month"
        }
    }
}