//
//  DialogManager.swift
//  tGame1
//
//  Created by Adam Socki on 4/24/25.
//

import SwiftUI
import Foundation

//struct DialogChoice: Codable, Identifiable {
//    let id = UUID() // For SwiftUI lists/buttons
//    let text: String
//    let next: String // The ID of the next dialog node
//}
enum DialogViewLocation: String, Codable {
    case sheet          = "sheet"
    case sidebar        = "sidebar"
    case detail         = "detail"
    case console_left   = "console_left"
    case console_right  = "console_right"
    case inspector      = "inspector"
}

struct DialogNode: Decodable, Identifiable {
    let id: String // Unique identifier for this node (e.g., "start", "torch_lit")
    let player: String?
    let text: String
    let type: String?
    let part: String?
    let seq: String?
//    let choices: [DialogChoice]? // Optional: Choices available at this node
    let next: String?
    
    let viewLocation: String
    
}



class DialogManager: ObservableObject, UIProvider
{
    func showSheet(contentID: String, completion: @escaping () -> Void) {
        print("showSheet")
    }
    
    @Published private(set) var dialogNodes: [String: DialogNode] = [:]
    @Published var isActive: Bool = false
    @Published var currentSpeaker: String?
    @Published var currentText: String?
//        @Published var currentChoices: [DialogChoice]?
    
    
    private var currentNodeId: String?
        
   
    init() {
        self.dialogNodes = loadDialogData(filename: "dialog.json")
        printDialogTest()
    }
    private func printDialogTest() {
            dialogNodes.values.forEach { node in // Iterate over .values
                 print("Node ID: \(node.id), Text: \(node.text)")
            }
        }
    
    func getNode(by id: String) -> DialogNode? {
           return dialogNodes[id] // Efficient dictionary lookup (O(1) average)
       }
    
        
    
    
    //*************************************************************************//
    // CODE FOR RELATIONSHIP WITH STARTING DIALOG TRIGGERED BY SEQUENCEMANAGER //
    //*************************************************************************//
    
    
    
    
    
    // --- Method Called by SequenceManager (Implements DialogProvider) ---
    private var sequenceCompletionHandler: (() -> Void)?
    func showDialog(dialogID: String, completion: @escaping () -> Void) {
        print("DialogManager: Received request to show dialog starting with ID: \(dialogID)")
        
        guard let startNode = dialogNodes[dialogID] else {
            print("Error: Dialog node with ID '\(dialogID)' not found.")
            completion() // Call completion immediately if dialog can't start, so sequence isn't stuck
            return
        }

        isActive = true
        self.sequenceCompletionHandler = completion
        
        // Set the initial state for the UI
        displayNode(startNode)
        isActive = true
        objectWillChange.send() // Notify observers
        
    }
    
    
    func advanceDialog()
    {
        guard isActive, let nodeId = currentNodeId, let currentNode = dialogNodes[nodeId] else {
            return // No active dialog or node
        }
        
        // Determine the next node ID (assuming no choices here)
        let nextNodeId = currentNode.next // Get the 'next' ID from the current node data
        
        processNextStep(nextNodeId: nextNodeId)
    }
    
    
    private func processNextStep(nextNodeId: String?) {
        if let nextId = nextNodeId, let nextNode = dialogNodes[nextId] {
            // --- There is a next part ---
            print("DialogManager: Advancing to node ID: \(nextId)")
            displayNode(nextNode) // Update published properties for UI
            objectWillChange.send()
        } else {
            // --- This dialog flow has ended ---
            print("DialogManager: Dialog flow ending (no next node ID).")
//            cleanupAndComplete()
        }
    }
    
    private func displayNode(_ node: DialogNode) {
           currentNodeId = node.id
           currentSpeaker = node.player // Assuming 'player' field holds speaker name
           currentText = node.text
//           currentChoices = node.choices // This will be nil if the node has no choices defined
       }
    
    
    func findNodeText(type: String, part: String, seq: String) -> String? {
            // Use first(where:) on the dictionary's VALUES
            let foundNode = dialogNodes.values.first { node in
                node.part == part && node.seq == seq && node.type == type
            }
            return foundNode?.text
        }

    private func loadDialogData(filename: String) -> [String: DialogNode] {
           guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
               fatalError("Could not find \(filename).")
           }

           guard let data = try? Data(contentsOf: url) else {
               fatalError("Could not load data for \(filename) from url: \(url)")
           }

           let decoder = JSONDecoder()
           guard let nodesArray = try? decoder.decode([DialogNode].self, from: data) else {
               fatalError("Could not decode \(filename) into [DialogNode].")
           }
           print("Successfully decoded \(nodesArray.count) nodes from \(filename)")

           // --- Convert the Array [DialogNode] into a Dictionary [String: DialogNode] ---
           var nodesDictionary: [String: DialogNode] = [:]
           for node in nodesArray {
               // Check for duplicate IDs - crucial!
               if nodesDictionary[node.id] != nil {
                   print("⚠️ Warning: Duplicate dialog node ID found: '\(node.id)'. Overwriting previous entry. Check your JSON!")
               }
               nodesDictionary[node.id] = node
           }

           // Alternative using Dictionary(uniqueKeysWithValues:), but this crashes on duplicates!
           // Use only if you are CERTAIN your IDs are unique in the JSON.
           // guard let nodesDictionary = try? Dictionary(uniqueKeysWithValues: nodesArray.map { ($0.id, $0) }) else {
           //    fatalError("Could not create dictionary. Check for duplicate IDs in \(filename).")
           // }

           return nodesDictionary
       }
}
