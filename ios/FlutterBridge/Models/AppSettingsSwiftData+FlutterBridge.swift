//
//  AppSettingsSwiftData+FlutterBridge.swift
//  Runner
//
//  Created by GitHub Copilot on 2025-10-02.
//  MIGRATION TEMPORARY: Flutter bridge support for AppSettingsSwiftData
//  This file will be DELETED when migration to pure SwiftUI is complete
//

import Foundation

/// ⚠️ MIGRATION TEMPORARY: Flutter Bridge Support for AppSettingsSwiftData
/// This entire extension will be deleted when migration to pure SwiftUI is complete

extension AppSettingsSwiftData {
    /// Convert SwiftData app settings to dictionary for Flutter bridge
    /// ⚠️ MIGRATION TEMPORARY: Remove when Flutter bridge is no longer needed
    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "enabledProfile": enabledProfile,
            
            // Theme - include selectedTheme field that ThriftwoodAppSettings expects
            "_selectedTheme": themeAmoled ? "dark" : "system",
            "themeAmoled": themeAmoled,
            "themeAmoledBorder": themeAmoledBorder,
            "themeImageBackgroundOpacity": themeImageBackgroundOpacity,
            
            // Drawer
            "drawerAutomaticManage": drawerAutomaticManage,
            "drawerManualOrder": decodeDrawerOrder(drawerManualOrderData) ?? [],
            
            // Networking
            "networkingTLSValidation": networkingTLSValidation,
            
            // Quick Actions
            "quickActionsLidarr": quickActionsLidarr,
            "quickActionsRadarr": quickActionsRadarr,
            "quickActionsSonarr": quickActionsSonarr,
            "quickActionsNZBGet": quickActionsNZBGet,
            "quickActionsSABnzbd": quickActionsSABnzbd,
            "quickActionsOverseerr": quickActionsOverseerr,
            "quickActionsTautulli": quickActionsTautulli,
            "quickActionsSearch": quickActionsSearch,
            
            // Other settings
            "use24HourTime": use24HourTime,
            "enableInAppNotifications": enableInAppNotifications,
            "changelogLastBuildVersion": changelogLastBuildVersion,
            "hybridSettingsUseSwiftUI": hybridSettingsUseSwiftUI
        ]
    }
    
    /// Create SwiftData app settings from Flutter dictionary
    /// ⚠️ MIGRATION TEMPORARY: Remove when Flutter bridge is no longer needed
    static func fromDictionary(_ dict: [String: Any]) throws -> AppSettingsSwiftData {
        let settings = AppSettingsSwiftData()
        
        // Set ID if provided
        if let idString = dict["id"] as? String, let id = UUID(uuidString: idString) {
            settings.id = id
        }
        
        // Profile
        settings.enabledProfile = dict["enabledProfile"] as? String ?? "default"
        
        // Theme - handle both direct fields and _selectedTheme mapping
        settings.themeAmoled = dict["themeAmoled"] as? Bool ?? false
        settings.themeAmoledBorder = dict["themeAmoledBorder"] as? Bool ?? false  
        settings.themeImageBackgroundOpacity = dict["themeImageBackgroundOpacity"] as? Int ?? 20
        
        // Handle _selectedTheme from ThriftwoodAppSettings Codable
        if let themeString = dict["_selectedTheme"] as? String {
            settings.themeAmoled = (themeString == "dark")
        }
        
        // Drawer
        settings.drawerAutomaticManage = dict["drawerAutomaticManage"] as? Bool ?? true
        if let drawerOrder = dict["drawerManualOrder"] as? [String] {
            settings.drawerManualOrderData = settings.encodeDrawerOrder(drawerOrder)
        }
        
        // Networking
        settings.networkingTLSValidation = dict["networkingTLSValidation"] as? Bool ?? false
        
        // Quick Actions
        settings.quickActionsLidarr = dict["quickActionsLidarr"] as? Bool ?? false
        settings.quickActionsRadarr = dict["quickActionsRadarr"] as? Bool ?? false
        settings.quickActionsSonarr = dict["quickActionsSonarr"] as? Bool ?? false
        settings.quickActionsNZBGet = dict["quickActionsNZBGet"] as? Bool ?? false
        settings.quickActionsSABnzbd = dict["quickActionsSABnzbd"] as? Bool ?? false
        settings.quickActionsOverseerr = dict["quickActionsOverseerr"] as? Bool ?? false
        settings.quickActionsTautulli = dict["quickActionsTautulli"] as? Bool ?? false
        settings.quickActionsSearch = dict["quickActionsSearch"] as? Bool ?? false
        
        // Other settings
        settings.use24HourTime = dict["use24HourTime"] as? Bool ?? false
        settings.enableInAppNotifications = dict["enableInAppNotifications"] as? Bool ?? true
        settings.changelogLastBuildVersion = dict["changelogLastBuildVersion"] as? Int ?? 0
        settings.hybridSettingsUseSwiftUI = dict["hybridSettingsUseSwiftUI"] as? Bool ?? false
        
        return settings
    }
    
    /// Update app settings from Flutter dictionary
    /// ⚠️ MIGRATION TEMPORARY: Remove when Flutter bridge is no longer needed
    func updateFromDictionary(_ dict: [String: Any]) throws {
        // Profile
        if let profile = dict["enabledProfile"] as? String {
            enabledProfile = profile
        }
        
        // Theme
        if let amoled = dict["themeAmoled"] as? Bool { themeAmoled = amoled }
        if let border = dict["themeAmoledBorder"] as? Bool { themeAmoledBorder = border }
        if let opacity = dict["themeImageBackgroundOpacity"] as? Int { themeImageBackgroundOpacity = opacity }
        
        // Handle _selectedTheme from ThriftwoodAppSettings Codable
        if let themeString = dict["_selectedTheme"] as? String {
            themeAmoled = (themeString == "dark")
        }
        
        // Drawer
        if let manage = dict["drawerAutomaticManage"] as? Bool { drawerAutomaticManage = manage }
        if let order = dict["drawerManualOrder"] as? [String] {
            drawerManualOrderData = encodeDrawerOrder(order)
        }
        
        // Networking
        if let validation = dict["networkingTLSValidation"] as? Bool { networkingTLSValidation = validation }
        
        // Quick Actions
        if let qa = dict["quickActionsLidarr"] as? Bool { quickActionsLidarr = qa }
        if let qa = dict["quickActionsRadarr"] as? Bool { quickActionsRadarr = qa }
        if let qa = dict["quickActionsSonarr"] as? Bool { quickActionsSonarr = qa }
        if let qa = dict["quickActionsNZBGet"] as? Bool { quickActionsNZBGet = qa }
        if let qa = dict["quickActionsSABnzbd"] as? Bool { quickActionsSABnzbd = qa }
        if let qa = dict["quickActionsOverseerr"] as? Bool { quickActionsOverseerr = qa }
        if let qa = dict["quickActionsTautulli"] as? Bool { quickActionsTautulli = qa }
        if let qa = dict["quickActionsSearch"] as? Bool { quickActionsSearch = qa }
        
        // Other settings
        if let time = dict["use24HourTime"] as? Bool { use24HourTime = time }
        if let notifications = dict["enableInAppNotifications"] as? Bool { enableInAppNotifications = notifications }
        if let version = dict["changelogLastBuildVersion"] as? Int { changelogLastBuildVersion = version }
        if let hybrid = dict["hybridSettingsUseSwiftUI"] as? Bool { hybridSettingsUseSwiftUI = hybrid }
    }
}