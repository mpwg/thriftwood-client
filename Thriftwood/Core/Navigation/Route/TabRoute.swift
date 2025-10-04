//
//  TabRoute.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 04.10.25.
//


import Foundation

/// Routes for the main tab navigation
enum TabRoute: Hashable, CaseIterable, Sendable {
    case dashboard
    case services
    case settings
    
    var title: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .services: return "Services"
        case .settings: return "Settings"
        }
    }
    
    var iconName: String {
        switch self {
        case .dashboard: return "square.grid.2x2"
        case .services: return "server.rack"
        case .settings: return "gearshape"
        }
    }
}