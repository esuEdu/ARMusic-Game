//
//  ARViewConfiguration.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 28/07/24.
//

import SwiftUI
import RealityKit
import ARPackage

struct ARViewConfiguration: UIViewRepresentable {
    @ObservedObject var instrumentSystem: InstrumentSystem
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        let arViewManager = ARSettings(arView: arView)
        arViewManager.setupAR()
        
        // Adicionar recognizer de toque
        let tapRecognizer = UITapGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.handleTap(_:)))
        arView.addGestureRecognizer(tapRecognizer)
        
        instrumentSystem.arView = arView
        context.coordinator.view = arView
        
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(instrumentSystem: instrumentSystem)
    }
}

class Coordinator: NSObject {
    weak var view: ARView?
    @ObservedObject var instrumentSystem: InstrumentSystem
    
    init(instrumentSystem: InstrumentSystem) {
        self.instrumentSystem = instrumentSystem
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        guard let view = self.view else { return }
        
        let tapLocation = recognizer.location(in: view)
        let results = view.hitTest(tapLocation)
        
        if let firstResult = results.first, let entity = firstResult.entity as? ModelEntity {
            instrumentSystem.handleTapOnEntity(entity)
        }
    }
}



