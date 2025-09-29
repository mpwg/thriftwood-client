//
//  MainTabView.swift
//  Thriftwood
//
//  Main application tab navigation matching Flutter module structure
//

import SwiftUI

/// Main tab navigation for Thriftwood modules
struct MainTabView: View {
    @Environment(ThemeManager.self) private var themeManager
    @State private var selectedTab: Tab = .dashboard
    
    enum Tab: String, CaseIterable {
        case dashboard = "dashboard"
        case radarr = "radarr"
        case sonarr = "sonarr"
        case lidarr = "lidarr"
        case downloads = "downloads"
        case tautulli = "tautulli"
        case search = "search"
        case settings = "settings"
        
        var title: String {
            switch self {
            case .dashboard: return "Dashboard"
            case .radarr: return "Radarr"
            case .sonarr: return "Sonarr"
            case .lidarr: return "Lidarr"
            case .downloads: return "Downloads"
            case .tautulli: return "Tautulli"
            case .search: return "Search"
            case .settings: return "Settings"
            }
        }
        
        var iconName: String {
            switch self {
            case .dashboard: return "house"
            case .radarr: return "film"
            case .sonarr: return "tv"
            case .lidarr: return "music.note"
            case .downloads: return "arrow.down.circle"
            case .tautulli: return "chart.bar"
            case .search: return "magnifyingglass"
            case .settings: return "gear"
            }
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Dashboard Module
            DashboardView()
                .tabItem {
                    Image(systemName: Tab.dashboard.iconName)
                    Text(Tab.dashboard.title)
                }
                .tag(Tab.dashboard)
            
            // Radarr Module
            RadarrHomeView()
                .tabItem {
                    Image(systemName: Tab.radarr.iconName)
                    Text(Tab.radarr.title)
                }
                .tag(Tab.radarr)
            
            // Sonarr Module
            SonarrHomeView()
                .tabItem {
                    Image(systemName: Tab.sonarr.iconName)
                    Text(Tab.sonarr.title)
                }
                .tag(Tab.sonarr)
            
            // Lidarr Module
            LidarrHomeView()
                .tabItem {
                    Image(systemName: Tab.lidarr.iconName)
                    Text(Tab.lidarr.title)
                }
                .tag(Tab.lidarr)
            
            // Downloads Module
            DownloadsView()
                .tabItem {
                    Image(systemName: Tab.downloads.iconName)
                    Text(Tab.downloads.title)
                }
                .tag(Tab.downloads)
            
            // Tautulli Module
            TautulliHomeView()
                .tabItem {
                    Image(systemName: Tab.tautulli.iconName)
                    Text(Tab.tautulli.title)
                }
                .tag(Tab.tautulli)
            
            // Search Module
            SearchView()
                .tabItem {
                    Image(systemName: Tab.search.iconName)
                    Text(Tab.search.title)
                }
                .tag(Tab.search)
            
            // Settings Module
            SettingsView()
                .tabItem {
                    Image(systemName: Tab.settings.iconName)
                    Text(Tab.settings.title)
                }
                .tag(Tab.settings)
        }
        .thriftwoodTheme(themeManager)
    }
}

// MARK: - Placeholder Views for Modules

struct DashboardView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "house.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                
                Text("Dashboard")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Central hub for all your services")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Dashboard")
        }
    }
}

struct RadarrHomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "film.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                
                Text("Radarr")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Movie collection management")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Radarr")
        }
    }
}

struct SonarrHomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "tv.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                
                Text("Sonarr")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("TV series management")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Sonarr")
        }
    }
}

struct LidarrHomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "music.note")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                
                Text("Lidarr")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Music collection management")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Lidarr")
        }
    }
}

struct DownloadsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "arrow.down.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                
                Text("Downloads")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("NZBGet & SABnzbd monitoring")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Downloads")
        }
    }
}

struct TautulliHomeView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "chart.bar.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                
                Text("Tautulli")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Plex analytics and monitoring")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Tautulli")
        }
    }
}

struct SearchView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                
                Text("Search")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Cross-service content search")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Search")
        }
    }
}

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "gear")
                    .font(.system(size: 60))
                    .foregroundColor(.secondary)
                
                Text("Settings")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Configure profiles and services")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    MainTabView()
        .environment(ThemeManager())
}