//
//  Item.swift
//  tGame1
//
//  Created by Adam Socki on 4/17/25.
//

import Foundation
import SwiftData

enum ItemState: Int, Codable {
    case val0 = 0
    case val1 = 1
    case val2 = 2
    case val3 = 3
    case val4 = 4
}

enum ItemType: Int, Codable {
    case type0 = 0
    case type1 = 1
    case type2 = 2
    case type3 = 3
    case type4 = 4
    
}

enum ItemSidebarViewState:  Codable{
    case normal
    case editingName
}

@Model
final class Item {
    var timeCreated: CFTimeInterval
    var score: Int
    var state: ItemState = ItemState.val0
    var children: [Component]? = nil
    var type: ItemType = ItemType.type0
    var name: String
    var sidebarViewState: ItemSidebarViewState? = ItemSidebarViewState.normal
    
    init(score: Int, timeCreated: CFTimeInterval, name: String) {
        self.score = score
        self.timeCreated = timeCreated
        self.name = name
    }
    
    func setState(to newState: ItemState) {
        // Avoid triggering unnecessary updates if the state is already correct
        guard self.state != newState else { return }
        self.state = newState
        print("Item state set to: \(self.state)")
    }
    
    func addScore(_ points: Int) {
        
        self.score += points
        updateStateBasedOnScore()
    }
    
    func updateStateBasedOnScore() {
        var newState = ItemState.val0 // Default
        switch self.score {
        case ..<0: // Handle negative scores?
            newState = .val0 // Or some error state
        case 0..<10:
            newState = .val0
        case 10..<20:
            newState = .val1
        case 20..<30:
            newState = .val2
            // ... add more ranges as needed
        default: // Score >= 150
            newState = .val3 // Or highest relevant state
        }
        setState(to: newState)
    }
}
