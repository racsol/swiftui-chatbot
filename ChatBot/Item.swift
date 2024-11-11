//
//  Item.swift
//  ChatBot
//
//  Created by Carlos Silva on 11/11/2024.
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
