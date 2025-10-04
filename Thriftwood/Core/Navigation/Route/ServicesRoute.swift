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
