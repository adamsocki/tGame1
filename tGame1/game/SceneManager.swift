//
//  SceneManager.swift
//  tGame1
//
//  Created by Adam Socki on 4/30/25.
//

import Foundation
import SwiftUI
import Combine

enum SceneCompletionType: String, Codable {
    case dialogEnd      // Scene ends when a specific (or any) dialog sequence completes
    case sheetDismissed // Scene ends when a specific (or any) generic sheet is dismissed
    case duration       // Scene ends after a specific time duration
    case eventReceived  // Scene ends when a specific Notification is posted
    case manual         // Scene ends only when explicitly told via code
    // case allOf       // (Advanced) Ends when all sub-conditions are met
    // case anyOf       // (Advanced) Ends when any sub-condition is met
}


enum SceneActionType: String, Codable {
    case startMusic, stopMusic, playSound, showDialog, showSheet
    case showUIElement, hideUIElement, triggerEvent, startSequence
    // Add more actions as your game requires
}

/// Represents the condition under which a scene is considered complete.
struct SceneCompletionCondition: Codable {
    let conditionType: SceneCompletionType
    let targetID: String?  // Optional ID relevant to the condition (e.g., dialog ID, sheet ID, event name)
    let value: Double?     // Optional value (e.g., duration in seconds)
    // For future expansion:
    // let conditions: [SceneCompletionCondition]? // For allOf/anyOf types
}

struct SceneDefinition: Codable, Identifiable {
    var id: String? = ""
    let description: String?
    let onStartActions: [SceneAction]
    let completionCondition: SceneCompletionCondition
    //    
}

struct SceneAction: Codable, Identifiable {
    let id: String
    let actionType: SceneActionType
    let targetID: String?
    let delay: Double?    // Optional delay in seconds before executing.
    
}

typealias SceneCollection = [String: SceneDefinition]


class SceneManager: ObservableObject {
    
    
    
    private let uiManager: UIManager
    private let dialogManager: DialogManager
    //    private let sequenceManager: SequenceManager
    
    
    // MARK: - Published Properties
    @Published private(set) var activeSceneId: String? = nil
    
    private var sceneDefinitions: SceneCollection = [:]
    
    private var currentCompletionCondition: SceneCompletionCondition?
    private var sequenceCompletionHandler: (() -> Void)?
    
    private var sceneTimerSubscription: AnyCancellable?
    private var notificationSubscriptions: [AnyCancellable] = []
    
    init(uiManager: UIManager, dialogManager: DialogManager, filename: String = "scenes.json") {
        self.uiManager = uiManager
        self.dialogManager = dialogManager
        
        self.sceneDefinitions = loadSceneDefinitions(from: filename)
        setupNotificationListeners()
    }
    
    
    private func loadSceneDefinitions(from filename: String) -> SceneCollection {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            print("❌ SceneManager Error: Could not find \(filename). Returning empty definitions.")
            return [:]
        }
        guard let data = try? Data(contentsOf: url) else {
            print("❌ SceneManager Error: Could not load data for \(filename) from url: \(url). Returning empty definitions.")
            return [:]
        }
        
        let decoder = JSONDecoder()
        
        // Attempt to decode
        do {
            // If this succeeds, assign to loadedScenes and proceed
            let loadedScenes = try decoder.decode(SceneCollection.self, from: data)
            print("✅ SceneManager: Successfully loaded \(loadedScenes.count) scene definitions from \(filename).")
            return loadedScenes // Return the successfully decoded scenes
            
        } catch let decodingError as DecodingError {
            // If decoding fails specifically with a DecodingError, print detailed info
            print("❌ SceneManager Decoding Error in \(filename):")
            // Provide context from the error object
            switch decodingError {
            case .typeMismatch(let type, let context):
                print("   Type mismatch for key '\(context.codingPath.map { $0.stringValue }.joined(separator: "."))': Expected \(type) but got something else. \(context.debugDescription)")
            case .valueNotFound(let type, let context):
                print("   Value not found for key '\(context.codingPath.map { $0.stringValue }.joined(separator: "."))': Expected \(type). \(context.debugDescription)")
            case .keyNotFound(let key, let context):
                print("   Key not found: '\(key.stringValue)' at path '\(context.codingPath.map { $0.stringValue }.joined(separator: "."))'. \(context.debugDescription)")
            case .dataCorrupted(let context):
                print("   Data corrupted: \(context.debugDescription) Path: \(context.codingPath.map { $0.stringValue }.joined(separator: "."))")
            @unknown default:
                print("   An unknown decoding error occurred: \(decodingError.localizedDescription)")
            }
            // Print the raw localized description as well
            print("   Raw Error: \(decodingError.localizedDescription)")
            
        } catch {
            // Catch any other non-decoding errors during the try? block
            print("❌ SceneManager Error: An unexpected error occurred during decoding \(filename): \(error.localizedDescription)")
        }
        
        // If we reach here, decoding failed.
        print("   Returning empty definitions due to decoding error.")
        return [:] // Return empty dictionary on any decoding error
    }
    
    
    // MARK: - Notification Handling
    
    private func setupNotificationListeners() {
        
        NotificationCenter.default.publisher(for: .dialogSequenceDidEnd)
            .sink { [weak self] notification in
                let dialogId = notification.userInfo?["dialogId"] as? String
                print("SceneManager: Received notification: dialogSequenceDidEnd (\(dialogId ?? "Unknown"))")
                self?.checkSceneCompletion(event: .dialogEnded, targetId: dialogId)
            }
            .store(in: &notificationSubscriptions)
        
        NotificationCenter.default.publisher(for: .uiSheetDidDismiss)
            .sink { [weak self] notification in
                let sheetId = notification.userInfo?["sheetId"] as? String
                print("SceneManager: Received notification: uiSheetDidDismiss (\(sheetId ?? "Unknown"))")
                self?.checkSceneCompletion(event: .sheetDismissed, targetId: sheetId)
            }
            .store(in: &notificationSubscriptions)
    }
    
    
    func startScene(id: String, completion: @escaping () -> Void) {
        guard activeSceneId == nil else {
            print("⚠️ SceneManager Warning: Tried to start scene '\(id)' while scene '\(activeSceneId!)' is already active. Ignoring.")
            completion()
            return
        }
        guard var sceneDef = sceneDefinitions[id] else {
            print("❌ SceneManager Error: Scene definition '\(id)' not found. Cannot start scene.")
            completion()
            return
        }
        sceneDef.id = id
        print("scene started    \(id)")
        activeSceneId = id
        currentCompletionCondition = sceneDef.completionCondition // Store condition for checking
        self.sequenceCompletionHandler = completion
        
        
        // --- Execute onStartActions ---
        sceneDef.onStartActions.forEach { action in
            let delay = action.delay ?? 0.0
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self]  in
                guard self?.activeSceneId == id else {
                    print("sceneManager: scene changed before delayed action \(action.actionType). could execute. skippppp")
                    return
                }
                // is scene still activ?
                self?.executeAction(action, sceneId: id)
                //                self?.e
            }
        }
        
        setupCompletionCheck(for: sceneDef.completionCondition)
    }
    
    // MARK: - Private Completion Logic
    /// Sets up the mechanism to check for the scene's completion (timer or relies on notifications).
    private func setupCompletionCheck(for condition: SceneCompletionCondition) {
        sceneTimerSubscription?.cancel()
        
        switch condition.conditionType {
        case .duration:
            if let duration = condition.value, duration > 0 {
                print("   SceneManager: Setting up completion timer for \(duration) seconds.")
                sceneTimerSubscription = Just(())
                    .delay(for: .seconds(duration), scheduler: DispatchQueue.main)
                    .sink { [weak self] _ in
                        print("SceneManager: Duration condition met via timer.")
                        // Use a specific targetID or nil for timer events
                        self?.checkSceneCompletion(event: .timerExpired, targetId: condition.targetID)
                    }
                
            } else {
                print(" SceneManager Warning: Invalid duration '\(condition.value ?? -1)' for completion condition")
            }
            
        default:
            return
        }
        
        
        
    }
    
    
    // MARK: - Private Action Execution
    /// Executes a single action defined within a scene's `onStartActions`.
    private func executeAction(_ action: SceneAction, sceneId: String) {
        
        print("executeAction \(action.actionType)")
        print("   🎬 SceneManager (\(sceneId)): Executing action \(action.actionType) (Target: \(action.targetID ?? "N/A"))")
        switch action.actionType {
        case .showSheet:
            if let targetID = action.targetID {
                uiManager.showSheet(contentID: targetID) {
                    print("   SceneManager (\(sceneId)): UIManager dismissed sheet '\(targetID)', notification posted.")
                }
            } else { print("   ⚠️ Warning: showSheet action missing targetID.") }
            
        default:
            print("🚨 SceneManager (\(sceneId)): Unsupported action type \(action.actionType). Skipping.")
            
        }
    }
    
    
    
    
    private func checkSceneCompletion(event: SceneCompletionEvent, targetId: String?) {
        guard let currentId = activeSceneId, let condition = currentCompletionCondition else { return }
        
        var conditionMet = false
        let conditionTargetId = condition.targetID // The ID specified in the scene definition, if any
        
        print("   SceneManager (\(currentId)): Checking completion | Condition: \(condition.conditionType)(\(conditionTargetId ?? "any")) | Event: \(event)(\(targetId ?? "any"))")
        switch condition.conditionType {
        case .duration:
            // Check if the event is timerExpired, potentially match targetID if timer had one
            conditionMet = (event == .timerExpired && (conditionTargetId == nil || conditionTargetId == targetId))
            
        default:
            return
        }
        
        if conditionMet {
            print("   ✅ SceneManager (\(currentId)): Completion condition MET!")
            finishScene()
        } else {
            print("    SceneManager (\(currentId)): Completion condition NOT YET MET.")
        }
    }
    
    private func finishScene() {
        guard let endedSceneId = activeSceneId else {
            print("⚠️ SceneManager Warning: finishScene called but no active scene.")
            return
        } // Ensure a scene is active
        
        print("⏹️ SceneManager: Finishing scene '\(endedSceneId)'")
        activeSceneId = nil
        currentCompletionCondition = nil
        sceneTimerSubscription?.cancel()
        sceneTimerSubscription = nil
        // Keep notification subscriptions active for next scene
        
        // Retrieve and clear the completion handler *before* calling it
        let handler = sequenceCompletionHandler
        sequenceCompletionHandler = nil
        
        // --- Optional: Add scene cleanup actions ---
        // e.g., stop music started by the scene, hide UI shown by the scene
        // if let sceneDef = sceneDefinitions[endedSceneId] { /* cleanup based on def */ }
        
        // --- Call completion handler for SequenceManager ---
        // Use async to ensure state cleanup completes first and avoid potential cycles
        DispatchQueue.main.async {
            print("   SceneManager: Calling sequence completion handler for scene '\(endedSceneId)'.")
            handler?()
        }
    }
    
    // MARK: - Helper Enum
    enum SceneCompletionEvent { case dialogEnded, sheetDismissed, timerExpired, eventReceived }
    
}



extension Notification.Name {
    static let dialogSequenceDidEnd = Notification.Name("dialogSequenceDidEnd") // Posted by DialogManager
    static let uiSheetDidDismiss = Notification.Name("uiSheetDidDismiss")       // Posted by UIManager
    // Add other custom event names used by "eventReceived" condition or "triggerEvent" action
}
