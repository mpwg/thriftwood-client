//
//  AddSingleMovieView.swift
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

struct AddSingleMovieView: View {
    let movie: Movie

    @State private var monitoring: Bool
    // Picker state
    @State private var selectedRoot: String
    @State private var selectedAvailability: String
    @State private var selectedQuality: String
    @State private var selectedTags: [String]

    @State private var showingRootPicker = false
    @State private var showingAvailabilityPicker = false
    @State private var showingQualityPicker = false
    @State private var showingTagsPicker = false

    // Sample options for pickers
    private let rootOptions = ["/data/media/Filme", "/mnt/movies", "/Volumes/Media/Movies"]
    private let availabilityOptions = ["Released", "In Cinemas", "Pre-Order"]
    private let qualityOptions = ["SD", "HD Bluray + WEB", "4K Remux"]
    private let tagOptions = ["Action", "Drama", "Sci-Fi", "Favorite", "Kids"]

    init(movie: Movie) {
        self.movie = movie
        // initialize local state from model so the toggle is interactive in the UI preview
        self._monitoring = State(initialValue: movie.monitoring ?? true)
        self._selectedRoot = State(initialValue: movie.path ?? "/data/media/Filme")
        self._selectedAvailability = State(initialValue: movie.availability ?? "Released")
        self._selectedQuality = State(initialValue: movie.quality ?? "HD Bluray + WEB")
        self._selectedTags = State(initialValue: movie.tags ?? [])
    }

    var body: some View {
        @State var startSearch: Bool = true

        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: UIConstants.Spacing.large) {
                    // Header card
                    HStack(spacing: UIConstants.Spacing.medium) {
                        (movie.poster ?? Image(systemName: "photo"))
                            .resizable()
                            .frame(
                                width: UIConstants.ImageSize.posterThumbnail.width,
                                height: UIConstants.ImageSize.posterThumbnail.height
                            )
                            .cornerRadius(UIConstants.CornerRadius.small)

                        VStack(alignment: .leading, spacing: UIConstants.Spacing.small) {
                            Text(movie.title)
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)

                            Text("\(movie.year) · \(movie.runtime) · \(movie.studio)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            if let overview = movie.overview {
                                Text(overview)
                                    .font(.subheadline)
                                    .italic()
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                        }

                        Spacer()
                    }
                    .padding(UIConstants.Padding.card)
                    .background(
                        RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
                            .fill(Color.platformSecondaryGroupedBackground)
                    )

                    // Settings list
                    VStack(spacing: UIConstants.Spacing.medium) {
                        SettingRow(title: "Root Folder", subtitle: selectedRoot, showsChevron: true) {
                            showingRootPicker = true
                        }

                        SettingToggleRow(title: "Monitor", isOn: $monitoring)

                        SettingRow(title: "Minimum Availability", subtitle: selectedAvailability, showsChevron: true) {
                            showingAvailabilityPicker = true
                        }

                        SettingRow(title: "Quality Profile", subtitle: selectedQuality, showsChevron: true) {
                            showingQualityPicker = true
                        }

                        SettingRow(title: "Tags", subtitle: (selectedTags.isEmpty ? "—" : selectedTags.joined(separator: ", ")), showsChevron: true) {
                            showingTagsPicker = true
                        }
                    }

                    Spacer(minLength: UIConstants.Padding.bottomToolbarSpacer)
                }
                .padding(UIConstants.Padding.screen)
            }

            // Bottom action bar (floating at bottom)
            HStack(spacing: UIConstants.Spacing.medium) {
                Toggle("Search on add", isOn: $startSearch)
                Spacer()
                Button(action: {}, label: {
                    Label("Add", systemImage: SystemIcon.add)
                        .font(.headline)
                        .frame(minWidth: 80)
                })
                .pillStyle(prominent: true)
            }
            .padding(.horizontal, UIConstants.Padding.screen)
            .padding(.vertical, UIConstants.Padding.compact)
            .background(Color.platformGroupedBackground.ignoresSafeArea(edges: .bottom))
        }
        .navigationTitle("Add Movie")
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
        .sheet(isPresented: $showingRootPicker) {
            rootPickerSheet()
        }
        .sheet(isPresented: $showingAvailabilityPicker) {
            availabilityPickerSheet()
        }
        .sheet(isPresented: $showingQualityPicker) {
            qualityPickerSheet()
        }
        .sheet(isPresented: $showingTagsPicker) {
            tagsPickerSheet()
        }
    }
}

// MARK: - Row components

private struct SettingRow: View {
    let title: String
    let subtitle: String?
    var showsChevron: Bool = false
    var action: (() -> Void)?

    var body: some View {
        Button(action: { action?() }, label: {
            HStack {
                VStack(alignment: .leading, spacing: UIConstants.Spacing.tiny) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                Spacer()
                if showsChevron {
                    Image(systemName: SystemIcon.disclosure)
                        .foregroundColor(.secondary)
                }
            }
            .padding(UIConstants.Padding.card)
            .background(
                RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
                    .fill(Color.platformSecondaryGroupedBackground)
            )
        })
        .buttonStyle(PlainButtonStyle())
    }
}

private struct SettingToggleRow: View {
    let title: String
    @Binding var isOn: Bool

    init(title: String, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }

    var body: some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
                .toggleStyle(SwitchToggleStyle(tint: .mint))
        }
        .padding(UIConstants.Padding.card)
        .background(
            RoundedRectangle(cornerRadius: UIConstants.CornerRadius.card)
                .fill(Color.platformSecondaryGroupedBackground)
        )
    }
}

#Preview {
    NavigationStack {
        AddSingleMovieView(movie: Movie.sample[0])
    }
}

// MARK: - Pickers (sheets)

extension AddSingleMovieView {
    // Root folder picker sheet
    @ViewBuilder
    func rootPickerSheet() -> some View {
        NavigationStack {
            List {
                ForEach(rootOptions, id: \.self) { r in
                    Button(action: {
                        selectedRoot = r
                    }, label: {
                        HStack {
                            Text(r)
                            Spacer()
                            if r == selectedRoot {
                                Image(systemName: SystemIcon.checkmark)
                            }
                        }
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Root Folder")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { showingRootPicker = false }, label: {
                        Label("Done", systemImage: SystemIcon.checkmark)
                    })
                }
            }
        }
    }

    func availabilityPickerSheet() -> some View {
        NavigationStack {
            List {
                ForEach(availabilityOptions, id: \.self) { a in
                    Button(action: {
                        selectedAvailability = a
                    }, label: {
                        HStack {
                            Text(a)
                            Spacer()
                            if a == selectedAvailability {
                                Image(systemName: SystemIcon.checkmark)
                            }
                        }
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Minimum Availability")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { showingAvailabilityPicker = false }, label: {
                        Label("Done", systemImage: SystemIcon.checkmark)
                    })
                }
            }
        }
    }

    func qualityPickerSheet() -> some View {
        NavigationStack {
            List {
                ForEach(qualityOptions, id: \.self) { quality in
                    Button(action: {
                        selectedQuality = quality
                    }, label: {
                        HStack {
                            Text(quality)
                            Spacer()
                            if quality == selectedQuality {
                                Image(systemName: SystemIcon.checkmark)
                            }
                        }
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Quality Profile")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { showingQualityPicker = false }, label: {
                        Label("Done", systemImage: SystemIcon.checkmark)
                    })
                }
            }
        }
    }

    func tagsPickerSheet() -> some View {
        NavigationStack {
            List {
                ForEach(tagOptions, id: \.self) { tag in
                    Button(action: {
                        if selectedTags.contains(tag) { selectedTags.removeAll { $0 == tag } } else { selectedTags.append(tag) }
                    }, label: {
                        HStack {
                            Text(tag)
                            Spacer()
                            if selectedTags.contains(tag) {
                                Image(systemName: SystemIcon.checkmark)
                            }
                        }
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Tags")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(action: { showingTagsPicker = false }, label: {
                        Label("Done", systemImage: SystemIcon.checkmark)
                    })
                }
            }
        }
    }
}
