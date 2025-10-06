//
//  MovieCardView.swift
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

/// Display mode for movie card
enum MovieCardLayout {
    case grid
    case list
}

/// Reusable movie card component for displaying movie information
///
/// Supports both grid and list layouts with status indicators, quality badges, and loading states.
/// Based on legacy Flutter RadarrCatalogueTile with modernized SwiftUI patterns.
/// Follows MVVM-C architecture - only depends on display models, not domain models.
///
/// Usage:
/// ```swift
/// MovieCardView(movie: movieDisplayModel, layout: .grid, onTap: { print("Tapped") })
/// ```
struct MovieCardView: View {
    // MARK: - Properties
    
    let movie: MovieDisplayModel
    let layout: MovieCardLayout
    let onTap: () -> Void
    
    // MARK: - Initialization
    
    init(movie: MovieDisplayModel, layout: MovieCardLayout = .grid, onTap: @escaping () -> Void) {
        self.movie = movie
        self.layout = layout
        self.onTap = onTap
    }
    
    // MARK: - Body
    
    var body: some View {
        switch layout {
        case .grid:
            gridCard
        case .list:
            listCard
        }
    }
    
    // MARK: - Grid Layout
    
    private var gridCard: some View {
        Button(action: onTap) {
            VStack(spacing: Spacing.xs) {
                // Poster image
                posterImage
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .overlay(alignment: .topTrailing) {
                        statusBadge
                    }
                    .overlay(alignment: .bottomTrailing) {
                        qualityBadge
                    }
                
                // Movie info
                VStack(alignment: .leading, spacing: Spacing.xxs) {
                    Text(movie.title)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.themePrimaryText)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                    if let yearText = movie.yearText {
                        Text(yearText)
                            .font(.caption2)
                            .foregroundStyle(Color.themeSecondaryText)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, Spacing.xs)
                .padding(.bottom, Spacing.sm)
            }
            .background(Color.themeCardBackground)
            .cornerRadius(CornerRadius.medium)
            .opacity(movie.monitored ? 1.0 : 0.5)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabelText)
        .accessibilityHint("Double tap to view movie details")
    }
    
    // MARK: - List Layout
    
    private var listCard: some View {
        Button(action: onTap) {
            HStack(spacing: Spacing.md) {
                // Poster thumbnail
                posterImage
                    .frame(width: 60, height: 90)
                    .cornerRadius(CornerRadius.small)
                    .overlay(alignment: .topTrailing) {
                        statusBadge
                            .scaleEffect(0.7)
                            .offset(x: 4, y: -4)
                    }
                
                // Movie info
                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(movie.title)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(Color.themePrimaryText)
                        .lineLimit(2)
                    
                    HStack(spacing: Spacing.sm) {
                        if let yearText = movie.yearText {
                            Label(yearText, systemImage: "calendar")
                                .font(.caption)
                                .foregroundStyle(Color.themeSecondaryText)
                        }
                        
                        if let runtimeText = movie.shortRuntimeText {
                            Label(runtimeText, systemImage: "clock")
                                .font(.caption)
                                .foregroundStyle(Color.themeSecondaryText)
                        }
                    }
                    
                    // File status
                    HStack(spacing: Spacing.sm) {
                        if movie.hasFile {
                            Label(movie.statusText, systemImage: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundStyle(.green)
                        } else {
                            Label(movie.statusText, systemImage: "exclamationmark.circle")
                                .font(.caption)
                                .foregroundStyle(.orange)
                        }
                        
                        Label(
                            movie.monitoringText,
                            systemImage: movie.monitored ? "eye.fill" : "eye.slash"
                        )
                        .font(.caption)
                        .foregroundStyle(Color.themeSecondaryText)
                    }
                    
                    // Quality badge
                    if movie.qualityProfileId != nil {
                        qualityBadge
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                // Chevron indicator
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundStyle(Color.themeTertiaryText)
            }
            .padding(Spacing.md)
            .background(Color.themeCardBackground)
            .cornerRadius(CornerRadius.medium)
            .opacity(movie.monitored ? 1.0 : 0.5)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabelText)
        .accessibilityHint("Double tap to view movie details")
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var posterImage: some View {
        if let posterURL = movie.posterURL {
            AsyncImage(url: posterURL) { phase in
                switch phase {
                case .empty:
                    ZStack {
                        Color.themeSecondaryBackground
                        ProgressView()
                            .tint(Color.themeAccent)
                    }
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    ZStack {
                        Color.themeSecondaryBackground
                        Image(systemName: "film")
                            .font(.largeTitle)
                            .foregroundStyle(Color.themeTertiaryText)
                    }
                @unknown default:
                    ZStack {
                        Color.themeSecondaryBackground
                        Image(systemName: "film")
                            .font(.largeTitle)
                            .foregroundStyle(Color.themeTertiaryText)
                    }
                }
            }
        } else {
            ZStack {
                Color.themeSecondaryBackground
                Image(systemName: "film")
                    .font(.largeTitle)
                    .foregroundStyle(Color.themeTertiaryText)
            }
        }
    }
    
    @ViewBuilder
    private var statusBadge: some View {
        if movie.monitored && movie.hasFile {
            Circle()
                .fill(.green)
                .frame(width: 12, height: 12)
                .overlay {
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                }
                .padding(Spacing.xs)
                .accessibilityLabel("Downloaded and monitored")
        } else if movie.monitored && !movie.hasFile {
            Circle()
                .fill(.orange)
                .frame(width: 12, height: 12)
                .overlay {
                    Circle()
                        .stroke(Color.white, lineWidth: 2)
                }
                .padding(Spacing.xs)
                .accessibilityLabel("Missing file, monitored")
        }
    }
    
    @ViewBuilder
    private var qualityBadge: some View {
        if let profileName = movie.qualityProfileName {
            Text(profileName)
                .font(.caption2.weight(.medium))
                .foregroundStyle(.white)
                .padding(.horizontal, Spacing.xs)
                .padding(.vertical, Spacing.xxs)
                .background(Color.themeAccent.opacity(0.9))
                .cornerRadius(CornerRadius.small)
                .padding(Spacing.xs)
                .accessibilityLabel("Quality profile: \(profileName)")
        } else if let qualityProfileId = movie.qualityProfileId {
            Text("Profile \(qualityProfileId)")
                .font(.caption2.weight(.medium))
                .foregroundStyle(.white)
                .padding(.horizontal, Spacing.xs)
                .padding(.vertical, Spacing.xxs)
                .background(Color.themeAccent.opacity(0.9))
                .cornerRadius(CornerRadius.small)
                .padding(Spacing.xs)
                .accessibilityLabel("Quality profile \(qualityProfileId)")
        }
    }
    
    // MARK: - Accessibility
    
    private var accessibilityLabelText: String {
        var label = movie.title
        
        if let yearText = movie.yearText {
            label += ", \(yearText)"
        }
        
        label += ", \(movie.monitoringText.lowercased())"
        label += ", \(movie.statusText.lowercased())"
        
        return label
    }
}

// MARK: - Loading Skeleton

/// Loading skeleton variant of MovieCardView
struct MovieCardSkeleton: View {
    let layout: MovieCardLayout
    
    var body: some View {
        switch layout {
        case .grid:
            gridSkeleton
        case .list:
            listSkeleton
        }
    }
    
    private var gridSkeleton: some View {
        VStack(spacing: Spacing.xs) {
            // Poster placeholder
            Rectangle()
                .fill(Color.themeSecondaryBackground.opacity(0.3))
                .frame(height: 200)
                .frame(maxWidth: .infinity)
                .shimmer()
            
            // Text placeholders
            VStack(alignment: .leading, spacing: Spacing.xxs) {
                Rectangle()
                    .fill(Color.themeSecondaryBackground.opacity(0.3))
                    .frame(height: 16)
                    .frame(maxWidth: .infinity)
                    .shimmer()
                
                Rectangle()
                    .fill(Color.themeSecondaryBackground.opacity(0.3))
                    .frame(height: 12)
                    .frame(width: 60)
                    .shimmer()
            }
            .padding(.horizontal, Spacing.xs)
            .padding(.bottom, Spacing.sm)
        }
        .background(Color.themeCardBackground)
        .cornerRadius(CornerRadius.medium)
    }
    
    private var listSkeleton: some View {
        HStack(spacing: Spacing.md) {
            // Poster placeholder
            Rectangle()
                .fill(Color.themeSecondaryBackground.opacity(0.3))
                .frame(width: 60, height: 90)
                .cornerRadius(CornerRadius.small)
                .shimmer()
            
            // Text placeholders
            VStack(alignment: .leading, spacing: Spacing.xs) {
                Rectangle()
                    .fill(Color.themeSecondaryBackground.opacity(0.3))
                    .frame(height: 16)
                    .frame(maxWidth: .infinity)
                    .shimmer()
                
                Rectangle()
                    .fill(Color.themeSecondaryBackground.opacity(0.3))
                    .frame(height: 12)
                    .frame(width: 100)
                    .shimmer()
                
                Rectangle()
                    .fill(Color.themeSecondaryBackground.opacity(0.3))
                    .frame(height: 12)
                    .frame(width: 120)
                    .shimmer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(Spacing.md)
        .background(Color.themeCardBackground)
        .cornerRadius(CornerRadius.medium)
    }
}

// MARK: - Shimmer Effect

extension View {
    /// Applies a shimmer effect for loading skeletons
    @ViewBuilder
    func shimmer() -> some View {
        self.modifier(ShimmerModifier())
    }
}

private struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { geometry in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.clear,
                                    Color.white.opacity(0.3),
                                    Color.clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .rotationEffect(.degrees(70))
                        .offset(x: phase * geometry.size.width * 2 - geometry.size.width)
                }
            }
            .clipped()
            .onAppear {
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
    }
}

// MARK: - Previews

#Preview("Movie Card - Grid") {
    MovieCardView(movie: .preview, layout: .grid) {
        print("Tapped")
    }
    .frame(width: 150)
    .padding()
}

#Preview("Movie Card - List") {
    MovieCardView(movie: .preview, layout: .list) {
        print("Tapped")
    }
    .padding()
}

#Preview("Movie Card - Grid (Missing)") {
    MovieCardView(movie: .previewMissing, layout: .grid) {
        print("Tapped")
    }
    .frame(width: 150)
    .padding()
}

#Preview("Movie Card - List (Unmonitored)") {
    MovieCardView(movie: .previewUnmonitored, layout: .list) {
        print("Tapped")
    }
    .padding()
}

#Preview("Movie Card Skeleton - Grid") {
    MovieCardSkeleton(layout: .grid)
        .frame(width: 150)
        .padding()
}

#Preview("Movie Card Skeleton - List") {
    MovieCardSkeleton(layout: .list)
        .padding()
}
