import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: Text("Account")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Account")
                            }
                            Spacer()
                            Image(systemName: "person.fill")
                        }
                    }

                    NavigationLink(destination: ConfigurationView()) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Configuration")
                            }
                            Spacer()
                            Image(systemName: "network")
                        }
                    }

                    NavigationLink(destination: Text("Notifications")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Notifications")
                            }
                            Spacer()
                            Image(systemName: "bell.fill")
                        }
                    }

                    NavigationLink(destination: Text("Profiles")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Profiles")
                            }
                            Spacer()
                            Image(systemName: "person.crop.square")
                        }
                    }
                }

                Section {
                    NavigationLink(destination: Text("Donations")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Donations")
                            }
                            Spacer()
                            Image(systemName: "dollarsign.circle")
                        }
                    }

                    NavigationLink(destination: Text("Resources")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Resources")
                            }
                            Spacer()
                            Image(systemName: "questionmark.circle")
                        }
                    }

                    NavigationLink(destination: Text("System")) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("System")
                            }
                            Spacer()
                            Image(systemName: "gearshape.fill")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .listStyle(.insetGrouped)
        }
    }
}

#Preview {
    SettingsView()
}
