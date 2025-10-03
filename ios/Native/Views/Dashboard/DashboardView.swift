//
//  DashboardView.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-09-30.
//  Main dashboard view for the Thriftwood app
//

import SwiftUI

/// Main dashboard view showing modules and calendar
/// This view provides the primary interface for accessing media management services
struct DashboardView: View {
    // MARK: - Properties
    @Binding var navigationPath: NavigationPath
    
    @State private var viewModel = DashboardViewModel()
    @State private var selectedTab: Int = 0
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Initialization
    // SwiftUI will automatically generate the required init with @Binding parameters
    
    // MARK: - Body
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Modules tab - Swift equivalent of ModulesPage
            ModulesView(viewModel: viewModel, navigationPath: $navigationPath)
                .tabItem {
                    Image(systemName: "square.grid.2x2")
                    Text("Modules")
                }
                .tag(0)
            
            // Calendar tab - Swift equivalent of CalendarPage  
            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendar")
                }
                .tag(1)
        }
        .navigationTitle("LunaSea")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                // Quick Actions Menu - Swift equivalent of Flutter's quick actions
                QuickActionsMenu(viewModel: viewModel)
                
                SwitchViewButton(selectedTab: $selectedTab)
            }
        }
        .refreshable {
            await viewModel.refresh()
        }
        .onAppear {
            Task {
                await viewModel.refresh()
            }
        }
    }
}

// MARK: - Preview

#Preview {
    DashboardView(navigationPath: .constant(NavigationPath()))
}
