//
//  Color.swift
//  PrototypeGUI
//
//  Created by Matthias Wallner-Géhri on 07.10.25.
//


import SwiftUI

extension Color {
    static var platformGroupedBackground: Color {
        #if os(iOS)
        return Color(.systemGroupedBackground)
        #else
        return Color(NSColor.windowBackgroundColor)
        #endif
    }

    static var platformSecondaryGroupedBackground: Color {
        #if os(iOS)
        return Color(.secondarySystemGroupedBackground)
        #else
        return Color(NSColor.controlBackgroundColor)
        #endif
    }
}