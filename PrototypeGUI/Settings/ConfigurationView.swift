import SwiftUI

struct ConfigurationView: View {
    var body: some View {
        List {
            Section {
                NavigationLink(destination: Text("General settings")) {
                    HStack {
                        Text("General")
                        Spacer()
                        Image(systemName: "paintbrush")
                    }
                }

                NavigationLink(destination: Text("Drawer settings")) {
                    HStack {
                        Text("Drawer")
                        Spacer()
                        Image(systemName: "line.3.horizontal")
                    }
                }

                NavigationLink(destination: Text("Quick Actions settings")) {
                    HStack {
                        Text("Quick Actions")
                        Spacer()
                        Image(systemName: "square.dashed")
                    }
                }
            }

            Section {
                NavigationLink(destination: Text("Dashboard settings")) {
                    HStack {
                        Text("Dashboard")
                        Spacer()
                        Image(systemName: "house.fill")
                    }
                }

                NavigationLink(destination: Text("External Modules settings")) {
                    HStack {
                        Text("External Modules")
                        Spacer()
                        Image(systemName: "chevron.left.slash.chevron.right")
                    }
                }

                NavigationLink(destination: Text("Lidarr settings")) {
                    HStack {
                        Text("Lidarr")
                        Spacer()
                        Image(systemName: "bolt.circle")
                    }
                }

                NavigationLink(destination: Text("NZBGet settings")) {
                    HStack {
                        Text("NZBGet")
                        Spacer()
                        Image(systemName: "arrow.down.circle")
                    }
                }

                NavigationLink(destination: RadarrSettingsView()) {
                    HStack {
                        Text("Radarr")
                        Spacer()
                        Image(systemName: "play.circle")
                    }
                }

                NavigationLink(destination: Text("SABnzbd settings")) {
                    HStack {
                        Text("SABnzbd")
                        Spacer()
                        Image(systemName: "printer.fill")
                    }
                }

                NavigationLink(destination: Text("Search settings")) {
                    HStack {
                        Text("Search")
                        Spacer()
                        Image(systemName: "magnifyingglass")
                    }
                }

                NavigationLink(destination: Text("Sonarr settings")) {
                    HStack {
                        Text("Sonarr")
                        Spacer()
                        Image(systemName: "staroflife.fill")
                    }
                }
            }
        }
        .navigationTitle("Configuration")
        .listStyle(.insetGrouped)
    }
}

#Preview {
    ConfigurationView()
}
