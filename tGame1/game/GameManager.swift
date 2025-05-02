//
//  GameManager.swift
//  tGame1
//
//  Created by Adam Socki on 4/24/25.
//



import SwiftUI


class GameManager: ObservableObject {
    
//    @Published var progressionManager: ProgressionManager
//    @Published var progressionMapper: ProgressionMapper
    @Published var dialogManager: DialogManager
    @Published var uiManager: UIManager
    @Published var sequenceManager: SequenceManager
    
    @Published var questManager: QuestManager
    @Published var sceneManager: SceneManager
    
    
    init () {
        
        let uiMngr = UIManager()
        let qstmngr = QuestManager()
        
        let dlgMngr = DialogManager(presenter: uiMngr)
        let scnMngr = SceneManager(uiManager:uiMngr, dialogManager: dlgMngr)
       
        let sqncMngr = SequenceManager(sceneManager: scnMngr)
        
        
        
        self.uiManager = uiMngr
        self.questManager = qstmngr
        self.sequenceManager = sqncMngr
        self.dialogManager = dlgMngr
        self.sceneManager = scnMngr
        
        
        
        self.sequenceManager.startSequence(id: "intro_sequence")
//        self.sceneManager.startScene(id: "intro_scene") {
//            print("scene ended")
//        }
//        self.progressionMapper = ProgressionMapper()
//        let uiManagerObject = UIManager()
//        self.uiManager = uiManagerObject
        
        
//        self.dialogManager = DialogManager(presenter: self.uiManager)
//        self.questManager = QuestManager()
//        self.sequenceManager = SequenceManager(uiProvider: uiManager)
        
        
//        self.progressionManager = ProgressionManager(mapper: progressionMapper, questManager: questManager)
        
//        self.sequenceManager.startSequence(id: "intro_sequence")

    }
}
