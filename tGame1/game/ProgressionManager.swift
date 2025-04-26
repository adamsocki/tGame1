//
//  ProgressionManager.swift
//  tGame1
//
//  Created by Adam Socki on 4/24/25.
//

import SwiftUI

//enum CurrentTask {
//    case initTask
//    case findKey
//    case talkToGuard
//    case solveRiddle
//    case end
//}

enum CurrentGameState {
    case intro
    case main
    case end
}

class ProgressionManager: ObservableObject {
    
    let mapper: ProgressionMapper
    let questManager: QuestManager
    
    init(mapper: ProgressionMapper, questManager: QuestManager) {
        
        self.mapper = mapper
        self.questManager = questManager
        startListening()
    }
    
    @Published var currentGameState: CurrentGameState = CurrentGameState.intro
    
    @Published var currentQuest: Quest = Quest(id: QuestType.introQuest)
    
    
    
    
    
    private func startListening() {
        
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(handleGameStart), name: .gameStarted, object: nil)
        
        nc.addObserver(self, selector: #selector(handleQuestEnder), name: .gameStarted, object: nil)
        
    }
    
    private func loadQuest(_ questId: QuestType) {
//        self.currentQuest = Quest(id: questId)
    }
   
   
    
    func offerQuest(_ type: QuestType) {
        guard questManager.activeQuests[type] == nil && !questManager.completedQuests.contains(type) else {
            print("quest \(type.rawValue) is already active or completed")
            return
        }
        
        guard let questDefinition = questManager.getQuestDefinition(for: type) else {
            print("No quest definition found for \(type.rawValue)")
            return
        }
        
        // Check for Quest Prerequisites
        let prerequisitesMet = questManager.checkQuestPrequisites(prerequisites: questDefinition.prerequisites)
        guard prerequisitesMet else {
            print("no can do, prerequisites not met for \(type.rawValue)")
            return
        }
    }
    
    
    
    
    @objc private func handleGameStart(notification: Notification) {
        debugPrint("gamestarted notification received")
    }
    
    @objc private func handleQuestEnder(notification: Notification) {
        debugPrint("questEnder notification received")
    }

    
    
}




extension Notification.Name {
    static let gameStarted = Notification.Name("gameStarted")
    static let questEnded  = Notification.Name("questEnded")
//    static let gameStarted = Notification.Name(
}
