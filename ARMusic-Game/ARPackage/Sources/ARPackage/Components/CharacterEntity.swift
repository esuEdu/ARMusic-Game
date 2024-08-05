import RealityKit

import AudioPackage

public class CharacterEntity: Entity, HasCollision, HasModel {
    
    public var outline: OutlineComponent! {
        self.components[OutlineComponent.self] as? OutlineComponent
    }
    
    public var audio: AudioComponent? {
        self.components[AudioComponent.self] as? AudioComponent
    }
    
    public required init(mesh: MeshResource, materials: [Material]) {
        super.init()
        
        let boxRadius = mesh.bounds.boundingRadius
        
        let shape: ShapeResource = .generateSphere(radius: boxRadius)
        
        let audioComponent = AudioComponent(note: .d, instrument: .piano, tom: 123.0)
//        let inputComponent = InputComponent()
        let outlineComponent = OutlineComponent()
        
        self.components[ModelComponent.self] = ModelComponent(mesh: mesh, materials: materials)
        self.components.set(CollisionComponent(shapes: [
            shape
        ]))
        components.set(audioComponent)
//        components.set(inputComponent)
        components.set(outlineComponent)
        
        let outlineEntity = OutlineEntity(entity: self)
        addChild(outlineEntity)
    }
    
    required init() {
        
        
        
    }
    
    public static func fromModelEntity(_ modelEntity: ModelEntity) -> CharacterEntity {
    
        
        let mesh = modelEntity.model!.mesh
        let materials = modelEntity.model!.materials
    
        let characterEntity = CharacterEntity(mesh: mesh, materials: materials)
        
        
        return characterEntity
    }
}
