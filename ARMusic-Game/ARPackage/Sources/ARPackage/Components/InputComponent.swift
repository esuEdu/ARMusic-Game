import RealityKit
import SwiftUI



public struct InputComponent: Component {
    
    var callbacks: [String : (_ gesture: UIGestureRecognizer) -> Void] = [:];
    
    public func run(gesture: UIGestureRecognizer) {
        let callback = callbacks.first { (key: String, value: (_ gesture: UIGestureRecognizer) -> Void) in
            let string = String(describing: type(of: gesture))
          
            return key == string
        }
        
        callback?.value(gesture)
    }
    

    
    public mutating func addGestureFunc<GestureT: UIGestureRecognizer>(gesture: GestureT.Type, callback: @escaping (_ gesture: GestureT) -> Void) {
        
        let string = String(describing: gesture)
        
        callbacks[string] = { currGesture in
            callback(currGesture as! GestureT)
        }
    }
    
}
