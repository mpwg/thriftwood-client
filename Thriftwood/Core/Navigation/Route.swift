//
//  Route.swift
//  Thriftwood
//
//  Created on 2025-10-04.
//  Defines the app-wide navigation routes
//

import Foundation

/// Root-level routes for the entire application
enum AppRoute: Hashable, Sendable {
    case onboarding
    case main
}

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

/// Routes within the Dashboard feature
enum DashboardRoute: Hashable, Sendable {
    case home
    case serviceDetail(serviceId: String)
    case mediaDetail(mediaId: String, serviceType: String)
}

/// Routes within the Services feature
enum ServicesRoute: Hashable, Sendable {
    case list
    case addService
    case serviceConfiguration(serviceId: String)
    case testConnection(serviceId: String)
}

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

/// Protocol for types that can be converted to/from URLs for deep linking
protocol DeepLinkable {
    /// Attempt to parse a route from a URL
    /// - Parameter url: The URL to parse
    /// - Returns: A route if the URL can be parsed, nil otherwise
    static func parse(from url: URL) -> Self?
    
    /// Convert this route to a URL
    /// - Returns: A URL representing this route
    func toURL() -> URL?
}

// MARK: - Deep Link Support

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

extension ServicesRoute: DeepLinkable {
    static func parse(from url: URL) -> ServicesRoute? {
        // For URLs like "thriftwood://services/add", the host is "services"
        guard url.host == "services" else { return nil }
        
        // Path components include the leading "/", so we filter it out
        let pathComponents = url.pathComponents.filter { $0 != "/" }
        
        // If no path components, it's the list route
        guard !pathComponents.isEmpty else { return .list }
        
        switch pathComponents[0] {
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
        case .addService:
            return URL(string: "\(base)/add")
        case .serviceConfiguration(let serviceId):
            return URL(string: "\(base)/configure/\(serviceId)")
        case .testConnection(let serviceId):
            return URL(string: "\(base)/test/\(serviceId)")
        }
    }
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
