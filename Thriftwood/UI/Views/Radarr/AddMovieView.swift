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
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.mint)
                    Text("Search...")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                    Spacer()
                }
                .padding(12)
                .background(RoundedRectangle(cornerRadius: 12).fill(Color.platformSecondaryGroupedBackground))
                .padding()

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
fileprivate struct SearchTabView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                ForEach(Movie.sample) { movie in
                    NavigationLink(destination: AddSingleMovieView(movie: movie)) {
                        MovieRow(movie: movie)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.top)
            .padding(.bottom, 80)
        }
    }
}

fileprivate struct DiscoverTabView: View {
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
