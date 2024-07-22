//
//  ContentView.swift
//  ARMusic-Game
//
//  Created by Eduardo on 18/07/24.
//

import SwiftUI
import ARKit
import RealityKit
import Metal
import ARPackage




struct ContentView: View {
    var body: some View {
        VStack {
           ARViewContainer()
        }
        .padding()

    }
}

#Preview {
    ContentView()
}
