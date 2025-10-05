//
//  Dependency.swift
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

import Foundation

/// Model for open source dependencies
struct Dependency: Codable, Identifiable {
    let name: String
    let version: String
    let repository: String
    let licenseType: String
    let licenseText: String
    
    var id: String { name }
    
    var repositoryURL: URL? {
        URL(string: repository)
    }
}

/// Container for acknowledgements data
struct AcknowledgementsData: Codable {
    let generated: String
    let dependencies: [Dependency]
}
