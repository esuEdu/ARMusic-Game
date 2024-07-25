//
//  ContentViewModel.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Eduardo on 25/07/24.
//

import Foundation
import ARKit
import RealityKit
import SwiftUI
import AudioPackage

@Observable class ContentViewModel {
    var arView: ARView = ARView(frame: .zero)
    
    init() {
        setupARView()
    }
    
    private func setupARView() {
        arView.automaticallyConfigureSession = true
        
        let arConfig = ARWorldTrackingConfiguration()
        arConfig.planeDetection = [.horizontal, .vertical]
        arView.session.run(arConfig, options: [])
        
        // Add gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        arView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTap(_ gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: arView)
        
        if let entity = arView.entity(at: location) {
            // If an entity exists at the touch location, remove it
            entity.removeFromParent()
        } else {
            // If no entity exists at the touch location, add a new one
            let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
            
            if let firstResult = results.first {
                let position = SIMD3<Float>(firstResult.worldTransform.columns.3.x,
                                            firstResult.worldTransform.columns.3.y,
                                            firstResult.worldTransform.columns.3.z)
                
                let anchor = AnchorEntity(world: position)
                let box = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: .red, isMetallic: true)])
                
                
                let audioComponent = AudioComponent(note: .c, instrument: .piano, tom: 1.0, tempo: 120.0)
                box.components.set(audioComponent)
                
                anchor.addChild(box)
                arView.scene.addAnchor(anchor)
            }
        }
    }
}


struct arViewRepresetable: UIViewRepresentable {
    @Bindable var viewModel: ContentViewModel
    
    func makeUIView(context: Context) -> ARView {
        return viewModel.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
