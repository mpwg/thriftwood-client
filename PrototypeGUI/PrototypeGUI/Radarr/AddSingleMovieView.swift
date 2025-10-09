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
        @State var StartSearch: Bool = true

        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(spacing: 16) {
                    // Header card
                    HStack(spacing: 12) {
                        (movie.poster ?? Image(systemName: "photo"))
                            .resizable()
                            .frame(width: 64, height: 96)
                            .cornerRadius(8)

                        VStack(alignment: .leading, spacing: 6) {
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
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.platformSecondaryGroupedBackground))

                    // Settings list
                    VStack(spacing: 12) {
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

                    Spacer(minLength: 120)
                }
                .padding()
            }

            // Bottom action bar (floating at bottom)
            HStack(spacing: 12) {

                Toggle("Search on add", isOn: $StartSearch)
                Spacer()
                Button(action: {}) {
                    HStack {
                        Image(systemName: "plus")
                            .foregroundColor(.mint)
                        Text("Add")
                            .font(.headline)
                            .foregroundColor(.primary)
                    }
                    .frame(minWidth: 80)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.platformSecondaryGroupedBackground))
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
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

fileprivate struct SettingRow: View {
    let title: String
    let subtitle: String?
    var showsChevron: Bool = false
    var action: (() -> Void)? = nil

    var body: some View {
        Button(action: { action?() }) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
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
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 12).fill(Color.platformSecondaryGroupedBackground))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

fileprivate struct SettingToggleRow: View {
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
        .padding()
        .background(RoundedRectangle(cornerRadius: 12).fill(Color.platformSecondaryGroupedBackground))
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
                    }) {
                        HStack {
                            Text(r)
                            Spacer()
                            if r == selectedRoot { Image(systemName: "checkmark") }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Root Folder")
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button(action: { showingRootPicker = false }) { Label("Done", systemImage: "checkmark") } } }
        }
    }

    func availabilityPickerSheet() -> some View {
        NavigationStack {
            List {
                ForEach(availabilityOptions, id: \.self) { a in
                    Button(action: {
                        selectedAvailability = a
                    }) {
                        HStack {
                            Text(a)
                            Spacer()
                            if a == selectedAvailability { Image(systemName: "checkmark") }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Minimum Availability")
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button(action: { showingAvailabilityPicker = false }) { Label("Done", systemImage: "checkmark") } } }
        }
    }

    func qualityPickerSheet() -> some View {
        NavigationStack {
            List {
                ForEach(qualityOptions, id: \.self) { q in
                    Button(action: {
                        selectedQuality = q
                    }) {
                        HStack {
                            Text(q)
                            Spacer()
                            if q == selectedQuality { Image(systemName: "checkmark") }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Quality Profile")
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button(action: { showingQualityPicker = false }) { Label("Done", systemImage: "checkmark") } } }
        }
    }

    func tagsPickerSheet() -> some View {
        NavigationStack {
            List {
                ForEach(tagOptions, id: \.self) { t in
                    Button(action: {
                        if selectedTags.contains(t) { selectedTags.removeAll { $0 == t } }
                        else { selectedTags.append(t) }
                    }) {
                        HStack {
                            Text(t)
                            Spacer()
                            if selectedTags.contains(t) { Image(systemName: "checkmark") }
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationTitle("Tags")
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button(action: { showingTagsPicker = false }) { Label("Done", systemImage: "checkmark") } } }
        }
    }
}
