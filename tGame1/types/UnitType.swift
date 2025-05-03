//
//  IconType.swift
//  tGame1
//
//  Created by Adam Socki on 4/19/25.
//


import SwiftUI
import SwiftData

// Define the Enum (enhanced with Identifiable and systemImageName)
enum UnitType: String, CaseIterable, Identifiable {
    case person
    case house
    case map
    case car
    case cat
    case folder
    
    var id: Self { self } // Conformance to Identifiable
    
    var systemImageName: String {
        switch self {
        case .person: return "person.2.crop.square.stack"
        case .house: return "house"
        case .map: return "map.fill" // Use the correct SF Symbol name
        case .car: return "car"
        case .cat: return "cat"
        case .folder: return "folder"
        }
    }
}
