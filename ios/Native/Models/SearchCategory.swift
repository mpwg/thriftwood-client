//
//  SearchCategory.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import Foundation
import SwiftUI

enum SearchCategory: String, CaseIterable, Codable {
    case all = "all"
    case movies = "movies"
    case tv = "tv"
    case music = "music"
    case books = "books"
    case games = "games"
    case software = "software"
    case other = "other"
    
    var displayName: String {
        switch self {
        case .all: return "All"
        case .movies: return "Movies"
        case .tv: return "TV Shows"
        case .music: return "Music"
        case .books: return "Books"
        case .games: return "Games"
        case .software: return "Software"
        case .other: return "Other"
        }
    }
}