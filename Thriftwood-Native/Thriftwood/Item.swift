//
//  Item.swift
//  Thriftwood
//
//  Created by Matthias Wallner-Géhri on 29.09.25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
