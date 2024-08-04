//
//  File.swift
//
//
//  Created by Eduardo on 02/08/24.
//

import Foundation
import RealityKit
import ARKit
import Combine
import DataPackage
import AudioPackage

@MainActor
@Observable public class ARViewManager: NSObject {
    public var arView: ARView
    public var stateMachine = ARStateMachine()
    
    var modelLoader = ModelLoader()
    var anchorEntity = AnchorEntity(plane: .horizontal)
    
    public override init() {
        self.arView = ARView(frame: .zero)
        super.init()
        self.setupARView()
    }
    
    private func setupARView() {
        // Configure AR session
        arView.addCoaching()
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config)
        arView.session.delegate = self
        // Add anchor to the scene
        arView.scene.anchors.append(anchorEntity)
        
        // Add gesture recognizers
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEntityTouch(_:)))
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(_:)))
        longPressGesture.minimumPressDuration = 2.0 // Set the long press duration to 2 seconds
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onDrag(_:)))
        
        // Set delegate for gesture recognizers
        tapGesture.delegate = self
        longPressGesture.delegate = self
        panGesture.delegate = self
        
        arView.addGestureRecognizer(tapGesture)
        arView.addGestureRecognizer(longPressGesture)
        arView.addGestureRecognizer(panGesture)
        
    }
    
    public func loadInstrumentModel(instrument: Instruments) {
        let instrumentEntity = InstrumentEntity(instrument: instrument)
        
        // add components to entity before creation
        instrumentEntity.addAudioComponent()
        
        modelLoader.loadModel(for: instrumentEntity, into: anchorEntity, with: arView)
    }
    
    public func resetSession() {
        // Reset AR session
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        arView.session.run(config, options: [.resetTracking, .removeExistingAnchors])
        
        // Clear existing models
        anchorEntity.children.removeAll()
    }
    
    @objc private func handleEntityTouch(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: arView)
        
        guard let entity = getEntity(at: location) else {
            stateMachine.exitEditingMode()
            return
        }
        
        if let instrumentEntity = entity as? InstrumentEntity ?? entity.parent as? InstrumentEntity {
            stateMachine.enterEditingMode(with: instrumentEntity)
        } else {
            stateMachine.exitEditingMode()
        }
    }
    
    
    @objc private func onLongPress(_ gesture: UILongPressGestureRecognizer) {
        let location = gesture.location(in: arView)
        
        switch gesture.state {
            case .began:
                if let entity = getEntity(at: location),
                   let instrumentEntity = entity as? InstrumentEntity ?? entity.parent as? InstrumentEntity {
                    stateMachine.enterDraggingMode(with: instrumentEntity)
                }
            case .ended:
                stateMachine.exitDraggingMode()
            default:
                break
        }
    }
    
    
    @objc private func onDrag(_ gesture: UIPanGestureRecognizer) {
        guard let entity = stateMachine.currentEntity else { return }
        
        let location = gesture.location(in: arView)
        
        switch gesture.state {
            case .changed:
                if let rayResult = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal).first {
                    let newPosition = SIMD3<Float>(rayResult.worldTransform.columns.3.x,
                                                   rayResult.worldTransform.columns.3.y,
                                                   rayResult.worldTransform.columns.3.z)
                    entity.position = newPosition
                }
            default:
                break
        }
    }
    
    private func getEntity(at location: CGPoint) -> Entity? {
        let results = arView.hitTest(location)
        return results.first?.entity
    }
}

extension ARViewManager: ARSessionDelegate {
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let cameraTransform = frame.camera.transform
        let cameraPosition = SIMD3<Float>(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        let cameraOrientation = frame.camera.eulerAngles
        AudioUtils.shared.position = cameraPosition
        AudioUtils.shared.orientation = cameraOrientation
        AudioUtils.shared.viewMatrix = session.currentFrame?.camera.viewMatrix(for: .landscapeLeft)
    }
}

extension ARViewManager: UIGestureRecognizerDelegate {
    // UIGestureRecognizerDelegate method to allow simultaneous gesture recognition
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // UIGestureRecognizerDelegate method to prevent tap when long press is recognized
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer && otherGestureRecognizer is UILongPressGestureRecognizer {
            return true
        }
        return false
    }
}
