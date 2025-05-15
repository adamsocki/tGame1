//
//  IconType.swift
//  tGame1
//
//  Created by Adam Socki on 4/19/25.
//


import SwiftUI
import SwiftData


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
        case .map: return "map.fill" 
        case .car: return "car"
        case .cat: return "cat"
        case .folder: return "folder"
        }
    }
}

//struct UnitEnablementFlags {
//    var person: Bool = false
//    var house: Bool = false
//    var map: Bool = false
//    var car: Bool = false
//    var cat: Bool = false
//    var folder: Bool = false
//    
//    init()
//}

class ActiveUnitTypes: ObservableObject {
    @Published var activeUnitTypes: Set<UnitType> = []
    
    
    func activate(unitType: UnitType) {
            activeUnitTypes.insert(unitType)
    }
    func deactivate(unitType: UnitType) {
            activeUnitTypes.remove(unitType)
    }
    
    func toggleActiveState(for unitType: UnitType) {
        if activeUnitTypes.contains(unitType) {
            deactivate(unitType: unitType)
        } else {
            activate(unitType: unitType)
        }
    }
    
    func activateAll() {
        activeUnitTypes = Set(UnitType.allCases)
    }

    func isActive(unitType: UnitType) -> Bool {
            return activeUnitTypes.contains(unitType)
    }
    func deactivateAll() {
            activeUnitTypes.removeAll()
    }
    
//    func activateInitialSet(types: [UnitType]) {
//        types.forEach { activeUnitTypes.insert($0) }
//    }
    
}
