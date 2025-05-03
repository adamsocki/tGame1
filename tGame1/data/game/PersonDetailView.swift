//
//  PersonDetailView.swift
//  tGame1
//
//  Created by Adam Socki on 5/3/25.
//

import Foundation
import SwiftUI


struct PersonDetailView: View {
    @ObservedObject var uiManager: UIManager
    
    
    var body: some View {
        
        
        VStack {
            HStack {
                
                Text("Person Name: \(uiManager.currentPersonSelected?.name ?? "No Person Selected")")
                Spacer()
            }
            .padding()
            Spacer()
            Text("MMM")
        }
       
    }
}
