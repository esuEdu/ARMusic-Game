import RealityKit
import ARKit
import Foundation
import AudioPackage
import DataPackage

public class MainARView: ARView {
    
    private var arView: ARView {
        self
    }
    
    let anchorEntity = AnchorEntity(plane: .horizontal)
    
    var arViewManager: ARViewManager!
    
    var stateMachine: ARStateMachine {
        arViewManager.stateMachine
    }
    
    public init(arViewManager: ARViewManager) {
        self.arViewManager = arViewManager
        
        super.init(frame: .zero)
        arViewManager.arView = self
        setupARView()
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
        ModelLoader.shared.loadModel(for: instrument, into: anchorEntity, with: arView)
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
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
    required dynamic init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
    }
}

extension MainARView: ARSessionDelegate {
    
//    public func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
//        
//        if let _ = anchors.first(where: {anchor in
//            anchor is ARPlaneAnchor}) {
//            
//            let newAnchor = AnchorEntity(.plane([.any], classification: .any, minimumBounds: [0.5, 0.5]))
//            
//            let mesh: MeshResource = .generatePlane(width: 1, depth: 1  )
//            
//            let material = SimpleMaterial(color: .red, isMetallic: false )
//            
//            let planeEntity = ModelEntity(mesh: mesh, materials: [material])
//            
//            newAnchor.addChild(planeEntity)
//            
//            arView.scene.addAnchor(newAnchor)
//            
//        }
//        
//    }
    
    public func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let cameraTransform = frame.camera.transform
        let cameraPosition = SIMD3<Float>(cameraTransform.columns.3.x, cameraTransform.columns.3.y, cameraTransform.columns.3.z)
        let cameraOrientation = frame.camera.eulerAngles
        AudioUtils.shared.position = cameraPosition
        AudioUtils.shared.orientation = cameraOrientation
        AudioUtils.shared.viewMatrix = session.currentFrame?.camera.viewMatrix(for: .landscapeLeft)
    }
}
