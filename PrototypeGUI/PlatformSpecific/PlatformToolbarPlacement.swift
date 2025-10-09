//
//  PlatformToolbarPlacement.swift
//  PrototypeGUI
//
//  Created by automated edit on 08.10.25.
//

import SwiftUI

extension ToolbarItemPlacement {
    /// Platform-aware placement for bottom toolbars: `.bottomBar` on iOS, `.automatic` on macOS.
    static var platformBottom: ToolbarItemPlacement {
        #if os(iOS)
        return .bottomBar
        #else
        return .automatic
        #endif
    }
}
