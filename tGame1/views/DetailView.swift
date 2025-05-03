//
//  DetailView.swift
//  tGame1
//
//  Created by Adam Socki on 5/3/25.
//

import Foundation
import SwiftUI
//import Combine


struct DetailView: View {
//    @Binding var selectedItem: ItemData?
    
    @ObservedObject var uiManager: UIManager
    
    var body: some View {
        switch uiManager.currentUnitTypeSelected {
        case .person:
            PersonDetailView(uiManager: uiManager)
        default:
            Text("default")
        }
    }
}
