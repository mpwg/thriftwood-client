//
//  RadarrSystemStatusDisplayModel.swift
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

/// Display model for Radarr system status information
///
/// Provides a curated subset of system information for UI display,
/// decoupling the view from the RadarrAPI SystemResource domain model.
struct RadarrSystemStatusDisplayModel {
    let version: String?
    let osName: String?
    let osVersion: String?
    let runtimeName: String?
    let runtimeVersion: String?
    let startupPath: String?
    let appData: String?
    let branch: String?
    let databaseType: String?
    let authentication: String?
    
    /// Display items for presentation in a list or form
    var displayItems: [DisplayItem] {
        var items: [DisplayItem] = []
        
        if let version = version {
            items.append(DisplayItem(label: "Version", value: version, isCaption: false))
        }
        if let osName = osName {
            items.append(DisplayItem(label: "OS", value: osName, isCaption: false))
        }
        if let osVersion = osVersion {
            items.append(DisplayItem(label: "OS Version", value: osVersion, isCaption: false))
        }
        if let runtimeName = runtimeName {
            items.append(DisplayItem(label: "Runtime", value: runtimeName, isCaption: false))
        }
        if let runtimeVersion = runtimeVersion {
            items.append(DisplayItem(label: "Runtime Version", value: runtimeVersion, isCaption: false))
        }
        if let branch = branch {
            items.append(DisplayItem(label: "Branch", value: branch, isCaption: false))
        }
        if let databaseType = databaseType {
            items.append(DisplayItem(label: "Database", value: databaseType, isCaption: false))
        }
        if let authentication = authentication {
            items.append(DisplayItem(label: "Authentication", value: authentication, isCaption: false))
        }
        if let startupPath = startupPath {
            items.append(DisplayItem(label: "Startup Path", value: startupPath, isCaption: true))
        }
        if let appData = appData {
            items.append(DisplayItem(label: "App Data", value: appData, isCaption: true))
        }
        
        return items
    }
    
    /// Individual display item for system information
    struct DisplayItem: Identifiable {
        let id = UUID()
        let label: String
        let value: String
        let isCaption: Bool
    }
}
