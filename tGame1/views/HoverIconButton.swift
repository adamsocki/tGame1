////
////  HoverIconButton.swift
////  tGame1
////
////  Created by Adam Socki on 4/19/25.
////
//
//import SwiftUI
//
//
//struct HoverIconButton: View {
//    let systemImage: String
//    let action: () -> Void
//    let defaultColor: Color // Add parameter for default color
//    let clickColor: Color   // Add parameter for hover color
//
//    // Each instance of HoverIconButton manages its own state
//    @State private var isClicked = false
//
//    var body: some View {
//        Button(action: action) {
//            Label("", systemImage: systemImage)
//                .foregroundStyle(isClicked ? clickColor : defaultColor)
//        }
//        .buttonStyle(.borderless)
//    }
//}
