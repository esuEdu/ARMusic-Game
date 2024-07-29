import RealityKit
import ARKit

class WorldSystem: System {
    
    static var BPM: Int = 120
    static var currentBar: Int = 0
    static var currentNote: Int = 0
    static var currTime: TimeInterval = 0
    
    
    required init(scene: Scene) {
        
    }
    
    func update(context: SceneUpdateContext) {
        WorldSystem.currTime += context.deltaTime
        
        
    }
}
