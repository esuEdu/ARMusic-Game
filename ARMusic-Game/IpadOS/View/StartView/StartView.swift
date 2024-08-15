import SwiftUI
import SceneKit
import CoreMotion
import DataPackage
import ARKit

struct StartView: View {
    
    @State private var currentHue: Double = 0
    @ObservedObject var managerMotion = MotionManager()
    @State var scene: SCNScene? = .init(named: "pancakes.usdz")
    @State var motion: CMDeviceMotion? = nil
    @State private var isLoading = false
    @State private var navigateToRealityView = false
    @State private var navigateToLibraryView = false
    
    let motionManager = CMMotionManager()
    let thresholdPitch: Double = 35 * .pi / 180
    let maxRotationAngle = 20.0
    let maxRotationX = 20.0 // Limite para rotação em torno do eixo X
    let maxRotationY = 20.0 // Limite para rotação em torno do eixo Y
    
    let date = Date()
    
    var rotation: (x: Double, y: Double) {
        guard let motion = motion else {
            return (x: 0, y: 0)
        }
        
        let interfaceOrientation = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.interfaceOrientation
        
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
        NavigationStack {
            TimelineView(.animation) { context in
                ZStack {
                    HStack {
                        VStack {
                            PrimaryButton(action: {
                                isLoading = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    isLoading = false
                                    navigateToRealityView = true
                                }
                            }, title: "Criar")

                            PrimaryButton(action: {
                                navigateToLibraryView = true
                            }, title: "Ir para a LibraryView")
                        }
                        
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
                            Task {
                                if let modelURL = ModelData(instrument: .piano).getURL() {
                                    scene = try? .init(url: modelURL)
                                }
                            }
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
                            .colorEffect(ShaderLibrary.default.boise(.boundingRect, .float(date.timeIntervalSinceNow)))
                            .offset(x: managerMotion.roll * 100, y: managerMotion.pitch * 100)
                            .onAppear {
                                managerMotion.startMonitoringMotionUpdates()
                            }
                    }
                    
                    if isLoading {
                        Color.black.opacity(0.5)
                            .edgesIgnoringSafeArea(.all)
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .foregroundColor(.white)
                            .font(.largeTitle)
                    }
                    
                    NavigationLink(
                        destination: RealityView(),
                        isActive: $navigateToRealityView
                    ) {
                        EmptyView()
                    }

                    NavigationLink(
                        destination: LibraryView(),
                        isActive: $navigateToLibraryView
                    ) {
                        EmptyView()
                    }
                }
            }
        }
    }
    
    func waveGradient() -> LinearGradient {
        var a = (sin(date.timeIntervalSinceNow * 0.1) + 1.0) / 2.0
        
        return LinearGradient(gradient: Gradient(colors: [Color(hue: a, saturation: 1.0, brightness: 1.0), Color(hue: a + 0.1, saturation: 1.0, brightness: 1.0)]), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    func updateColor() {
        currentHue += 0.0001 // Adjust the rate of color change here
        if currentHue >= 1.0 {
            currentHue = 0.0
        }
    }
}

#Preview {
    StartView()
}
