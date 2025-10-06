//
//  DeepLinkable.swift
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
