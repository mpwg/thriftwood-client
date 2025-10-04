//
//  Route.swift
//  Thriftwood
//
//  Created on 2025-10-04.
//  Defines the app-wide navigation routes
//

import Foundation

/// Root-level routes for the entire application
enum AppRoute: Hashable {
    case onboarding
    case main
}

/// Routes for the main tab navigation
enum TabRoute: Hashable, CaseIterable {
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
enum DashboardRoute: Hashable {
    case home
    case serviceDetail(serviceId: String)
    case mediaDetail(mediaId: String, serviceType: String)
}

/// Routes within the Services feature
enum ServicesRoute: Hashable {
    case list
    case addService
    case serviceConfiguration(serviceId: String)
    case testConnection(serviceId: String)
}

/// Routes within the Settings feature
enum SettingsRoute: Hashable {
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
        let components = url.pathComponents.dropFirst() // Remove leading "/"
        
        guard components.first == "dashboard" else { return nil }
        
        switch components.dropFirst().first {
        case "service":
            guard let serviceId = components.dropFirst(2).first else { return nil }
            return .serviceDetail(serviceId: serviceId)
        case "media":
            guard let mediaId = components.dropFirst(2).first,
                  let serviceType = components.dropFirst(3).first else { return nil }
            return .mediaDetail(mediaId: mediaId, serviceType: serviceType)
        default:
            return .home
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
        let components = url.pathComponents.dropFirst()
        
        guard components.first == "services" else { return nil }
        
        switch components.dropFirst().first {
        case "add":
            return .addService
        case "configure":
            guard let serviceId = components.dropFirst(2).first else { return nil }
            return .serviceConfiguration(serviceId: serviceId)
        case "test":
            guard let serviceId = components.dropFirst(2).first else { return nil }
            return .testConnection(serviceId: serviceId)
        default:
            return .list
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
        let components = url.pathComponents.dropFirst()
        
        guard components.first == "settings" else { return nil }
        
        switch components.dropFirst().first {
        case "profiles":
            if let action = components.dropFirst(2).first {
                switch action {
                case "add":
                    return .addProfile
                case "edit":
                    guard let profileId = components.dropFirst(3).first else { return nil }
                    return .editProfile(profileId: profileId)
                default:
                    return .profiles
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
            return .main
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
