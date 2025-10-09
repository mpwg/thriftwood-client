import SwiftUI

struct RadarrConnectionView: View {
    @State private var host: String = "http://localhost"
    @State private var port: String = "7878"
    @State private var apiKey: String = ""
    @State private var useSSL: Bool = false
    @State private var testing: Bool = false
    @State private var lastTestResult: String? = nil

    var body: some View {
        Form {
            Section(header: Text("Connection")) {
                TextField("Host", text: $host)
                    .textContentType(.URL)
                TextField("Port", text: $port)
                    .keyboardType(.numberPad)
                SecureField("API Key", text: $apiKey)
                Toggle("Use SSL", isOn: $useSSL)
            }

            Section {
                Button(action: testConnection) {
                    HStack {
                        Spacer()
                        if testing {
                            ProgressView()
                        } else {
                            Text("Test Connection")
                        }
                        Spacer()
                    }
                }
            }

            if let result = lastTestResult {
                Section(header: Text("Last Test")) {
                    Text(result)
                }
            }
        }
        .navigationTitle("Connection Details")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    // placeholder save action
                }
            }
        }
    }

    private func testConnection() {
        testing = true
        lastTestResult = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            testing = false
            // fake success
            lastTestResult = "Connection successful"
        }
    }
}

#Preview {
    NavigationStack {
        RadarrConnectionView()
    }
}
