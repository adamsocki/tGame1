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
    var persons: [PersonData]
    
    init(score: Int) {
        self.score = score
        self.persons = []
//        self.persons.append(PersonData(age: 37, name: "Adam Socki"))

    }
}
