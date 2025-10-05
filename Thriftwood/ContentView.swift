//
//  ContentView.swift
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
//  ContentView.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 03.10.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    /// App coordinator from DI container
    @State private var coordinator: AppCoordinator?
    
    var body: some View {
        Group {
            if let coordinator = coordinator {
                coordinatorView(coordinator)
            } else {
                ProgressView("Loading...")
            }
        }
        .task {
            // Initialize coordinator from DI container
            if coordinator == nil {
                coordinator = DIContainer.shared.resolve(AppCoordinator.self)
                coordinator?.start()
            }
        }
    }
    
    /// Returns the appropriate view based on coordinator state
    @ViewBuilder
    private func coordinatorView(_ coordinator: AppCoordinator) -> some View {
        if let tabCoordinator = coordinator.activeCoordinator as? TabCoordinator {
            MainTabView(coordinator: tabCoordinator)
        } else {
            // Onboarding or other states
            VStack {
                Image(systemName: "checkmark.circle")
                    .font(.system(size: 60))
                Text("Welcome to Thriftwood")
                    .font(.title)
                Button("Get Started") {
                    // Complete onboarding
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                    coordinator.start()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
