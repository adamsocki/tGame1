//
//  ItemDetailView.swift
//  tGame1
//
//  Created by Adam Socki on 4/20/25.
//


import SwiftUI
import SwiftData


struct ViewTop: View {
    @Binding var selectedItem: Item?
    var body: some View {
        VStack {
            if let item = selectedItem {
                HStack{
                    
                    ItemView(item: item)
                    
                    Spacer()
                    
                }
                
            } else {
                Text("Select an item")
            }
            
        }
        
        
    }
}



struct ItemDetailView: View {
    @State private var showBottomView: Bool = true
    @Binding var selectedItem: Item?
    
    var body: some View {
        
        
        VSplitView(content: {
            ViewTop(selectedItem: $selectedItem)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 100, maxHeight: .infinity)
            GameConsoleView(showBottomSheet: $showBottomView)
        })
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    
        
    }
}
