import SwiftUI

// Platform-aware semantic colors to keep the view compilable on macOS and iOS
 

struct RadarrView: View {
    private let movies: [Movie] = Movie.sample

    var body: some View {
    NavigationStack {
                ZStack {
                Color.platformGroupedBackground
                    .ignoresSafeArea()

                VStack(spacing: 12) {
                    // Top toolbar moved into the NavigationStack's toolbar modifier below.

                    ScrollView {
                        VStack(spacing: 14) {
                            ForEach(movies) { movie in
                                NavigationLink {
                                    MovieDetailView(movie: movie)
                                } label: {
                                    MovieRow(movie: movie)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 120)
                    }
                    .navigationTitle("Radarr")
#if os(iOS)
                    .navigationBarTitleDisplayMode(.large)
#endif

                    Spacer()
                }
                .toolbar {
                    // Leading: search field style
                    ToolbarItem(placement: .navigation) {
                        // Standard label-only search affordance
                        Label("Search...", systemImage: "magnifyingglass")
                    }

                    // Trailing group: filter/grid/plus/ellipsis
                    ToolbarItemGroup(placement: .automatic) {
                        // Standard toolbar buttons (image + text)
                        Button(action: { /* filter action */ }) {
                            Label("Filter", systemImage: "line.3.horizontal.decrease")
                        }

                        Button(action: { /* secondary filter action */ }) {
                            Label("More Filters", systemImage: "line.horizontal.3.decrease.circle")
                        }

                        Button(action: { /* toggle grid action */ }) {
                            Label("Grid", systemImage: "square.grid.2x2")
                        }

                        NavigationLink(destination: AddMovieView()) {
                            Label("Add", systemImage: "plus")
                        }

                        Button(action: { /* more */ }) {
                            Label("More", systemImage: "ellipsis")
                        }
                    }
                }

                // Bottom pill toolbar
                VStack {
                    Spacer()
                    HStack {
                            Button(action: {}) {
                                Label("Movies", systemImage: "film.fill")
                                    .background(.regularMaterial)
                                    .clipShape(.capsule)
                            }


                            Spacer()

                            HStack(spacing: 20) {
                                Button(action: {}) {
                                    Label("Calendar", systemImage: "calendar")
                                        .background(.regularMaterial)
                                        .clipShape(.capsule)
                                }
                                Button(action: {}) { Label("Grid", systemImage: "square.grid.3x2.fill")
                                        .background(.regularMaterial)
                                        .clipShape(.capsule)}
                            }
                        }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}



// MARK: - Previews

#Preview {
    Group {
        RadarrView()
    }
}

