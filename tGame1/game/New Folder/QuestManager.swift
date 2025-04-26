//
//  QuestManager.swift
//  tGame1
//
//  Created by Adam Socki on 4/25/25.
//

import Foundation



struct TaskData: Decodable, Identifiable {
    // You might want an ID from JSON if tasks need unique reference beyond order
    // let taskId: String
    let id = UUID() // Or use taskId if defined above. This is for SwiftUI.
    let description: String // Text shown to player (e.g., "Collect 5 herbs")
    let type: String        // Type of task (e.g., "fetch", "kill", "talk", "goto")
    let target: String?     // ID of item, NPC, location, enemy type etc. (optional)
    let quantity: Int?      // Optional quantity (e.g., for fetch/kill tasks)

    // CodingKeys to map JSON keys if they differ, or just to be explicit
    private enum CodingKeys: String, CodingKey {
        // case taskId
        case description
        case type
        case target
        case quantity
    }
}


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
    }
    
    
    
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
}
