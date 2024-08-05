//
//  ContentView.swift
//  ARMusic-Game
//
//  Created by Eduardo on 18/07/24.
//

import SwiftUI
import ARPackage

@MainActor
struct RealityView: View {
    @State var arViewManager = ARViewManager.shared
    
    var body: some View {
        ZStack {
//            ARViewContainer()
//                .edgesIgnoringSafeArea(.all)
            
            MainHUDView()
        }
        .environment(arViewManager)
        .ignoresSafeArea()
    }
}

