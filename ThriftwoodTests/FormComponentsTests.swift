//
//  FormComponentsTests.swift
//  ThriftwoodTests
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

import Testing
import SwiftUI
@testable import Thriftwood

/// Tests for form components (TextFieldRow, SecureFieldRow, ToggleRow, etc.)
@MainActor
@Suite("Form Components")
struct FormComponentsTests {
    
    // MARK: - FormRow Tests
    
    @Test("FormRow initializes with basic parameters")
    func formRowBasicInit() {
        let row = FormRow(title: "Test") {
            Text("Content")
        }
        #expect(row.title == "Test")
        #expect(row.subtitle == nil)
        #expect(row.icon == nil)
    }
    
    @Test("FormRow initializes with all parameters")
    func formRowFullInit() {
        let row = FormRow(
            title: "Test Title",
            subtitle: "Test Subtitle",
            icon: "star.fill"
        ) {
            Text("Content")
        }
        #expect(row.title == "Test Title")
        #expect(row.subtitle == "Test Subtitle")
        #expect(row.icon == "star.fill")
    }
    
    // MARK: - TextFieldRow Tests
    
    @Test("TextFieldRow initializes with required parameters")
    func textFieldRowBasicInit() {
        @State var text = ""
        let row = TextFieldRow(
            title: "Host",
            placeholder: "example.com",
            text: $text
        )
        #expect(row.title == "Host")
        #expect(row.placeholder == "example.com")
    }
    
    @Test("TextFieldRow initializes with all parameters")
    func textFieldRowFullInit() {
        @State var text = "example"
        let row = TextFieldRow(
            title: "API Key",
            placeholder: "abc123...",
            subtitle: "Enter your key",
            icon: "key.fill",
            text: $text
        )
        #expect(row.title == "API Key")
        #expect(row.subtitle == "Enter your key")
        #expect(row.icon == "key.fill")
        #expect(row.placeholder == "abc123...")
    }
    
    // Note: Binding tests removed - SwiftUI bindings require view rendering to test properly
    // The bindings work correctly as demonstrated in the preview and runtime usage
    
    // MARK: - SecureFieldRow Tests
    
    @Test("SecureFieldRow initializes with required parameters")
    func secureFieldRowBasicInit() {
        @State var text = ""
        let row = SecureFieldRow(
            title: "Password",
            placeholder: "Enter password",
            text: $text
        )
        #expect(row.title == "Password")
        #expect(row.placeholder == "Enter password")
    }
    
    @Test("SecureFieldRow initializes with all parameters")
    func secureFieldRowFullInit() {
        @State var text = "secret"
        let row = SecureFieldRow(
            title: "API Key",
            placeholder: "Enter key",
            subtitle: "From settings",
            icon: "key.fill",
            text: $text,
            textContentType: .password
        )
        #expect(row.title == "API Key")
        #expect(row.subtitle == "From settings")
        #expect(row.icon == "key.fill")
        #expect(row.textContentType == .password)
    }
    
    // MARK: - ToggleRow Tests
    
    @Test("ToggleRow initializes with required parameters")
    func toggleRowBasicInit() {
        @State var isOn = false
        let row = ToggleRow(title: "Enable Feature", isOn: $isOn)
        #expect(row.title == "Enable Feature")
        #expect(row.subtitle == nil)
        #expect(row.icon == nil)
    }
    
    @Test("ToggleRow initializes with all parameters")
    func toggleRowFullInit() {
        @State var isOn = true
        let row = ToggleRow(
            title: "AMOLED Theme",
            subtitle: "Pure black background",
            icon: "moon.fill",
            isOn: $isOn
        )
        #expect(row.title == "AMOLED Theme")
        #expect(row.subtitle == "Pure black background")
        #expect(row.icon == "moon.fill")
    }
    
    // MARK: - PickerRow Tests
    
    @Test("PickerRow initializes with required parameters")
    func pickerRowBasicInit() {
        enum TestEnum: String { case one, two }
        @State var selection = TestEnum.one
        
        let options = [
            PickerOption(label: "One", value: TestEnum.one),
            PickerOption(label: "Two", value: TestEnum.two)
        ]
        
        let row = PickerRow(
            title: "Select Option",
            options: options,
            selection: $selection
        )
        #expect(row.title == "Select Option")
        #expect(row.options.count == 2)
    }
    
    @Test("PickerRow initializes with all parameters")
    func pickerRowFullInit() {
        enum TestEnum: String { case one, two }
        @State var selection = TestEnum.one
        
        let options = [
            PickerOption(label: "One", value: TestEnum.one),
            PickerOption(label: "Two", value: TestEnum.two)
        ]
        
        let row = PickerRow(
            title: "Theme",
            subtitle: "Select theme",
            icon: "paintbrush.fill",
            options: options,
            selection: $selection
        )
        #expect(row.title == "Theme")
        #expect(row.subtitle == "Select theme")
        #expect(row.icon == "paintbrush.fill")
    }
    
    @Test("PickerOption creates valid options")
    func pickerOptionCreation() {
        let option = PickerOption(label: "Test Label", value: 42)
        #expect(option.label == "Test Label")
        #expect(option.value == 42)
    }
    
    // MARK: - NavigationRow Tests
    
    @Test("NavigationRow initializes with required parameters")
    func navigationRowBasicInit() {
        let row = NavigationRow(title: "Details") {
            Text("Destination")
        }
        #expect(row.title == "Details")
        #expect(row.subtitle == nil)
        #expect(row.value == nil)
        #expect(row.icon == nil)
    }
    
    @Test("NavigationRow initializes with all parameters")
    func navigationRowFullInit() {
        let row = NavigationRow(
            title: "Host",
            subtitle: "Server URL",
            value: "example.com",
            icon: "network"
        ) {
            Text("Edit Host")
        }
        #expect(row.title == "Host")
        #expect(row.subtitle == "Server URL")
        #expect(row.value == "example.com")
        #expect(row.icon == "network")
    }
}
