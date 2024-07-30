//
//  StartView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Thiago Pereira de Menezes on 30/07/24.
//

import SwiftUI
import SceneKit

struct StartView: View {
    
    @ObservedObject var motionManager = MotionManager()
    @State var scene: SCNScene? = .init(named: "chair_swan.usdz")
    
    var body: some View {
        HStack {
            VStack {
                btn()
                
                btn()
            }
            .padding(20)
 
//            Image("legoLogo")
            Custom3DView(scene: $scene)
                
        }
        .padding()
        .background {
            Image("background")
                .resizable()
                .frame(width: UIScreen.main.bounds.size.height * 3.0)
                .frame(height: UIScreen.main.bounds.size.height * 3.0)
                .offset(x: motionManager.roll * 100, y: motionManager.pitch * 100)
                .onAppear {
                    motionManager.startMonitoringMotionUpdates()
                }



        }
    }
    
    func btn() -> some View {        RoundedRectangle(cornerRadius: 25.0)
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
    
    func makeUIView(context: Context) -> some UIView {
        let view = SCNView()
        view.allowsCameraControl = false
        view.autoenablesDefaultLighting = true
        view.antialiasingMode = .multisampling2X
        view.scene = scene
        view.backgroundColor = .clear
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
