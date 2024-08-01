import SwiftUI
import SceneKit
import CoreMotion
import ARKit

struct StartView: View {
    
    @ObservedObject var managerMotion = MotionManager()
    @State var scene: SCNScene? = .init(named: "pancakes.usdz")
    
    @State var motion: CMDeviceMotion? = nil
    let motionManager = CMMotionManager()
    let thresholdPitch: Double = 35 * .pi / 180
    let maxRotationAngle = 20.0
    let maxRotationX = 20.0 // Limite para rotação em torno do eixo X
    let maxRotationY = 20.0 // Limite para rotação em torno do eixo Y
    
    var rotation: (x: Double, y: Double) {
        guard let motion = motion else {
            return (x: 0, y: 0)
        }
        
        let interfaceOrientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
        
        switch interfaceOrientation {
        case .landscapeLeft:
            let pitchDegrees = min(maxRotationX, max(-maxRotationX, motion.attitude.pitch * 180 / .pi))
            let yawDegrees = min(maxRotationY, max(-maxRotationY, motion.attitude.yaw * 180 / .pi))
            return (x: pitchDegrees, y: yawDegrees)
        case .landscapeRight:
            let pitchDegrees = min(maxRotationX, max(-maxRotationX, -motion.attitude.pitch * 180 / .pi))
            let yawDegrees = min(maxRotationY, max(-maxRotationY, -motion.attitude.yaw * 180 / .pi))
            return (x: pitchDegrees, y: yawDegrees)
        default:
            return (x: 0, y: 0)
        }
    }
    
    var body: some View {
        
        ZStack {
            HStack {
                VStack {
                    btn()
                    
                    btn()
                }
                .padding(20)
                
                ZStack {
                    if scene != nil {
                        Custom3DView(scene: $scene, rotation: rotation)
                            .rotation3DEffect(.init(degrees: rotation.y), axis: (x: 0.0, y: 1.0, z: 0.0))
                            .rotation3DEffect(.init(degrees: rotation.x), axis: (x: 1.0, y: 0.0, z: 0.0))
                    } else {
                        Text("Cadeira não encontrada")
                            .foregroundColor(.red)
                    }
                }
                .onAppear {
                    if motionManager.isDeviceMotionAvailable {
                        self.motionManager.deviceMotionUpdateInterval = 1.0 / 60.0
                        self.motionManager.startDeviceMotionUpdates(to: OperationQueue.main) { (data, error) in
                            
                            if let validData = data {
                                self.motion = validData
                            }
                            
                        }
                    }
                }
            }
            .padding()
            .background {
                Image("background")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.size.height * 3.0)
                    .frame(height: UIScreen.main.bounds.size.height * 3.0)
                    .offset(x: managerMotion.roll * 100, y: managerMotion.pitch * 100)
                    .onAppear {
                        managerMotion.startMonitoringMotionUpdates()
                    }
            }
        }
    }
    
    func btn() -> some View {
        RoundedRectangle(cornerRadius: 25.0)
            .foregroundStyle(.pink)
            .overlay {
                Text("text")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.blue)
            }
            .onTapGesture {
                print("clicked")
            }
    }
}

#Preview {
    StartView()
}

struct Custom3DView: UIViewRepresentable {
    
    @Binding var scene: SCNScene?
    var rotation: (x: Double, y: Double)
    
    func makeUIView(context: Context) -> some UIView {
        let view = SCNView()
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.backgroundColor = .clear
        
        if let scene = scene {
            view.scene = scene
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let scene = scene else { return }
        
        let scnView = uiView as! SCNView
        if scnView.scene == nil {
            scnView.scene = scene
        }
        
        let chairNode = scene.rootNode.childNodes.first
        chairNode?.eulerAngles.x = Float(rotation.x * .pi / 180)
        chairNode?.eulerAngles.y = Float(rotation.y * .pi / 180)
        
        print("x: \(chairNode?.eulerAngles.x ?? 0)")
        print("y: \(chairNode?.eulerAngles.y ?? 0)")
    }
}
 
