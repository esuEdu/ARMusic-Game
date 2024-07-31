import RealityKit
import ARKit

public class WorldSystem: System {
    
    static var BPM: Int = 120
    static var currentBar: Int = 0
    static var currentNote: Int = 0
    static var currTime: TimeInterval = 0
    public static var worldSettings: ARSettings!

    
    required public init(scene: Scene) {
        
    }
    
    public func update(context: SceneUpdateContext) {
        WorldSystem.currTime += context.deltaTime
        
        
    }
}
