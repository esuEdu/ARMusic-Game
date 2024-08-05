import RealityKit
import ARKit

public struct OutlineComponent: Component {
    var isOutlined = false
}

public class OutlineEntity: Entity, HasModel {

    
    required init(entity: HasModel) {
        super.init()
   
        guard let model = entity.model else {
            fatalError("Entity has no model")
        }
        
        name = "outline_entity"
        
        
        let material = SimpleMaterial(color: .black, isMetallic: false)
        
        let geometryShader = CustomMaterial.GeometryModifier(named: "OutlineGeometryShader", in: MetalConfig.library)
        let surfaceShader = CustomMaterial.SurfaceShader(named: "OutlineSurfaceShader", in: MetalConfig.library)
        
        var customMaterial = try! CustomMaterial(from: material, surfaceShader: surfaceShader, geometryModifier: geometryShader)
        customMaterial.faceCulling = .front
        let materials = model.materials.map { _ in
            customMaterial
        }
        
        let modelComponent = ModelComponent(mesh: model.mesh, materials: materials)
        components.set(modelComponent)
        
        self.model = modelComponent
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
            
            let comp = entity.components[OutlineComponent.self] as! OutlineComponent
            
            let outlineEntity = entity.findEntity(named: "outline_entity")
            
            outlineEntity?.isEnabled = comp.isOutlined
        }
        
        
    }
    
}
