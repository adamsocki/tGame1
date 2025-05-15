//
//  GameStateManager.swift
//  tGame1
//
//  Created by Adam Socki on 5/3/25.
//

import Foundation
import SwiftData
import SwiftUI
import Combine


enum GameStateType: String, Codable {
    case init_game_state
}

struct GameStateData: Codable, Identifiable {
    var id: String?
    let description: String?
    let type: GameStateType
    
}

class GameStateManager: ObservableObject {
    @Environment(\.modelContext) private var modelContext
    @Query private var persons: [PersonData]
    
    @Published var gameStateData: GameStateData?
    
    var activeTypes = ActiveUnitTypes()
    
    init(gameStateData: GameStateData? = nil) {
        InitGame()
    }
    
    
    
    func InitGame()
    {
        self.gameStateData = gameStateData
        
        // CURRENT ICON STATE
        activeTypes.activate(unitType: .person)
        for type in activeTypes.activeUnitTypes {
            print("\(type)")
        }
//        persons.`
        
        
        
//        persons.
//        // SET INIT PLAYER STATE
//        if (persons.first != nil)
//        {
//            persons.first!.energy = 50
//        }
        
    }
}
