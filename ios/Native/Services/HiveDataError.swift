//
//  HiveDataError.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import Foundation
import Flutter

enum HiveDataError: LocalizedError {
    case flutterError(String)
    case encodingError(String)
    case decodingError(String)
    case notFound
    case channelNotInitialized
    case unknownError(String)
    
    var errorDescription: String? {
        switch self {
        case .flutterError(let message):
            return "Flutter error: \(message)"
        case .encodingError(let message):
            return "Encoding error: \(message)"
        case .decodingError(let message):
            return "Decoding error: \(message)"
        case .notFound:
            return "Data not found"
        case .channelNotInitialized:
            return "Method channel not initialized"
        case .unknownError(let message):
            return "Unknown error: \(message)"
        }
    }
}