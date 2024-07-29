import ARKit
import RealityKit

class MainARView: ARView, ARSessionDelegate {
    
    var arView: ARView {
        return self
    }
    
    var box: ModelEntity!
    
    
    
    required init(frame frameRect: CGRect) {
        super.init(frame: frameRect)
        arView.session.delegate = self
        arView.automaticallyConfigureSession = true
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        configuration.environmentTexturing = .automatic
    
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError("Error creating default metal device.")
        }
        
        // Get a reference to the Metal library.
        let library = device.makeDefaultLibrary()!
        
        let surfaceShader = CustomMaterial.SurfaceShader(named: "mySurfaceShader", in: library)
        
        let geometryShader = CustomMaterial.GeometryModifier(named: "simpleGeometryModifier", in: library)
        
        let customMaterial = try! CustomMaterial(surfaceShader: surfaceShader, geometryModifier: geometryShader, lightingModel: .lit)
        
        let box = ModelEntity(mesh: .generateSphere(radius: 0.1), materials: [customMaterial])
        
        self.box = box
        
        arView.addCoaching() 
        
        arView.session.run(configuration, options: [])
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                          action: #selector(handleTap(_:)))
        
       
        
        arView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        var planeMesh: MeshResource
        var color: UIColor
        
        for anchor in anchors {
           
           
            if let anchor = anchor as? ARPlaneAnchor {
                if anchor.alignment == .horizontal {
                    print("horizotal plane")
                    color = UIColor.black
                    planeMesh = .generatePlane(width: anchor.extent.x, depth: anchor.extent.z)
                } else if anchor.alignment == .vertical {
                    print("vertical plane")
                    color = UIColor.yellow.withAlphaComponent(0.5)
                    planeMesh = .generatePlane(width: anchor.extent.x, height: anchor.extent.z)
                } else {
                    fatalError("Anchor is not ARPlaneAnchor")
                }
                
                let entity = ModelEntity(mesh: planeMesh, materials: [
                SimpleMaterial(color: color, isMetallic: true)])
                
                let newAnchor = AnchorEntity(plane: .any, classification: [.any], minimumBounds: [0.5, 0.5])
                
                newAnchor.addChild(entity)
                
                arView.scene.addAnchor(newAnchor)
            }
            
           
        }
        
       
        
        
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
