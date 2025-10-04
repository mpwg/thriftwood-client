//
//  SettingsRoute.swift
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
//  SettingsRoute.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 04.10.25.
//


import Foundation

/// Routes within the Settings feature
enum SettingsRoute: Hashable, Sendable {
    case main
    case profiles
    case addProfile
    case editProfile(profileId: String)
    case appearance
    case notifications
    case about
    case logs
}

extension SettingsRoute: DeepLinkable {
    static func parse(from url: URL) -> SettingsRoute? {
        // For URLs like "thriftwood://settings/profiles", the host is "settings"
        guard url.host == "settings" else { return nil }
        
        // Path components include the leading "/", so we filter it out
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        
        // If no path components, it's the main route
        guard !pathComponents.isEmpty else { return .main }
        
        switch pathComponents[0] {
        case "profiles":
            if pathComponents.count >= 2 {
                switch pathComponents[1] {
                case "add":
                    return .addProfile
                case "edit":
                    guard pathComponents.count >= 3 else { return nil }
                    return .editProfile(profileId: pathComponents[2])
                default:
                    return nil
                }
            }
            return .profiles
        case "appearance":
            return .appearance
        case "notifications":
            return .notifications
        case "about":
            return .about
        case "logs":
            return .logs
        default:
            return nil
        }
    }
    
    func toURL() -> URL? {
        let base = "thriftwood://settings"
        switch self {
        case .main:
            return URL(string: base)
        case .profiles:
            return URL(string: "\(base)/profiles")
        case .addProfile:
            return URL(string: "\(base)/profiles/add")
        case .editProfile(let profileId):
            return URL(string: "\(base)/profiles/edit/\(profileId)")
        case .appearance:
            return URL(string: "\(base)/appearance")
        case .notifications:
            return URL(string: "\(base)/notifications")
        case .about:
            return URL(string: "\(base)/about")
        case .logs:
            return URL(string: "\(base)/logs")
        }
    }
}
