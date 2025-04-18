//
//  Item.swift
//  tGame1
//
//  Created by Adam Socki on 4/17/25.
//

import Foundation
import SwiftData

@Model
final class GameData {
    var score: Int
    
    init(score: Int) {
        self.score = score
    }
}
