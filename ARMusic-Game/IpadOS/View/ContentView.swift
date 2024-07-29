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
        VStack {
            ARViewContainer(instrumentSystem: instrumentSystem)
                .edgesIgnoringSafeArea(.all)
            
            InstrumentListView(instrumentSystem: instrumentSystem)
        }
    }
}

