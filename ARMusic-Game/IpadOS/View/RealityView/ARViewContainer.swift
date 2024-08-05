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
        AudioTimerManager.shared.start()
        
        registerSystem()
        registerComponents()
        return arViewManager.arView
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func registerComponents() {
        AudioComponent.registerComponent()
        OutlineComponent.registerComponent()
    }
    
    func registerSystem() {
        AudioSystem.registerSystem()
        OutlineSystem.registerSystem()
    }
}



