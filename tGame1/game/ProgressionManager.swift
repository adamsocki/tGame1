//
//  ProgressionManager.swift
//  tGame1
//
//  Created by Adam Socki on 4/24/25.
//
import Combine
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
//
class ProgressionManager: ObservableObject {
    
    let mapper: ProgressionMapper
    let questManager: QuestManager
    
    init(mapper: ProgressionMapper, questManager: QuestManager) {
        
        self.mapper = mapper
        self.questManager = questManager
        startListeningForGameEvents()
        
        // THIS IS A GAME INIT QUEST
        questManager.offerQuest(.introQuest)
    }
    
    @Published var currentGameState: CurrentGameState = CurrentGameState.intro
    
//    @Published var currentQuest: Quest = Quest(data: QuestType.introQuest)
    
    private var cancellables = Set<AnyCancellable>()
    
    
    
    private func startListeningForGameEvents() {
        
        let nc = NotificationCenter.default
        nc.publisher(for: .gameDidStart).sink { [weak self] note in self?.handleGameEvent(note)}.store(in: &cancellables)
//        nc.publiser(for: .)
//        nc.addObserver(self, selector: #selector(handleGameStart), name: .gameStarted, object: nil)
        
//        nc.addObserver(self, selector: #selector(handleQuestEnder), name: .gameStarted, object: nil)
        
    }
    
    private func loadQuest(_ questId: QuestType) {
//        self.currentQuest = Quest(id: questId)
        
//        questManager.offerQuest(questId)
    }
   
    private func handleGameEvent(_ notification: Notification)
    {
//        var questStateChanged = false
        
        //        var updates: [(QuestType, TaskUpdateType)] = []
        
        for (_, quest) in questManager.activeQuests {
            guard let currentTask = quest.currentTask else { continue }
            
            if taskMatchesEvent(task: currentTask, notification: notification) {
            }
            
        }
    }
        
    private func taskMatchesEvent(task: Task, notification: Notification) -> Bool {
        
        guard notification.userInfo != nil else { return false }
        
//        switch task.type {
//        case "display":
////            guard notification.name == 
//            
//            
//        default :
//            break
//        }
//        
        
        
        
        
        return false
    }
}




extension Notification.Name {
    static let gameStarted = Notification.Name("gameStarted")
    static let questEnded  = Notification.Name("questEnded")
//    static let gameStarted = Notification.Name(
}
