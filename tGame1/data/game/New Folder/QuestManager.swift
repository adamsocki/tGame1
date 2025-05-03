//
//  QuestManager.swift
//  tGame1
//
//  Created by Adam Socki on 4/25/25.
//

import Foundation

enum TaskType: String, Codable, CaseIterable {
    case talk       // Talk to an NPC
    case collect    // Collect N items
    case defeat     // Defeat N enemies
    case reach      // Reach a specific location
    case interact   // Interact with an object
    // Add other task types as needed
}


struct TaskData: Codable, Identifiable { // Identifiable can be useful
    let id: Int              // Unique ID for the task within the quest (e.g., 0, 1, 2...)
    let type: String         // The task type as a string (maps to TaskType enum)
    let description: String  // Text describing the task objective
    let target: String?      // Optional: NPC name, item ID, location name, etc.
    let quantity: Int?       // Optional: Number of items, enemies, etc. (defaults to 1 if nil)

    // Add other relevant data fields that might come from JSON
    // E.g., prerequisiteTaskId: Int?
}


// QuestData is created and stocked by the JSON loading process
struct QuestData: Decodable, Identifiable {
    let id: String          // Unique ID matching QuestType rawValue (e.g., "introQuest")
    let name: String        // Display name of the quest (e.g., "A Humble Beginning")
    let description: String // Overall quest description
    let tasks: [TaskData]   // An array of the tasks involved in this quest
    let prerequisites: [String]? // Optional: IDs of quests to complete first
    // Add other fields as needed: rewards, starting NPC, etc.
}

class QuestManager: ObservableObject {
    //    @Published var questNodes: [QuestNode] = []
    private var questDefinitions: [String: QuestData] = [:]
    
    @Published var activeQuests: [QuestType: Quest] = [:]
    @Published var completedQuests: Set<QuestType> = []
    
    
    init(filename: String = "quests.json") {
        loadQuestDefinitions(from: filename)
        //
        
        
    }
    
    
    //
    
    
    
    private func loadQuestDefinitions(from filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("Error: Could not find quest file: \(filename)")
            return // Or fatalError depending on requirements
        }
        
        guard let data = try? Data(contentsOf: url) else {
            print("Error: Could not load data from quest file: \(url)")
            return
        }
        
        let decoder = JSONDecoder()
        do {
            let loadedQuestData = try decoder.decode([QuestData].self, from: data)
            // Populate the dictionary for quick lookup
            for questData in loadedQuestData {
                questDefinitions[questData.id] = questData
            }
            print("Successfully loaded \(questDefinitions.count) quest definitions.")
        } catch {
            print("Error: Could not decode quest data from \(filename): \(error)")
            
        }
    }
    
    func getQuestDefinition(for type: QuestType) -> QuestData? {
        return questDefinitions[type.rawValue]
    }
    
    func checkQuestPrequisites(prerequisites: [String]?) -> Bool {
        
        if prerequisites == nil || prerequisites!.isEmpty{
            return true
        }
        for preq in prerequisites!{
            if !completedQuests.contains(QuestType(rawValue: preq)!){
                return false
            }
        }
        return true
    }
    
    
    func offerQuest(_ type: QuestType) {
        guard activeQuests[type] == nil && !completedQuests.contains(type) else {
            print("quest \(type.rawValue) is already active or completed")
            return
        }
        
        guard let questDefinition = getQuestDefinition(for: type) else {
            print("No quest definition found for \(type.rawValue)")
            return
        }
        
        // Check for Quest Prerequisites
        let prerequisitesMet = checkQuestPrequisites(prerequisites: questDefinition.prerequisites)
        guard prerequisitesMet else {
            print("no can do, prerequisites not met for \(type.rawValue)")
            return
        }
        
        acceptQuest(type)
    }
    
    func acceptQuest(_ type: QuestType) {
        print("quest accepted \(type.rawValue)")
        
        guard let newQuest = createInGameQuest(for: type) else {
            print("No accept Quest for \(type.rawValue)")
            return
        }
        
        activeQuests[type] = newQuest
        
    }
    
    
    
    func createInGameQuest(for type: QuestType) -> Quest? {
        
        guard let definition = getQuestDefinition(for: type) else {
            print( "No quest definition found for \(type.rawValue)")
            return nil
        }
        
        let newQuest = Quest(data: definition)
        return newQuest
    }
    
    
}
