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
    
    /*
     
     @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
         
         guard let view = self.view else { return }
         
         let tapLocation = recognizer.location(in: view)
         let results = view.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .horizontal)
         
         if let result = results.first {
             
             // ARAnchor - ARKit Framework
             // AnchorEntity - RealityKit Framework
             
             let anchorEntity = AnchorEntity(raycastResult: result)
             
             let modelEntity = ModelEntity(mesh: MeshResource.generateBox(size: 0.3))
             modelEntity.generateCollisionShapes(recursive: true)
             modelEntity.model?.materials = [SimpleMaterial(color: .blue, isMetallic: true)]
             anchorEntity.addChild(modelEntity)
             view.scene.addAnchor(anchorEntity)
             
             view.installGestures(.all, for: modelEntity)
         }
     }

     */
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
}
