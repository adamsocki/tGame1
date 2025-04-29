//
//  SequenceManager.swift
//  tGame1
//
//  Created by Adam Socki on 4/26/25.
//

import Foundation
import Combine


enum GameSeqeneceStepType: String, Codable {
    case showDialog = "showDialog"
    case startMusic = "startMusic"
    case playSound  = "playSound"
    
    //    case show
}
struct GameSequenceStep: Identifiable, Decodable {
    //    var id = UUID()
    var id : String?
    let type: GameSeqeneceStepType
    //    let targetID: String?
    
}

struct GameSequence: Identifiable, Decodable {
    let id: String
    let steps: [GameSequenceStep]
}


class SequenceManager: ObservableObject {
    
    
    @Published private(set) var activeSequenceID: String?
    @Published private(set) var isSequenceActive: Bool = false
    
    private var sequenceDefinitions: [String: GameSequence] = [:]
    private var currentSequenceSteps: [GameSequenceStep] = []
    private var currentSequence: GameSequence?
    
    private var currentStepIndex: Int = 0
    
    var uiProvider: UIProvider?
    
    
    init(uiProvider: UIProvider? = nil)
    {
        self.uiProvider = uiProvider
        loadSequenceDefinitions(from: "sequences.json")
    }
    
    private func loadSequenceDefinitions(from fileName: String)
    {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: nil),
              let data = try? Data(contentsOf: url) else {
            print("Error: Could not load sequence file: \(fileName)")
            return
        }
        let decoder = JSONDecoder()
        do {
            let loadedSequences = try decoder.decode([GameSequence].self, from: data)
            for seq in loadedSequences {
                sequenceDefinitions[seq.id] = seq
            }
            print("Successfully loaded \(sequenceDefinitions.count) sequence definitions.")
        } catch {
            print("Error decoding sequences: \(error)")
        }
    }
    
    
    //**************************//
    // --- Sequence Control --- //
    //**************************//
    
    
    func startSequence(id: String)
    {
        guard let sequence = sequenceDefinitions[id] else {
            print("Error: Sequence \(id) not found.")
            
            return
        }
        print ("sequence \(id) started")
        activeSequenceID = id
        currentSequence = sequence
        currentSequenceSteps = sequence.steps
        currentStepIndex = -1
        isSequenceActive = true
        processNextStep()
        
        //        guard !isSequenceActive else {
        //            print("Error: Cannot start sequence '\(id)', another sequence ('\(activeSequenceId ?? "Unknown")') is already active.")
        //            // Optionally queue sequences or handle interruption
        //            return
        //        }
    }
    
    func processNextStep()
    {
        guard isSequenceActive, let sequence = currentSequence else {
            // Sequence might have been stopped externally
            
            return
        }
        currentStepIndex += 1
        if currentStepIndex < sequence.steps.count {
            let step = sequence.steps[currentStepIndex]
            print("  ⏯️ Executing step \(currentStepIndex): \(step.id) (\(step.type.rawValue))")
            executeStep(step)
        } else {
            // Sequence finished
            print("⏹️ Sequence finished: \(sequence.id)")
            //            finishSequence()
        }
    }
    
    private func executeStep(_ step: GameSequenceStep)
    {
        let completion = { [weak self] in
            guard let self = self, self.isSequenceActive, self.currentStepIndex < (self.currentSequence?.steps.count ?? 0), self.currentSequence?.steps[self.currentStepIndex].id == step.id else {
                print("   ⏭️ Step completion called but sequence state changed. Ignoring.")
                return
            }
            print("   ✅ Step \(step.id) completed.")
            self.processNextStep()
        }
        
        switch step.type {
        case .showDialog:
            
            guard let dialogID = step.id as? String else {
                print(" ❌ Error: showDialog step '\(step.id)' missing targetID")
                return
            }
            guard let uiProvider = uiProvider else {
                print("   ❌ Error: UIProvider not available for showDialog step '\(step.id)'.")
                completion()
                return
            }
            
            
            uiProvider.showDialog(dialogID: dialogID, completion: completion)
            
            
        default:
            break
        }
    }
    
}
