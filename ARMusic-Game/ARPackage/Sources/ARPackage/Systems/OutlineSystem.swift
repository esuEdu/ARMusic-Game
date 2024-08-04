import RealityKit
import ARKit

public struct OutlineComponent: Component {
    
    
    var isOutlined = false
    
}

public class OutlineEntity: Entity, HasModel {
    
    var device: MTLDevice?
    var library: MTLLibrary?
    
    required init(entity: HasModel) {
        super.init()
        setupDevice()
        
        let material = SimpleMaterial(color: .black, isMetallic: false)
        
        let geometryShader = CustomMaterial.GeometryModifier(named: "OutlineGeometryShader", in: library!)
        let surfaceShader = CustomMaterial.SurfaceShader(named: "OutlineSurfaceShader", in: library!)
        
        var customMaterial = try! CustomMaterial(from: material, surfaceShader: surfaceShader, geometryModifier: geometryShader)
        customMaterial.faceCulling = .front
        
        let materials = entity.model!.materials.map { material in
            customMaterial
        }

        
        let modelComponent = ModelComponent(mesh: entity.model!.mesh, materials: materials)
        components.set(modelComponent)
        
    }
    
    private func setupDevice() {
        
        guard let maybeDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Error creating default metal device.")
        }
        device = maybeDevice
        guard let maybeLibrary = maybeDevice.makeDefaultLibrary() else {
            fatalError("Error creating default metal library")
        }
        library = maybeLibrary
    }
    
    required init() {
       
    }
    
    
    
}

public class OutlineSystem: System {
    public required init(scene: Scene) {
        
    }
    
    
    let query = EntityQuery(where: .has(OutlineComponent.self))
    
    public func update(context: SceneUpdateContext) {
        
        let withOutlineComp = context.scene.performQuery(query)
        
        for entity in withOutlineComp {
            
            if let entity = entity as? CharacterEntity {
                
                if entity.outline.isOutlined {
                    
                    
                    
                    
                } else {
                    
                }
                
                
                
            }
            
        }
        
        
    }
    
}
