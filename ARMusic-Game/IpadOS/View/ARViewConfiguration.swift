//
//  ARViewConfiguration.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 28/07/24.
//

import SwiftUI
import RealityKit
import ARPackage
import AudioPackage

struct ARViewContainer: UIViewRepresentable {
    @ObservedObject var instrumentSystem: InstrumentSystem

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let arViewManager = ARSettings(arView: arView)
        arViewManager.setupAR()
        registerSystem()
        registerComponents()
        instrumentSystem.arView = arView
        return arView
    }
    
    func registerSystem() {
        WorldSystem.registerSystem()
        AudioSystem.registerSystem()
    }
    
    func registerComponents() {
        AudioComponent.registerComponent()
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}
