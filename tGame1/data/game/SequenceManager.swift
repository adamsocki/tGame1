//
//  SequenceManager.swift
//  tGame1
//
//  Created by Adam Socki on 4/26/25.
//

import Foundation
import Combine


struct SequenceStep: Codable {
    enum StepType: String, Codable {
        case startScene
        case assignQuest
        case setGameState
    }
    
    let stepType: StepType
    let sceneId: String?
    let questId: String?
}

struct SequenceDefinition: Codable, Identifiable {
    var id: String? = ""
    let steps: [SequenceStep]
}

//enum GameSeqeneceStepType: String, Codable {
//    case showDialog = "showDialog"
//    case showSheet  = "showSheet"
//    case startMusic = "startMusic"
//    case playSound  = "playSound"
//
//    //    case show
//}
//struct GameSequenceStep: Identifiable, Decodable {
//    //    var id = UUID()
//    var id : String?
//    let type: GameSeqeneceStepType
//    //    let targetID: String?
//
//}
//
//struct GameSequence: Identifiable, Decodable {
//    let id: String
//    let steps: [GameSequenceStep]
//}

typealias SequenceCollection = [String: SequenceDefinition]

class SequenceManager: ObservableObject {
    
    private let sceneManager: SceneManager
    private let questManager: QuestManager
    
    private var sequenceDefinitions: SequenceCollection = [:]
    private var activeSequenceId: String? = nil
    private var currentStepIndex: Int = -1
    private var isProcessingStep: Bool = false // Prevents race conditions
    
    // Optional: Completion handler for the entire sequence
    private var sequenceCompletionHandler: (() -> Void)?
    
    init(sceneManager: SceneManager, questManager: QuestManager, fileName: String = "sequences.json") {
        self.sceneManager = sceneManager
        self.questManager = questManager
        self.sequenceDefinitions = loadSequenceDefinitions(from: fileName)
    }
    
    private func loadSequenceDefinitions(from fileName: String) -> SequenceCollection {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil) else {
            print("❌ SequenceManager Error: Could not find \(fileName). Returning empty definitions.")
            return [:]
        }
        guard let data = try? Data(contentsOf: url) else {
            print("❌ SequenceManager Error: Could not load data for \(fileName) from url: \(url). Returning empty definitions.")
            return [:]
        }
        let decoder = JSONDecoder()
        do {
            // Use keyDecodingStrategy if your JSON keys use snake_case (e.g., "scene_id")
            // decoder.keyDecodingStrategy = .convertFromSnakeCase
            let loadedSequences = try decoder.decode(SequenceCollection.self, from: data)
            print("✅ SequenceManager: Successfully loaded \(loadedSequences.count) sequence definitions from \(fileName).")
            return loadedSequences
        } catch {
            print("❌ SequenceManager Error: Could not decode \(fileName) into SequenceCollection.")
            // Print detailed decoding error
            if let decodingError = error as? DecodingError {
                print("   Decoding Error: \(decodingError)")
            } else {
                print("   Error: \(error)")
            }
            return [:]
        }
    }
    
    func startSequence(id: String, completion: (() -> Void)? = nil)
    {
        guard activeSequenceId == nil else {
            print("⚠️ SequenceManager Warning: Tried to start sequence '\(id)' while sequence '\(activeSequenceId!)' is already active. Ignoring.")
            completion?() // Call completion immediately as we didn't start.
            return
        }
        
        guard sequenceDefinitions[id] != nil else {
            print("❌ SequenceManager Error: Sequence definition '\(id)' not found.")
            completion?()
            return
        }
        
        print("▶️ SequenceManager: Starting sequence '\(id)'")
        activeSequenceId = id
        currentStepIndex = -1 // Start before the first step
        sequenceCompletionHandler = completion
        isProcessingStep = false // Reset processing flag
        
        // Start processing the first step
        processNextStep()
    }
    
    
    private func processNextStep()
    {
        guard !isProcessingStep else {
            print("SequenceManager: Already processing a step transition, ignoring additional processNextStep call.")
            return
        }
        
        guard let currentId = activeSequenceId, let sequenceDef = sequenceDefinitions[currentId] else {
            print("SequenceManager Internal Warning: processNextStep called but no sequence active/found.")
            isProcessingStep = false // Ensure flag is reset
            return // No active sequence
        }
        
        isProcessingStep = true // Indicate we are actively processing this transition
        currentStepIndex += 1 // Move to the next step index
        
        // Check if we've completed all steps
        guard currentStepIndex < sequenceDef.steps.count else {
            print("✅ SequenceManager: Reached end of sequence '\(currentId)' naturally.")
            //finishSequence(completedNaturally: true) // Calls completion handler
            return
        }
        
        // Get the current step definition
        let step = sequenceDef.steps[currentStepIndex]
        print("   SequenceManager (\(currentId)): Executing step \(currentStepIndex + 1)/\(sequenceDef.steps.count) - Type: \(step.stepType)")
        
        // Execute the step based on its type
        var stepCompletedImmediately = false
        switch step.stepType {
        case .startScene:
            guard let sceneId = step.sceneId else {
                print("   ❌ SequenceManager Error: Step \(currentStepIndex + 1) is 'startScene' but missing 'sceneId'. Skipping step.")
                stepCompletedImmediately = true // Skip and move to next step
                break // Break out of switch
            }
            
            // --- Call SceneManager ---
            // Pass self.stepCompleted as the completion handler.
            // SceneManager will call this when the scene it started finishes.
            sceneManager.startScene(id: sceneId) { [weak self] in
                // Ensure this callback pertains to the currently active sequence
                guard let self = self, self.activeSequenceId == currentId else {
                    print("   SequenceManager (\(currentId)): Completion received for scene '\(sceneId)' but sequence changed/stopped. Ignoring.")
                    return
                }
                print("   SequenceManager (\(currentId)): Completion received for scene '\(sceneId)' (Step \(self.currentStepIndex + 1))")
                self.stepCompleted() // Signal that this step is done
            }
            // For startScene, step is NOT completed immediately. We wait for the callback.
            isProcessingStep = false // Ready for the completion callback
        
            
        case .assignQuest:
            print("Assign quest triggered in SequenceManager")
            guard let questID = step.questId else {
                stepCompletedImmediately = true
                print("   ❌ Sequence Managager error: Step \(currentStepIndex + 1) is 'assign Quest' but missing questID.  skipping")
                break
            }
            // --- CALL QUEST MANAGER =====
//            questManager.startQuest(id: questID) { [weak self] in
//                
//                
//            }
//        
        
        default:
            print("   ⚠️ SequenceManager Warning: Unhandled step type '\(step.stepType)' at step \(currentStepIndex + 1). Skipping.")
            stepCompletedImmediately = true // Skip unknown steps
        }
        
        
    }
    
    private func stepCompleted() {
        print("SEQ COMPLETED")
        guard activeSequenceId != nil else {
            print("SequenceManager: stepCompleted called but no sequence is active. Ignoring.")
            return
        }
        
        // Ready to process the next step
        isProcessingStep = false
        processNextStep()
    }
    
}

//class SequenceManager: ObservableObject {
//
//
//    @Published private(set) var activeSequenceID: String?
//    @Published private(set) var isSequenceActive: Bool = false
//
//    private var sequenceDefinitions: [String: GameSequence] = [:]
//    private var currentSequenceSteps: [GameSequenceStep] = []
//    private var currentSequence: GameSequence?
//
//    private var currentStepIndex: Int = 0
//
//    var uiProvider: UIProvider?
//
//
//    init(uiProvider: UIProvider? = nil)
//    {
//        self.uiProvider = uiProvider
//        loadSequenceDefinitions(from: "sequences.json")
//    }
//
//    private func loadSequenceDefinitions(from fileName: String)
//    {
//        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil),
//              let data = try? Data(contentsOf: url) else {
//            print("Error: Could not load sequence file: \(fileName)")
//            return
//        }
//        let decoder = JSONDecoder()
//        do {
//            let loadedSequences = try decoder.decode([GameSequence].self, from: data)
//            for seq in loadedSequences {
//                sequenceDefinitions[seq.id] = seq
//            }
//            print("Successfully loaded \(sequenceDefinitions.count) sequence definitions.")
//        } catch {
//            print("Error decoding sequences: \(error)")
//        }
//    }
//
//
//    //**************************//
//    // --- Sequence Control --- //
//    //**************************//
//
//
//    func startSequence(id: String)
//    {
//        guard let sequence = sequenceDefinitions[id] else {
//            print("Error: Sequence \(id) not found.")
//
//            return
//        }
//        print ("sequence \(id) started")
//        activeSequenceID = id
//        currentSequence = sequence
//        currentSequenceSteps = sequence.steps
//        currentStepIndex = -1
//        isSequenceActive = true
//        processNextSequenceStep()
//
//    }
//
//    func processNextSequenceStep()
//    {
//        guard isSequenceActive, let sequence = currentSequence else {
//            // Sequence might have been stopped externally
//
//            return
//        }
//        currentStepIndex += 1
//        if currentStepIndex < sequence.steps.count {
//            let step = sequence.steps[currentStepIndex]
//            print("  ⏯️ Executing step \(currentStepIndex): \(step.id) (\(step.type.rawValue))")
//            executeStep(step)
//        } else {
//            // Sequence finished
//            print("⏹️ Sequence finished: \(sequence.id)")
//            //            finishSequence()
//        }
//    }
//
//    private func executeStep(_ step: GameSequenceStep)
//    {
//        let completion = { [weak self] in
//            guard let self = self, self.isSequenceActive, self.currentStepIndex < (self.currentSequence?.steps.count ?? 0), self.currentSequence?.steps[self.currentStepIndex].id == step.id else {
//                print("   ⏭️ Step completion called but sequence state changed. Ignoring.")
//                return
//            }
//            print("   ✅ Step \(step.id) completed.")
//            self.processNextSequenceStep()
//        }
//
//        switch step.type {
//        case .showDialog:
//
//            guard let uiProvider = uiProvider else {
//                print("   ❌ Error: UIProvider not available for showDialog step '\(step.id ?? "no")'.")
//                completion()
//                return
//            }
////            uiProvider.showDialog(dialogID: step.id!, completion: completion)
//
//        case .showSheet:
//            guard let uiProvider = uiProvider else {
//                print("   ❌ SequenceManager Error: UIProvider not available for step '\(String(describing: step.id))'. Skipping.")
//                completion()
//                return
//            }
//            uiProvider.showSheet(contentID: step.id!, completion: completion)
//
//        default:
//            break
//        }
//    }
//
//}
