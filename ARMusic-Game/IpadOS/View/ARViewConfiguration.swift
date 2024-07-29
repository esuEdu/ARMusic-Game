//
//  ARViewConfiguration.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 28/07/24.
//

import SwiftUI
import RealityKit
import ARPackage

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var instrumentSystem: InstrumentSystem

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let arViewManager = ARSettings(arView: arView)
        arViewManager.setupAR()
        
        instrumentSystem.arView = arView
        return arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}
