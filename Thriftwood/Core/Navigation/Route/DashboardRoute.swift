//
//  DashboardRoute.swift
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
//  DashboardRoute.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 04.10.25.
//

import Foundation

/// Routes within the Dashboard feature
enum DashboardRoute: Hashable, Sendable {
    case home
    case serviceDetail(serviceId: String)
    case mediaDetail(mediaId: String, serviceType: String)
}

extension DashboardRoute: DeepLinkable {
    static func parse(from url: URL) -> DashboardRoute? {
        // For URLs like "thriftwood://dashboard/service/id", the host is "dashboard"
        guard url.host == "dashboard" else { return nil }
        
        // Path components include the leading "/", so we filter it out
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        
        // If no path components, it's the home route
        guard !pathComponents.isEmpty else { return .home }
        
        switch pathComponents[0] {
        case "service":
            guard pathComponents.count >= 2 else { return nil }
            return .serviceDetail(serviceId: pathComponents[1])
        case "media":
            guard pathComponents.count >= 3 else { return nil }
            return .mediaDetail(mediaId: pathComponents[1], serviceType: pathComponents[2])
        default:
            return nil
        }
    }
    
    func toURL() -> URL? {
        let base = "thriftwood://dashboard"
        switch self {
        case .home:
            return URL(string: base)
        case .serviceDetail(let serviceId):
            return URL(string: "\(base)/service/\(serviceId)")
        case .mediaDetail(let mediaId, let serviceType):
            return URL(string: "\(base)/media/\(mediaId)/\(serviceType)")
        }
    }
}
