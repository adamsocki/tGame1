//
//  ItemStateViews.swift
//  tGame1
//
//  Created by Adam Socki on 4/18/25.
//



import SwiftUI
import MapKit


struct ItemState0GroupView: View {
    
    @Bindable var item: Item
    
    var body: some View {
        Button(action: {
//            AddPoint_0()
            item.addScore(1)
            
        }, label: {
            Text("Add Point + 1")
        })
    }
}

struct ItemState1GroupView: View {
    @Bindable var item: Item
    var body: some View {
        Text("ItemStateViews")
        
        VStack {
            HStack{
                GroupBox(label: Text("Score: \(item.score)")){
                    Text("Score: \(item.score)")
                }
                .draggable(item.score.description)
            }
            Button(action: {
                item.addScore(2)
                
            }, label: {
                Text("Add Point + 2")
            })
        }
        
    }
}

struct ItemState2GroupView: View {
    @Bindable var item: Item
    var body: some View {
        VStack {
            Button(action: {
                item.addScore(3)
                
            }, label: {
                Text("Add Point + 3")
            })
        }
    }
}

struct ItemState3GroupView: View {
    @Bindable var item: Item
    var body: some View {
        VStack {
            Button(action: {
                item.addScore(4)
                
            }, label: {
                Text("Add Point + 4")
            })
        }
    }
}
