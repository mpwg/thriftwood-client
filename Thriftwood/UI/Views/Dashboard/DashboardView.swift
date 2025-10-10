//
//  DashboardView.swift
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

struct DashboardView: View {
    @State private var viewModel = DashboardViewModel()

    var body: some View {
        NavigationStack {
            ZStack {
                // Background (uses system semantic color so previews follow light/dark)
                Color.platformGroupedBackground
                    .ignoresSafeArea()

                if viewModel.isLoading {
                    LoadingView(message: "Loading modules...")
                } else if let error = viewModel.error {
                    ErrorView(
                        error: error,
                        onRetry: {
                            Task {
                                await viewModel.reload()
                            }
                        }
                    )
                } else {
                    ScrollView {
                        VStack(spacing: UIConstants.Spacing.medium) {
                            ForEach(viewModel.availableModules) { module in
                                NavigationLink {
                                    destinationView(for: module)
                                } label: {
                                    ModuleCard(module: module)
                                        .padding(.horizontal, UIConstants.Padding.screen)
                                }
                            }
                        }
                        .padding(.top, UIConstants.Spacing.extraLarge)
                        .padding(.bottom, UIConstants.Padding.bottomToolbarSpacer)
                    }
                    .refreshable {
                        await viewModel.reload()
                    }
                }
            }
            .navigationTitle("LunaSea")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button(action: {}, label: {
                        Label("Menu", systemImage: SystemIcon.menu)
                    })
                }

                ToolbarItemGroup(placement: .platformBottom) {
                    Button(action: {}, label: {
                        Label("Modules", systemImage: SystemIcon.grid3x3)
                    })
                    .pillStyle(prominent: true)

                    Spacer()

                    Button(action: {}, label: {
                        Label("Calendar", systemImage: SystemIcon.calendar)
                    })
                    .cardStyle()
                }
            }
        }
    }
}

// MARK: - Module Card View

struct ModuleCard: View {
    let module: Module

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: UIConstants.Spacing.small) {
                Text(module.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                Text(module.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Image(systemName: module.systemIcon)
                .font(.title2)
                .foregroundColor(module.tint)
                .padding(.leading, UIConstants.Spacing.small)
        }
        .padding(UIConstants.Padding.card)
        .background(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card, style: .continuous)
                .fill(Color.platformSecondaryGroupedBackground)
        )
        .shadow(
            color: UIConstants.Shadow.cardColor,
            radius: UIConstants.Shadow.cardRadius,
            x: UIConstants.Shadow.cardX,
            y: UIConstants.Shadow.cardY
        )
    }
}

// MARK: - Previews

extension DashboardView {
    @ViewBuilder
    func destinationView(for module: Module) -> some View {
        switch module.id {
        case "lidarr": LidarrView().navigationTitle(module.title)
        case "radarr": RadarrView().navigationTitle(module.title)
        case "sabnzbd": SABnzbdView().navigationTitle(module.title)
        case "search": SearchView().navigationTitle(module.title)
        case "sonarr": SonarrView().navigationTitle(module.title)
        case "tautulli": TautulliView().navigationTitle(module.title)
        case "settings": SettingsView().navigationTitle(module.title)
        default: PlaceholderEmptyView().navigationTitle(module.title)
        }
    }
}

#Preview {
    Group {
        DashboardView()
    }
}
