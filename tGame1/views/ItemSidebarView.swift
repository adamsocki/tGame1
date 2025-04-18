//
//  ItemSidebarView.swift
//  tGame1
//
//  Created by Adam Socki on 4/22/25.
//

import SwiftUI
import SwiftData




struct ItemSidebarView: View {
    @Bindable var item: Item
    
    var body: some View {
        HStack {    
            switch item.sidebarViewState {
                
            case .normal:
                Text("\(String(describing: item.name))")
            case .editingName:
    //            TextField( "User name (email address)",text: $item.name )
                Text("HI")
            default:
                Text("issue")
            }
            
            Text(", Score: \(item.score)")
            Spacer()
            Text("\(item.state)")
                .font(.caption)
                .foregroundColor(.secondary)
        }
       
    }
}
