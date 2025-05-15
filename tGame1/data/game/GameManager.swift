//
//  GameManager.swift
//  tGame1
//
//  Created by Adam Socki on 4/24/25.
//



import SwiftUI
import SwiftData





class GameManager: ObservableObject {
    private let modelContext: ModelContext
    
    @Published var dialogManager: DialogManager
    @Published var uiManager: UIManager
    @Published var sequenceManager: SequenceManager
    
    @Published var questManager: QuestManager
    @Published var sceneManager: SceneManager
    
    @Published var gameStateManager: GameStateManager
    @Published var personManager: PersonManager
    
    @Published var timeManager: TimeManager
    
    

    
    
    init (modelContext: ModelContext) {
        
        self.modelContext = modelContext
        
        
        let uiMngr = UIManager()
        let qstMngr = QuestManager()
        let prsnMngr = PersonManager(mc: modelContext)
        let tmMngr = TimeManager(personManager: prsnMngr)
        
        let dlgMngr = DialogManager(presenter: uiMngr)
        let scnMngr = SceneManager(uiManager:uiMngr, dialogManager: dlgMngr)
       
        let sqncMngr = SequenceManager(sceneManager: scnMngr,  questManager: qstMngr)
        
        let gmStMngr = GameStateManager()
        
        
        self.personManager = prsnMngr
        self.uiManager = uiMngr
        self.questManager = qstMngr
        self.sequenceManager = sqncMngr
        self.dialogManager = dlgMngr
        self.sceneManager = scnMngr
        self.gameStateManager = gmStMngr
        self.timeManager = tmMngr
        
        
        
        prsnMngr.setGameManager(self)
//        addNewPersonToGame(name: "Adam", age: 33)
        
        
        
        self.sequenceManager.startSequence(id: "intro_sequence")
        
        
        
        

    }
    
    func addNewPersonToGame(name: String, age: Int, position: Vector3 = Vector3()) {
        guard let gameData = getGameSessionData() else {
            print("GameStateManager: GameData not found, cannot add person.")
            return
        }
        
        let newPerson = PersonData(age: age, name: name, position: position)
        
        // Important: Because 'newPerson' will be part of a relationship with 'gameData'
        // (which is already managed), you don't strictly need to insert 'newPerson' separately
        // if the relationship handles cascades. However, it's often clearer or safer to insert it.
        // modelContext.insert(newPerson) // This is good practice
        
        gameData.persons.append(newPerson)
        print("Added new person '\(name)' to GameData. Total persons: \(gameData.persons.count)")
        
        // If newPerson wasn't explicitly inserted, appending it to a managed object's
        // relationship array and then saving the context would usually persist it.
        // By inserting newPerson, you ensure it's tracked immediately.
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
}
