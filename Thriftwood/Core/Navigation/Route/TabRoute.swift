//
//  TabRoute.swift
//  Thriftwood
//
//  Thriftwood - Frontend for Media Management
//  Copyright (C) 2025 Matthias Wallner Géhri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
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