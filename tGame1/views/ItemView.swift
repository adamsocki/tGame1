//
//  ItemView.swift
//  tGame1
//
//  Created by Adam Socki on 4/17/25.
//

import Foundation
import SwiftData
import SwiftUI
import Combine





struct ItemView: View {
    var item: Item
    
    @Environment(\.modelContext) private var modelContext
    @Query private var gameDatas: [GameData]
    
    @State private var timer: AnyCancellable?
    
    var body: some View {
        
        HStack {
            VStack (alignment: .leading){
                
                Text("Item Details")
                    .font(.largeTitle)
                Text("Time Created: \(Double(item.timeCreated))")
                stateTextView()
                Spacer()
                
            }
            .padding()
            .navigationTitle("Details")
            .onAppear() {
                //            startTimer()
                print(item.state.rawValue)
                item.updateStateBasedOnScore()
            }
            //            Spacer()
        }
        //        HStack {
        //            VStack {
        //
        //
        //                Text("Time Created: \(Double(item.timeCreated))")
        //                Text("Item Value: \(item.score)")
        //
        //                stateTextView()
        //            }
        //
        //            Spacer()
        //
        //        }
        //        .padding()
        //        .navigationTitle("Details")
        //        .onAppear() {
        ////            startTimer()
        //            print(item.state.rawValue)
        //            item.updateStateBasedOnScore()
        //        }
        //
        //        Spacer()
        
        
        
    }
    
    
    @ViewBuilder
    private func stateTextView() -> some View {
        HStack{
            VStack (alignment:.leading)
            {
                
                let rawValue = item.state.rawValue
                Text("Current State: \(rawValue) state")
                
                if (0...100).contains(item.state.rawValue) {
                    ItemState0GroupView(item: item)
                    Divider()
                }
                if (1...100).contains(item.state.rawValue) {
                    ItemState1GroupView(item: item)
                    Divider()
                }
                if (2...200).contains(item.state.rawValue) {
                    ItemState2GroupView(item: item)
                    Divider()
                }
                if (3...300).contains(item.state.rawValue) {
                    ItemState3GroupView(item: item)
                    Divider()
                }
            }
        }
        Spacer()
        
        
    }
    
    
    
    private func startTimer() {
        timer = Timer.publish(every: 0.05, on: .main, in: .common) // Update ~20 times per second
            .autoconnect()
            .sink { _ in
                print("Timer ticked")
            }
    }
    
    
}





