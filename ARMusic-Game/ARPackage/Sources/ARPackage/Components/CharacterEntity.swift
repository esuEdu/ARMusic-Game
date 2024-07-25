import ARKit
import RealityKit
import UIKit

public class CharacterEntity: Entity, HasCollision {
    
    public required init() {
        super.init()
        let sphere: MeshResource = .generateSphere(radius: 0.1)
        let material: SimpleMaterial = .init(color: .red, isMetallic: false)
        
        self.components.set(CollisionComponent(shapes: [
            .generateSphere(radius: 0.1)
        ]))
        
        self.components[ModelComponent.self] = ModelComponent(mesh: sphere, materials: [material])
    }
}
