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
    @Environment(ARViewManager.self) var arViewManager: ARViewManager

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let arViewManager = ARSettings(arView: arView)
        
        WorldSystem.worldSettings = arViewManager
        AudioTimerManager.shared.start()
        arViewManager.setupAR()
        registerSystem()
        registerComponents()
        registerSystem()
        return arViewManager.arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func registerComponents() {
        AudioComponent.registerComponent()
    }
    
    func registerSystem() {
        AudioSystem.registerSystem()
    }
}



