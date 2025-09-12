import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                DashboardView()
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Dashboard")
                    }

                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
        }
    }
}

struct DashboardView: View {
    var body: some View {
        VStack(spacing: 20) {
            Text("Thriftwood Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Native iOS Implementation")
                .font(.title2)
                .foregroundStyle(.secondary)

            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: 160, maximum: 200), spacing: 16)
                ], spacing: 16
            ) {
                ModuleCard(name: "Sonarr", isEnabled: true)
                ModuleCard(name: "Radarr", isEnabled: true)
                ModuleCard(name: "Lidarr", isEnabled: false)
                ModuleCard(name: "Overseerr", isEnabled: true)
            }
            .padding()
        }
        .padding()
        .navigationTitle("Dashboard")
    }
}

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var selectedTheme = "System"
    @State private var analyticsEnabled = false

    var body: some View {
        NavigationView {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $selectedTheme) {
                        Text("Light").tag("Light")
                        Text("Dark").tag("Dark")
                        Text("System").tag("System")
                    }
                }

                Section("Notifications") {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                }

                Section("About") {
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundStyle(.secondary)
                    }

                    Toggle("Analytics", isOn: $analyticsEnabled)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct ModuleCard: View {
    let name: String
    let isEnabled: Bool

    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 8)
                .fill(isEnabled ? Color.blue : Color.gray)
                .frame(height: 80)
                .overlay(
                    Text(name.prefix(1).uppercased())
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                )

            VStack(spacing: 4) {
                Text(name)
                    .font(.headline)
                    .lineLimit(1)

                Text(isEnabled ? "Enabled" : "Disabled")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(Color.primary.colorInvert())
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

#if DEBUG
    #Preview("iPhone") {
        ContentView()
    }

    #Preview("iPad") {
        ContentView()
    }

    #Preview("Mac") {
        ContentView()
    }
#endif
