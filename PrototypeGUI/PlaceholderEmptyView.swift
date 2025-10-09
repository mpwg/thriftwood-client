import SwiftUI

struct PlaceholderEmptyView: View {
    var body: some View {
        VStack {
            Text("Select an item from the sidebar")
                .font(.title2)
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
    }
}

#Preview {
    PlaceholderEmptyView()
}
