//
//  Item.swift
//  umbrellaIssue
//
//  Created by 차상진 on 1/28/25.
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
