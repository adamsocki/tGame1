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
    let uiManager: UIManager
    let sequenceManager: SequenceManager
    
    let questManager: QuestManager
    
    
    init () {
        self.progressionMapper = ProgressionMapper()
        self.uiManager = UIManager()
        
        
        self.dialogManager = DialogManager()
        self.questManager = QuestManager()
        self.sequenceManager = SequenceManager(uiProvider: dialogManager)
        
        
        
        self.progressionManager = ProgressionManager(mapper: progressionMapper, questManager: questManager)
        self.sequenceManager.startSequence(id: "intro_sequence")

    }
    
    
    
    
}
