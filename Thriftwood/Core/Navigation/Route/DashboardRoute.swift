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
