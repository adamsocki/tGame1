//
//  GameConsoleView.swift
//  tGame1
//
//  Created by Adam Socki on 4/22/25.
//

import SwiftUI
import SwiftData

struct GameConsoleView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var gameDatas: [GameData]
    
    
    
    @Binding var showBottomSheet: Bool
    
    var body: some View {
        // Tab to hide and show the console
        VStack (spacing: 0){
            HStack {
                Spacer()
                Button {
                    // The animation modifier below will animate this change
                    showBottomSheet.toggle()
                } label: {
                    // Change icon based on state
                    Label("", systemImage: showBottomSheet ? "inset.filled.bottomthird.square" : "inset.filled.topthird.square")
                    
                }
                .font(.system(size: 12))
                .buttonStyle(.borderless)
                //                .padding(.trailing, )
                .padding(.top, -2)
                .padding(.bottom, 2)
            }
            .frame(height: 20) // Give the button area a fixed height
            .background(Color.gray.opacity(0.1))
            
            
            
            if showBottomSheet {
                
                
                // CONSOLE
                HStack {
                    // LEFT SIDE
                    VStack {
                        Text("HI")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity) 
                    .background(Color.blue.opacity(0.2))
                    // RIGHT SIDE
                    
                    VStack {
                        HStack {
                            Text("Game Console | ")
                            Text("Score: \(gameDatas.first!.score)")
                            Spacer()
                        }
                        Spacer()
                        Text("Bottom Sheet Content Here")
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.green.opacity(0.2))
                }
                .frame(minHeight: 60, idealHeight: 140, maxHeight: 350)
                .frame(minHeight: 60, idealHeight: 140, maxHeight: 350)
            }
        }
    }
}
