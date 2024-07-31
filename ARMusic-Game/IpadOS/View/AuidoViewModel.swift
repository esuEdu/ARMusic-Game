//
//  AuidoViewModel.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Eduardo on 26/07/24.
//

import Foundation
import ARKit
import RealityKit
import SwiftUI
import AudioPackage
import Combine

@Observable class AuidoViewModel: NSObject {
    var arView: ARView = ARView(frame: .zero)
    var sharedAnchor: AnchorEntity?
    
    override init() {
        super.init()
        setupARView()
    }
    
    private func setupARView() {
        arView.automaticallyConfigureSession = true
        
        let arConfig = ARWorldTrackingConfiguration()
        arConfig.planeDetection = [.horizontal, .vertical]
        arView.session.delegate = self
        arView.session.run(arConfig, options: [])
        
        // Add gesture recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        arView.addGestureRecognizer(tapGestureRecognizer)
        
        // Initialize shared anchor
        sharedAnchor = AnchorEntity()
        arView.scene.addAnchor(sharedAnchor!)
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
                
                let box = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: .red, isMetallic: true)])
                let box2 = ModelEntity(mesh: .generateBox(size: 0.1), materials: [SimpleMaterial(color: .red, isMetallic: true)])
                                
                var component = AudioComponent(note: .d, instrument: .piano, tom: 100)
                _ = component.tempo.toggleValue(at: 4)
                _ = component.tempo.toggleValue(at: 5)
                
                var component2 = AudioComponent(note: .d, instrument: .piano, tom: 100, startBeat: 5, endBeat: 10)
                _ = component2.tempo.toggleValue(at: 1)
                
                box.components.set(component)
                box.position = position
                box2.components.set(component2)
                box2.position = position
                
                sharedAnchor?.addChild(box)
                sharedAnchor?.addChild(box2)
            }
        }
    }
}

extension AuidoViewModel: ARSessionDelegate {
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let cameraTransform = frame.camera.transform
        let cameraPosition = SIMD3<Float>(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        let cameraOrientation = frame.camera.eulerAngles
        
        AudioUtils.shared.position = cameraPosition
        AudioUtils.shared.orientation = cameraOrientation

    }
}

struct arViewRepresetable: UIViewRepresentable {
    @Bindable var viewModel: AuidoViewModel
    
    func makeUIView(context: Context) -> ARView {
        return viewModel.arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}
