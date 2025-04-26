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


struct DialogNode: Decodable, Identifiable {
    let id: String // Unique identifier for this node (e.g., "start", "torch_lit")
    let player: String?
    let text: String
    let type: String?
    let part: String?
    let seq: String?
//    let choices: [DialogChoice]? // Optional: Choices available at this node
    let next: String?
}


class DialogManager: ObservableObject
{
    @Published var dialogNodes: [DialogNode] = []
    
    init() {
        self.dialogNodes = loadDialogData(filename: "dialog.json")
        printDialogTest()
    }
    
    private func printDialogTest() {
        // iteratue over the dialogNode
        
        dialogNodes.forEach { node in
//            debugPrint(node.text)
        }
        
    }
        
    func findNodeText(type: String, part: String, seq: String) -> String? {
        // Use first(where:) to find the first element matching the conditions
        let foundNode = dialogNodes.first { node in
            // Check if both part and seq match the desired values
            // Using optional binding (==) safely compares optionals to non-optionals
            node.part == part && node.seq == seq && node.type == type
        }
        return foundNode?.text  // Returns the found DialogNode or nil if not found
    }
    
    private func loadDialogData(filename: String) -> [DialogNode]
    {
        guard let url = Bundle.main.url(forResource: filename, withExtension: nil) else {
            fatalError("Could not find \(filename).")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load data for \(filename) from url: \(url)")
        }
        
        print("Successfully loaded \(filename)")
        
        let decoder = JSONDecoder()
        guard let nodes = try? decoder.decode([DialogNode].self, from: data) else {
            fatalError("Could not decode \(filename) into [DialogNode].")
        }

        return nodes
    }
}
