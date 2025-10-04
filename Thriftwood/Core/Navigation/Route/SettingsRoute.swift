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
