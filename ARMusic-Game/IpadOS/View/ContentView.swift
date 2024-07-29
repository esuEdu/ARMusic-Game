//
//  ContentView.swift
//  ARMusic-Game
//
//  Created by Eduardo on 18/07/24.
//

import SwiftUI
import ARPackage

struct ContentView: View {
    @StateObject private var instrumentSystem = InstrumentSystem(arView: nil)

    var body: some View {
        ZStack {
            ARViewContainer(instrumentSystem: instrumentSystem)
                .edgesIgnoringSafeArea(.all)
            
            MainHUDView()
        }
        .environmentObject(instrumentSystem)
    }
}

