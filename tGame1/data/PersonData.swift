//
//  Person.swift
//  tGame1
//
//  Created by Adam Socki on 4/23/25.
//

import Foundation
import SwiftData

struct Vector3: Codable, Equatable {
    var x: Float
    var y: Float
    var z: Float

    // You might have other initializers or methods here
    init(x: Float = 0.0, y: Float = 0.0, z: Float = 0.0) {
        self.x = x
        self.y = y
        self.z = z
    }
}

struct PersonChartData: Identifiable {
    let id = UUID() // Or any other unique identifier
    var category: String
    var value: Float
}


@Model
final class PersonData: Identifiable {
    var age: Int
    var name: String
    var energy: Float?
    var position : Vector3?
    var hunger: Float?
    
    var canRest: Bool? = false
    
    var energyDepletionRate: Float = 0.1
    
    
    
    init (age: Int, name: String, position: Vector3 = Vector3()) {
        self.age = age
        self.name = name;
        self.energy = 40
        self.position = position
        self.hunger = 10
    }
    
    func UpdateEnergy(_ amount: Float) {
        self.energy! += amount * energyDepletionRate
    }
    
    func EnergyBump(val: Float)
    {
        self.energy! += val
    }
}
