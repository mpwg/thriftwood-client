//
//  SystemIcons.swift
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

/// Standardized SF Symbol names for consistent icon usage across the app.
/// Using a centralized enum ensures visual consistency and makes icon changes easier to manage.
enum SystemIcon {
    // MARK: - Services
    static let dashboard = "house"
    static let movies = "play.circle"
    static let moviesAlt = "film"
    static let moviesFilled = "film.fill"
    static let music = "bolt.circle"
    static let tv = "sparkles"
    static let downloads = "tray.and.arrow.down"
    static let downloadsFilled = "tray.full"
    static let monitoring = "network"
    
    // MARK: - Actions
    static let search = "magnifyingglass"
    static let searchCircle = "magnifyingglass.circle"
    static let add = "plus"
    static let close = "xmark"
    static let closeCircle = "xmark.circle.fill"
    static let edit = "pencil"
    static let delete = "trash"
    static let refresh = "arrow.clockwise"
    static let more = "ellipsis"
    static let menu = "line.3.horizontal"
    
    // MARK: - Filters & Sorting
    static let filter = "line.3.horizontal.decrease"
    static let filterCircle = "line.3.horizontal.decrease.circle"
    static let sort = "arrow.up.arrow.down"
    
    // MARK: - Views & Layout
    static let grid = "square.grid.2x2"
    static let grid3x2 = "square.grid.3x2.fill"
    static let grid3x3 = "circle.grid.3x3.fill"
    static let list = "list.bullet"
    static let calendar = "calendar"
    
    // MARK: - Navigation & UI
    static let back = "chevron.left"
    static let forward = "chevron.right"
    static let disclosure = "chevron.right"
    static let checkmark = "checkmark"
    static let checkmarkCircle = "checkmark.circle"
    static let checkmarkCircleFill = "checkmark.circle.fill"
    static let magnifyingGlass = "magnifyingglass"
    static let plus = "plus"
    
    // MARK: - Media Info
    static let file = "doc.on.doc"
    static let files = "doc.on.doc"
    static let history = "clock.arrow.circlepath"
    static let people = "person.crop.circle"
    static let person = "person.fill"
    static let info = "info.circle"
    
    // MARK: - Settings
    static let settings = "gearshape"
    static let settingsFilled = "gearshape.fill"
    static let profile = "person.crop.square"
    static let notifications = "bell.fill"
    static let network = "network"
    
    // MARK: - Status Indicators
    static let video = "video.fill"
    static let record = "record.circle"
    static let checked = "checkmark.circle"
    
    // MARK: - External Links
    static let github = "logo.github"
    static let web = "house.fill"
    static let link = "link"
    
    // MARK: - Misc
    static let dollar = "dollarsign.circle"
    static let help = "questionmark.circle"
    static let paintbrush = "paintbrush"
    static let quickActions = "square.dashed"
    static let externalModules = "chevron.left.slash.chevron.right"
    static let printer = "printer.fill"
}
