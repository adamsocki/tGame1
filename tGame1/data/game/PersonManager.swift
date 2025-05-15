//
//  PersonManager.swift
//  tGame1
//
//  Created by Adam Socki on 5/7/25.
//

import Foundation
import SwiftData
import SwiftUI



class PersonManager: ObservableObject
{
//    @Environment(\.modelContext) private var modelContext
    private var modelContext: ModelContext
//    private var timeManager: TimeManager
    weak var gameManager: GameManager?
//    @Query private var gameData: [GameData]
    
//    private var gameManager: GameManager
    
//    var persons: [PersonData]
    
    init(mc: ModelContext, gameManager: GameManager? = nil) {
//        print("Name : \(gameData.first!.persons.first(where: { $0.name == "name1" }))")
//        self.modelContext = mc
        self.modelContext = mc
        self.gameManager = gameManager
    }
    
    func setGameManager(_ gameManager: GameManager) {
            self.gameManager = gameManager
    }
    
    func InitGameData()
    {
//        print(gameData.first!.persons)
    }
    
    func UpdatePersonManager()
    {
        guard let gameDataInstance = getGameSessionData() else {
            print("No GameData found.")
            return
        }
        print(gameDataInstance)
        for person in gameDataInstance.persons {
            person.UpdateEnergy(-1 * Float((gameManager?.timeManager.deltaTime)!))
        }
    }
    
    func getGameSessionData() -> GameData? {
        let descriptor = FetchDescriptor<GameData>() // Fetches all GameData instances
        do {
            let gameDataInstances = try modelContext.fetch(descriptor)
            // Assuming you only ever have one GameData for the current game.
            // If you might have more, you'll need a way to identify the correct one.
            return gameDataInstances.first
        } catch {
            print("Error fetching GameData: \(error)")
            return nil
        }
    }
    
//    func findPerson(named nameToFind: String) -> PersonData? {
//        let predicate = #Predicate<PersonData> { person in
////            gameDatas.first?.persons..name == nameToFind
////            self.persons. == person.name.hashValue
//
//        }
//        
//        let descriptor = FetchDescriptor<PersonData>(predicate: predicate)
//        do {
//            let result = try modelContext.fetch(descriptor)
//            return result.first
//        } catch {
//            print("Failed to fetch person named \(nameToFind): \(error)")
//            return nil
//        }
//    }

}
