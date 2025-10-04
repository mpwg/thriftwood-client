//
//  LogCategory.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 04.10.25.
//


import Foundation
import OSLog

/// Logging categories for different subsystems
enum LogCategory: String {
    case networking = "Networking"
    case storage = "Storage"
    case authentication = "Authentication"
    case ui = "UI"
    case services = "Services"
    case navigation = "Navigation"
    case general = "General"
}