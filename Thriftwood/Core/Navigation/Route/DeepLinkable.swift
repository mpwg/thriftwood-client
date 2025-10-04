//
//  DeepLinkable.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 04.10.25.
//


import Foundation

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