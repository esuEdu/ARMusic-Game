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
            
            
            let anchor = AnchorEntity(world: firstResult.worldTransform)
            
            anchor.addChild(box)
            
            arView.scene.addAnchor(anchor)
        }
    }
    
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}
