import ARKit
import RealityKit

class MainARView: ARView {
    
    var arView: ARView {
        return self
    }
    
    var box: ModelEntity!
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        arView.automaticallyConfigureSession = true
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic

        
        arView.addCoaching() 
        
        arView.session.run(configuration, options: [])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(handleTap(_:)))
        arView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: arView)
        
        let results = arView.raycast(from: location, allowing: .estimatedPlane, alignment: .horizontal)
        
        if let firstResult = results.first {
            
            
            let anchor = AnchorEntity(raycastResult: firstResult)
            
            let modelEntity = ModelEntity(mesh: MeshResource.generateBox(size: 0.3))
            modelEntity.generateCollisionShapes(recursive: true)
            modelEntity.model?.materials = [SimpleMaterial(color: .blue, isMetallic: true)]
            
            
            
            anchor.addChild(modelEntity)
            
            arView.scene.addAnchor(anchor)
            
            arView.installGestures(.all, for: modelEntity)
        }
    }
    
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}
