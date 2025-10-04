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