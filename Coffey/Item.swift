//
//  Item.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 16/10/25.
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
