//
//  AddMovieView.swift
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

struct AddMovieView: View {
    @State private var selection: Tab = .search

    enum Tab {
        case search
        case discover
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Search field header (matches the screenshot layout)
                HStack {
                    Image(systemName: SystemIcon.search)
                        .foregroundColor(.mint)
                    Text("Search...")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    Spacer()
                }
                .padding(UIConstants.Padding.card)
                .background(
                    RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
                        .fill(Color.platformSecondaryGroupedBackground)
                )
                .padding(UIConstants.Padding.screen)

                // Tabs
                Picker("Tab", selection: Binding(get: { selection }, set: { selection = $0 })) {
                    Text("Search").tag(Tab.search)
                    Text("Discover").tag(Tab.discover)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.bottom, 8)

                // Content
                Group {
                    switch selection {
                    case .search:
                        SearchTabView()
                    case .discover:
                        DiscoverTabView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.platformGroupedBackground.ignoresSafeArea())
            }
            .navigationTitle("Add Movie")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
#endif
        }
    }
}

// Simple placeholder views for each tab — keep minimal so they compile and match prototype style.
private struct SearchTabView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: UIConstants.Spacing.medium) {
                ForEach(Movie.sample) { movie in
                    NavigationLink(destination: AddSingleMovieView(movie: movie)) {
                        MovieRow(movie: movie)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.top)
            .padding(.bottom, UIConstants.Padding.bottomToolbarSpacerCompact)
        }
    }
}

private struct DiscoverTabView: View {
    var body: some View {
        VStack {
            Text("Discover content goes here")
                .font(.body)
                .foregroundColor(.secondary)
                .padding()
            Spacer()
        }
    }
}

// MARK: - Preview

#Preview {
    AddMovieView()
}
