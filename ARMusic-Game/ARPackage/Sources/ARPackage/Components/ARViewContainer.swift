import SwiftUI
import ARKit
import RealityKit

public struct ARViewContainer: UIViewRepresentable {
    
    var view: ARView!
    
    public init() {
     
    }
    
    public func makeUIView(context: Context) -> ARView {
        let view = MainARView(frame: .zero)
        
        return view
    }
    
    public func updateUIView(_ uiView: ARView, context: Context) {
        
    }
    
    public typealias UIViewType = ARView
}
