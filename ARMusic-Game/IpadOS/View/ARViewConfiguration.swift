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

struct ARViewConfiguration: UIViewRepresentable {
    @Environment(InstrumentSystem.self) var instrumentSystem: InstrumentSystem
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let arViewManager = ARSettings(arView: arView)
        
        context.coordinator.view = arView
        WorldSystem.worldSettings = arViewManager
        
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
        InputComponent.registerComponent()
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(instrumentSystem: instrumentSystem)
    }
}

class Coordinator: NSObject {
    weak var view: ARView?
    @State var instrumentSystem: InstrumentSystem
    
    init(instrumentSystem: InstrumentSystem) {
        self.instrumentSystem = instrumentSystem
    }
    

}



