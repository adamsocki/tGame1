//
//  GameManager.swift
//  tGame1
//
//  Created by Adam Socki on 4/24/25.
//



import SwiftUI


class GameManager: ObservableObject {
    
    let progressionManager: ProgressionManager
    let progressionMapper: ProgressionMapper
    let dialogManager: DialogManager
    
    let questManager: QuestManager
    
    
    init () {
        self.progressionMapper = ProgressionMapper()
        self.dialogManager = DialogManager()
        self.questManager = QuestManager()
        
        
        self.progressionManager = ProgressionManager(mapper: progressionMapper, questManager: questManager)
        
    }
    
    
    
    
}
