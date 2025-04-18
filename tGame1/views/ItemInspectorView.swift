//
//  ItemInspectorView 2.swift
//  tGame1
//
//  Created by Adam Socki on 4/19/25.
//


//
//  ItemInspectorView.swift
//  tGame1
//
//  Created by Adam Socki on 4/19/25.
//



import SwiftUI

public struct ItemInspectorView: View {
    
    @Binding public var showItemInspector: Bool
    
    
    public var body: some View {
        VStack {
            Divider()
            Text("Item Inspector View")
            Spacer()
        }
        .toolbar(content: {
            
            Spacer()
            Button {
                showItemInspector.toggle()
            } label: {
                Label("Toggle Inspector", systemImage: "sidebar.right")
            }
            
        })
        .inspectorColumnWidth(min: 200, ideal: 280, max: 400)
        
        
    }
}
