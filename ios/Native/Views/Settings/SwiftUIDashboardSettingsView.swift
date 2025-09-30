//
//  SwiftUIDashboardSettingsView.swift
//  Runner
//
//  Created by Matthias Wallner-Géhri on 30.09.25.
//  Copyright © 2025 The Chromium Authors. All rights reserved.
//


import SwiftUI

struct SwiftUIDashboardSettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List {
                Section("Refresh") {
                    HStack {
                        Text("Refresh Interval")
                        Spacer()
                        Picker("", selection: Binding(
                            get: { viewModel.appSettings.dashboardRefreshInterval },
                            set: { newValue in
                                viewModel.appSettings.dashboardRefreshInterval = newValue
                                Task { await viewModel.saveSettings() }
                            }
                        )) {
                            Text("1 minute").tag(60)
                            Text("5 minutes").tag(300)
                            Text("10 minutes").tag(600)
                            Text("15 minutes").tag(900)
                            Text("30 minutes").tag(1800)
                        }
                        .pickerStyle(.menu)
                    }
                }
                
                Section("Calendar") {
                    Toggle("Enable Calendar View", isOn: Binding(
                        get: { viewModel.appSettings.enableCalendarView },
                        set: { newValue in
                            viewModel.appSettings.enableCalendarView = newValue
                            Task { await viewModel.saveSettings() }
                        }
                    ))
                    
                    if viewModel.appSettings.enableCalendarView {
                        HStack {
                            Text("Days Ahead")
                            Spacer()
                            Picker("", selection: Binding(
                                get: { viewModel.appSettings.calendarDaysAhead },
                                set: { newValue in
                                    viewModel.appSettings.calendarDaysAhead = newValue
                                    Task { await viewModel.saveSettings() }
                                }
                            )) {
                                Text("7 days").tag(7)
                                Text("14 days").tag(14)
                                Text("30 days").tag(30)
                                Text("60 days").tag(60)
                            }
                            .pickerStyle(.menu)
                        }
                        
                        Picker("Starting Day", selection: Binding(
                            get: { viewModel.appSettings.calendarStartingDay },
                            set: { newValue in
                                viewModel.appSettings.calendarStartingDay = newValue
                                Task { await viewModel.saveSettings() }
                            }
                        )) {
                            ForEach(CalendarStartDay.allCases, id: \.self) { day in
                                Text(day.displayName).tag(day)
                            }
                        }
                        .pickerStyle(.menu)
                        
                        Picker("Starting View", selection: Binding(
                            get: { viewModel.appSettings.calendarStartingType },
                            set: { newValue in
                                viewModel.appSettings.calendarStartingType = newValue
                                Task { await viewModel.saveSettings() }
                            }
                        )) {
                            ForEach(CalendarStartType.allCases, id: \.self) { type in
                                Text(type.displayName).tag(type)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .navigationTitle("Dashboard Settings")
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