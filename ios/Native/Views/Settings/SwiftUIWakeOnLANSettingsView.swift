//
//  SwiftUIWakeOnLANSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUIWakeOnLANSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Wake on LAN Configuration") {
                    Toggle("Enable Wake on LAN", isOn: Binding(
                        get: { viewModel.selectedProfile?.wakeOnLanEnabled ?? false },
                        set: { newValue in
                            viewModel.selectedProfile?.wakeOnLanEnabled = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                    
                    if viewModel.selectedProfile?.wakeOnLanEnabled == true {
                        TextField("MAC Address", text: Binding(
                            get: { viewModel.selectedProfile?.wakeOnLanMACAddress ?? "" },
                            set: { newValue in
                                viewModel.selectedProfile?.wakeOnLanMACAddress = newValue
                                Task { await viewModel.saveSettings() }
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .autocapitalization(.allCharacters)
                        
                        TextField("Broadcast Address", text: Binding(
                            get: { viewModel.selectedProfile?.wakeOnLanBroadcastAddress ?? "" },
                            set: { newValue in
                                viewModel.selectedProfile?.wakeOnLanBroadcastAddress = newValue
                                Task { await viewModel.saveSettings() }
                            }
                        ))
                        .textFieldStyle(.roundedBorder)
                        .keyboardType(.decimalPad)
                    }
                }
                
                if viewModel.selectedProfile?.wakeOnLanEnabled == true {
                    Section("Test") {
                        Button(action: {
                            Task {
                                await viewModel.sendWakeOnLANPacket()
                            }
                        }) {
                            HStack {
                                if viewModel.isWakingDevice {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "wifi.router")
                                }
                                Text("Send Wake Signal")
                            }
                        }
                        .buttonStyle(.bordered)
                        .disabled(viewModel.isWakingDevice)
                    }
                }
            }
            .navigationTitle("Wake on LAN")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Back") {
                        dismiss()
                    }
                }
            }
        }
    }
}