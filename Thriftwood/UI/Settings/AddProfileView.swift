//
//  AddProfileView.swift
//  Thriftwood
//
//  Thriftwood - Frontend for Media Management
//  Copyright (C) 2025 Matthias Wallner Géhri
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//

import SwiftUI
import SwiftData

/// View for adding or editing a profile
@MainActor
struct AddProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: AddProfileViewModel
    
    init(profile: Profile? = nil) {
        // Initialize ViewModel from DI container
        let profileService = DIContainer.shared.resolve((any ProfileServiceProtocol).self)
        self.viewModel = AddProfileViewModel(
            profileService: profileService,
            existingProfile: profile
        )
    }
    
    var body: some View {
        Form {
            Section {
                TextFieldRow(
                    title: "Profile Name",
                    placeholder: "e.g., Home, Work, Personal",
                    subtitle: "A unique name for this profile",
                    icon: "person.text.rectangle",
                    text: $viewModel.profileName
                )
                .autocorrectionDisabled()
            } header: {
                Text("Profile Information")
            } footer: {
                if let validationError = viewModel.validationError {
                    Text(validationError)
                        .foregroundStyle(.red)
                        .font(.caption)
                }
            }
            
            Section {
                Toggle(isOn: $viewModel.switchAfterCreation) {
                    VStack(alignment: .leading, spacing: Spacing.xxs) {
                        Text("Switch to Profile")
                        Text("Make this profile active after creation")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            } header: {
                Text("Options")
            }
        }
        .navigationTitle(viewModel.isEditing ? "Edit Profile" : "New Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button(viewModel.isEditing ? "Save" : "Create") {
                    Task {
                        await saveProfile()
                    }
                }
                .disabled(!viewModel.isValid || viewModel.isSaving)
            }
        }
        .alert("Error", isPresented: .constant(viewModel.error != nil), presenting: viewModel.error) { _ in
            Button("OK") {
                viewModel.error = nil
            }
        } message: { error in
            Text(error.localizedDescription)
        }
    }
    
    private func saveProfile() async {
        let success = await viewModel.saveProfile()
        if success {
            dismiss()
        }
    }
}

// MARK: - Preview

#if false  // Disabled: ADR-0012 refactoring in progress
#Preview("Add Profile") {
    let coordinator = SettingsCoordinator()
    return NavigationStack {
        AddProfileView(coordinator: coordinator)
    }
}

#Preview("Edit Profile") {
    let coordinator = SettingsCoordinator()
    let profile = Profile(name: "Test Profile")
    return NavigationStack {
        AddProfileView(coordinator: coordinator, profile: profile)
    }
}
#endif
