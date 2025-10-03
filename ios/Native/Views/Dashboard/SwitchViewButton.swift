//
//  SwitchViewButton.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 01.10.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI
import Flutter

/// Swift equivalent of Flutter's SwitchViewAction
struct SwitchViewButton: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        Button {
            withAnimation {
                selectedTab = selectedTab == 0 ? 1 : 0
            }
        } label: {
            Image(systemName: selectedTab == 0 ? "calendar" : "square.grid.2x2")
                .font(.title3)
        }
    }
}