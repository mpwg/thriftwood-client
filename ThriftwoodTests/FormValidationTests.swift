//
//  FormValidationTests.swift
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
@testable import Thriftwood

/// Tests for form validation helpers
@Suite("Form Validation")
@MainActor
struct FormValidationTests {
    
    // MARK: - URL Validation Tests
    
    @Test("Valid URLs are recognized")
    func validURLs() {
        #expect(FormValidation.isValidURL("https://example.com"))
        #expect(FormValidation.isValidURL("http://localhost"))
        #expect(FormValidation.isValidURL("https://radarr.example.com:7878"))
        #expect(FormValidation.isValidURL("http://192.168.1.1"))
    }
    
    @Test("Invalid URLs are rejected")
    func invalidURLs() {
        #expect(!FormValidation.isValidURL(""))
        #expect(!FormValidation.isValidURL("not a url"))
        #expect(!FormValidation.isValidURL("example.com")) // No scheme
        #expect(!FormValidation.isValidURL("://example.com")) // Invalid scheme
    }
    
    @Test("Valid HTTP/HTTPS URLs are recognized")
    func validHTTPURLs() {
        #expect(FormValidation.isValidHTTPURL("https://example.com"))
        #expect(FormValidation.isValidHTTPURL("http://localhost"))
        #expect(FormValidation.isValidHTTPURL("https://radarr.example.com:7878/api"))
    }
    
    @Test("Non-HTTP URLs are rejected")
    func nonHTTPURLs() {
        #expect(!FormValidation.isValidHTTPURL("ftp://example.com"))
        #expect(!FormValidation.isValidHTTPURL("ws://example.com"))
        #expect(!FormValidation.isValidHTTPURL("file:///path/to/file"))
    }
    
    // MARK: - Port Validation Tests
    
    @Test("Valid ports are recognized")
    func validPorts() {
        #expect(FormValidation.isValidPort("1"))
        #expect(FormValidation.isValidPort("80"))
        #expect(FormValidation.isValidPort("443"))
        #expect(FormValidation.isValidPort("7878"))
        #expect(FormValidation.isValidPort("65535"))
    }
    
    @Test("Invalid ports are rejected")
    func invalidPorts() {
        #expect(!FormValidation.isValidPort("0"))
        #expect(!FormValidation.isValidPort("65536"))
        #expect(!FormValidation.isValidPort("-1"))
        #expect(!FormValidation.isValidPort("abc"))
        #expect(!FormValidation.isValidPort(""))
        #expect(!FormValidation.isValidPort("12.5"))
    }
    
    // MARK: - API Key Validation Tests
    
    @Test("Valid API keys are recognized")
    func validAPIKeys() {
        #expect(FormValidation.isValidAPIKey("a1b2c3d4e5f6"))
        #expect(FormValidation.isValidAPIKey("verylongapikey123456"))
        #expect(FormValidation.isValidAPIKey("x"))
    }
    
    @Test("Invalid API keys are rejected")
    func invalidAPIKeys() {
        #expect(!FormValidation.isValidAPIKey(""))
        #expect(!FormValidation.isValidAPIKey("   "))
        #expect(!FormValidation.isValidAPIKey("\n\t"))
    }
    
    @Test("API key minimum length validation")
    func apiKeyMinLength() {
        #expect(FormValidation.isValidAPIKey("12345678", minLength: 8))
        #expect(FormValidation.isValidAPIKey("123456789", minLength: 8))
        #expect(!FormValidation.isValidAPIKey("1234567", minLength: 8))
        #expect(!FormValidation.isValidAPIKey("", minLength: 8))
    }
    
    // MARK: - MAC Address Validation Tests
    
    @Test("Valid MAC addresses are recognized")
    func validMACAddresses() {
        #expect(FormValidation.isValidMACAddress("AA:BB:CC:DD:EE:FF"))
        #expect(FormValidation.isValidMACAddress("00:11:22:33:44:55"))
        #expect(FormValidation.isValidMACAddress("aa:bb:cc:dd:ee:ff"))
        #expect(FormValidation.isValidMACAddress("AA-BB-CC-DD-EE-FF"))
        #expect(FormValidation.isValidMACAddress("00-11-22-33-44-55"))
    }
    
    @Test("Invalid MAC addresses are rejected")
    func invalidMACAddresses() {
        #expect(!FormValidation.isValidMACAddress(""))
        #expect(!FormValidation.isValidMACAddress("AA:BB:CC:DD:EE"))
        #expect(!FormValidation.isValidMACAddress("AA:BB:CC:DD:EE:FF:GG"))
        #expect(!FormValidation.isValidMACAddress("AABBCCDDEEFF"))
        #expect(!FormValidation.isValidMACAddress("AA:BB:CC:DD:EE:ZZ"))
        #expect(!FormValidation.isValidMACAddress("not a mac address"))
    }
    
    // MARK: - Username Validation Tests
    
    @Test("Valid usernames are recognized")
    func validUsernames() {
        #expect(FormValidation.isValidUsername("admin"))
        #expect(FormValidation.isValidUsername("user123"))
        #expect(FormValidation.isValidUsername("test_user"))
    }
    
    @Test("Invalid usernames are rejected")
    func invalidUsernames() {
        #expect(!FormValidation.isValidUsername(""))
        #expect(!FormValidation.isValidUsername("   "))
        #expect(!FormValidation.isValidUsername("\n\t"))
    }
    
    // MARK: - Password Validation Tests
    
    @Test("Valid passwords are recognized")
    func validPasswords() {
        #expect(FormValidation.isValidPassword("password"))
        #expect(FormValidation.isValidPassword("p"))
        #expect(FormValidation.isValidPassword("VerySecurePassword123!"))
    }
    
    @Test("Password minimum length validation")
    func passwordMinLength() {
        #expect(FormValidation.isValidPassword("12345678", minLength: 8))
        #expect(FormValidation.isValidPassword("123456789", minLength: 8))
        #expect(!FormValidation.isValidPassword("1234567", minLength: 8))
        #expect(!FormValidation.isValidPassword("", minLength: 1))
    }
    
    // MARK: - Generic Validation Tests
    
    @Test("Empty string detection")
    func emptyStringDetection() {
        #expect(FormValidation.isNotEmpty("text"))
        #expect(FormValidation.isNotEmpty("x"))
        #expect(!FormValidation.isNotEmpty(""))
        #expect(!FormValidation.isNotEmpty("   "))
        #expect(!FormValidation.isNotEmpty("\n\t"))
    }
    
    @Test("Length range validation")
    func lengthRangeValidation() {
        #expect(FormValidation.isWithinLength("hello", min: 3, max: 10))
        #expect(FormValidation.isWithinLength("hi", min: 2, max: 2))
        #expect(!FormValidation.isWithinLength("hello", min: 6, max: 10))
        #expect(!FormValidation.isWithinLength("hello", min: 1, max: 4))
    }
    
    // MARK: - String Extension Tests
    
    @Test("String extension - isValidURL")
    func stringExtensionURL() {
        #expect("https://example.com".isValidURL)
        #expect(!"not a url".isValidURL)
    }
    
    @Test("String extension - isValidHTTPURL")
    func stringExtensionHTTPURL() {
        #expect("https://example.com".isValidHTTPURL)
        #expect("http://localhost".isValidHTTPURL)
        #expect(!"ftp://example.com".isValidHTTPURL)
    }
    
    @Test("String extension - isValidPort")
    func stringExtensionPort() {
        #expect("7878".isValidPort)
        #expect("443".isValidPort)
        #expect(!"abc".isValidPort)
        #expect(!"65536".isValidPort)
    }
    
    @Test("String extension - isValidAPIKey")
    func stringExtensionAPIKey() {
        #expect("a1b2c3d4e5f6".isValidAPIKey)
        #expect(!"".isValidAPIKey)
        #expect(!"   ".isValidAPIKey)
    }
    
    @Test("String extension - isValidMACAddress")
    func stringExtensionMACAddress() {
        #expect("AA:BB:CC:DD:EE:FF".isValidMACAddress)
        #expect("00-11-22-33-44-55".isValidMACAddress)
        #expect(!"not a mac".isValidMACAddress)
    }
    
    @Test("String extension - isValidUsername")
    func stringExtensionUsername() {
        #expect("admin".isValidUsername)
        #expect(!"".isValidUsername)
        #expect(!"   ".isValidUsername)
    }
}
