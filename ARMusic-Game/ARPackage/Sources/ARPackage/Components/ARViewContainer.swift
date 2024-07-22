import SwiftUI
import ARKit
import RealityKit

public struct ARViewContainer: UIViewRepresentable {
    
    var view: ARView!
    
    public init() {
     
    }
    
    public func makeUIView(context: Context) -> ARView {
        let view = MainARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
            config.planeDetection = [.horizontal,.vertical]
            config.environmentTexturing = .automatic
            view.session.run(config)
            
            // Adding the coaching overlay on the AR View
            view.addCoaching()

        return view
    }
    
    public func updateUIView(_ uiView: ARView, context: Context) {
        
    }
    
    public typealias UIViewType = ARView
}
