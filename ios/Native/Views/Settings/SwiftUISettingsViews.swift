//
//  SwiftUISettingsViews.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-09-29.
//  SwiftUI Settings Views following MVVM pattern with @Observable
//

import SwiftUI


#if DEBUG
struct SwiftUISettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISettingsView(viewModel: SettingsViewModel())
    }
}

struct SwiftUIProfilesView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIProfilesView(viewModel: ProfilesViewModel(settingsViewModel: SettingsViewModel()))
    }
}

struct SwiftUIConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIConfigurationView(viewModel: ConfigurationViewModel(settingsViewModel: SettingsViewModel()))
    }
}

struct SwiftUISystemLogsView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUISystemLogsView(viewModel: SystemLogsViewModel())
    }
}
#endif
