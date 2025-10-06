//
//  ServicesRoute.swift
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
//  ServicesRoute.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 04.10.25.
//

import Foundation

/// Routes within the Services feature
enum ServicesRoute: Hashable, Sendable {
    case list
    case radarr
    case sonarr
    case addService
    case serviceConfiguration(serviceId: String)
    case testConnection(serviceId: String)
}

extension ServicesRoute: DeepLinkable {
    static func parse(from url: URL) -> ServicesRoute? {
        // For URLs like "thriftwood://services/add", the host is "services"
        guard url.host == "services" else { return nil }
        
        // Path components include the leading "/", so we filter it out
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        
        // If no path components, it's the list route
        guard !pathComponents.isEmpty else { return .list }
        
        switch pathComponents[0] {
        case "radarr":
            return .radarr
        case "sonarr":
            return .sonarr
        case "add":
            return .addService
        case "configure":
            guard pathComponents.count >= 2 else { return nil }
            return .serviceConfiguration(serviceId: pathComponents[1])
        case "test":
            guard pathComponents.count >= 2 else { return nil }
            return .testConnection(serviceId: pathComponents[1])
        default:
            return nil
        }
    }
    
    func toURL() -> URL? {
        let base = "thriftwood://services"
        switch self {
        case .list:
            return URL(string: base)
        case .radarr:
            return URL(string: "\(base)/radarr")
        case .sonarr:
            return URL(string: "\(base)/sonarr")
        case .addService:
            return URL(string: "\(base)/add")
        case .serviceConfiguration(let serviceId):
            return URL(string: "\(base)/configure/\(serviceId)")
        case .testConnection(let serviceId):
            return URL(string: "\(base)/test/\(serviceId)")
        }
    }
}
