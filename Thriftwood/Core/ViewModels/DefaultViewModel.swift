//
//  DefaultViewModel.swift
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
//
//  DefaultViewModel.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 04.10.25.
//

import Foundation
import SwiftUI

/// Base implementation of a ViewModel with common state management
@MainActor
@Observable
class DefaultViewModel: BaseViewModel {
    var isLoading: Bool = false
    var error: ThriftwoodError?
    
    var hasData: Bool {
        // Override in subclasses
        false
    }
    
    func load() async {
        // Override in subclasses
        AppLogger.general.warning("load() not implemented in \(String(describing: type(of: self)))")
    }
    
    func reload() async {
        await load()
    }
}
