//
//  ContentView.swift
//  ARMusic-Game
//
//  Created by Eduardo on 18/07/24.
//

import SwiftUI
import ARPackage

struct ContentView: View {
    @State private var instrumentSystem = InstrumentSystem.shared

    var body: some View {
        ZStack {
            ARViewConfiguration()
                .edgesIgnoringSafeArea(.all)
            
            MainHUDView()
        }
        .environment(instrumentSystem)
    }
}

