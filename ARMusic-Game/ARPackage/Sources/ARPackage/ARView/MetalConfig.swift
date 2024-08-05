import Metal

public class MetalConfig {
    
    public static var device: MTLDevice!
    public static var library: MTLLibrary!
    
    public static func initialize() {
        guard let maybeDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Error creating default metal device.")
        }
        device = maybeDevice
        guard let maybeLibrary = maybeDevice.makeDefaultLibrary() else {
            fatalError("Error creating default metal library")
        }
        library = maybeLibrary
    }
    
}
