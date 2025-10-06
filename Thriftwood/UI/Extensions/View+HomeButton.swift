//
//  View+HomeButton.swift
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

extension View {
    /// Adds a home button to the navigation bar trailing position
    /// that navigates back to the app root
    ///
    /// - Parameter action: The action to perform when the home button is tapped (typically `coordinator.popToRoot()`)
    /// - Returns: A view with a home button in the navigation bar
    func withHomeButton(action: @escaping () -> Void) -> some View {
        toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    action()
                } label: {
                    Image(systemName: "house")
                }
                .accessibilityLabel("Return to Home")
            }
        }
    }
}
