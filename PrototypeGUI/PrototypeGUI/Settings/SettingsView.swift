import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings")
                .font(.largeTitle)
                .foregroundColor(.primary)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SettingsView()
}
