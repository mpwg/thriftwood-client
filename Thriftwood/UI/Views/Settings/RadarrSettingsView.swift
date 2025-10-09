import SwiftUI

struct RadarrSettingsView: View {
    @State private var enabled: Bool = true
    @State private var discoverSuggestions: Bool = true
    @State private var queueSize: Int = 50

    var body: some View {
        List {
            // Header card with description and buttons
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .top) {
                        Image(systemName: "play.circle.fill")
                            .font(.title)
                        VStack(alignment: .leading) {
                            Text("Radarr")
                                .font(.headline)
                            Text("Radarr is a movie collection manager for Usenet and BitTorrent users. It can monitor multiple RSS feeds for new movies and will interface with clients and indexers to grab, sort, and rename them. It can also be configured to automatically upgrade the quality of existing files in the library when a better quality format becomes available.")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button(action: {}) {
                            Image(systemName: "xmark.circle.fill")
                        }
                    }

                    HStack(spacing: 12) {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "logo.github")
                                Text("GitHub")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)

                        Button(action: {}) {
                            HStack {
                                Image(systemName: "house.fill")
                                Text("Website")
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding(.vertical, 4)
            }

            Section {
                Toggle("Enable Radarr", isOn: $enabled)
            }

            Section {
                NavigationLink(destination: RadarrConnectionView()) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Connection Details")
                            Text("Connection Details for Radarr")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }

                NavigationLink(destination: Text("Default Options")) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Default Options")
                            Text("Set Sorting, Filtering, and View Options")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }

                NavigationLink(destination: Text("Default Pages")) {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Default Pages")
                            Text("Set Default Landing Pages")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                }

                Toggle("Discover Suggestions", isOn: $discoverSuggestions)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Queue Size")
                        Text("\(queueSize) Items")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "rectangle.stack.badge.plus")
                }
            }
        }
        .navigationTitle("Radarr")
        .listStyle(.insetGrouped)
    }
}

#Preview {
    RadarrSettingsView()
}
