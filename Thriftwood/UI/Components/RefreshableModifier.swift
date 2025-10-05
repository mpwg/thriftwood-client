//
//  RefreshableModifier.swift
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

import SwiftUI

/// ViewModifier for consistent pull-to-refresh behavior
///
/// Wraps SwiftUI's native refreshable modifier with consistent styling
/// and error handling.
///
/// Usage:
/// ```swift
/// List { }
///     .thriftwoodRefreshable {
///         await viewModel.reload()
///     }
/// ```
struct ThriftwoodRefreshableModifier: ViewModifier {
    let action: @Sendable () async -> Void
    
    func body(content: Content) -> some View {
        content
            .refreshable {
                await action()
            }
    }
}

extension View {
    /// Adds pull-to-refresh capability with consistent Thriftwood styling
    /// - Parameter action: Async action to perform on refresh
    /// - Returns: View with refreshable modifier
    func thriftwoodRefreshable(
        action: @escaping @Sendable () async -> Void
    ) -> some View {
        modifier(ThriftwoodRefreshableModifier(action: action))
    }
}

// MARK: - Previews

#Preview("Refreshable List") {
    @MainActor
    struct RefreshableListExample: View {
        @State private var items = ["Item 1", "Item 2", "Item 3"]
        @State private var isLoading = false
        
        var body: some View {
            NavigationStack {
                List(items, id: \.self) { item in
                    Text(item)
                }
                .navigationTitle("Refreshable List")
                .thriftwoodRefreshable {
                    await MainActor.run {
                        isLoading = true
                    }
                    try? await Task.sleep(for: .seconds(1))
                    await MainActor.run {
                        items.append("New Item")
                        isLoading = false
                    }
                }
            }
        }
    }
    
    return RefreshableListExample()
}

#Preview("Refreshable ScrollView") {
    @MainActor
    struct RefreshableScrollExample: View {
        @State private var lastRefreshed: Date?
        
        var body: some View {
            NavigationStack {
                ScrollView {
                    VStack(spacing: Spacing.md) {
                        ForEach(0..<20) { index in
                            CardView {
                                HStack {
                                    Image(systemName: "film")
                                    Text("Movie \(index + 1)")
                                    Spacer()
                                }
                            }
                        }
                    }
                    .padding()
                }
                .navigationTitle("Movies")
                .thriftwoodRefreshable {
                    try? await Task.sleep(for: .seconds(1))
                    await MainActor.run {
                        lastRefreshed = Date()
                    }
                }
                .toolbar {
                    if let date = lastRefreshed {
                        ToolbarItem(placement: .status) {
                            Text("Last refreshed: \(date, format: .dateTime.hour().minute())")
                                .font(.caption)
                                .foregroundStyle(Color.themeSecondaryText)
                        }
                    }
                }
            }
        }
    }
    
    return RefreshableScrollExample()
}
