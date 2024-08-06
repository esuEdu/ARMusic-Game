//
//  PauseModalView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 05/08/24.
//

import SwiftUI
import AudioPackage
import ARPackage

struct PauseModalView: View {
    @Binding var isPresented: Bool
    @State private var isMuted = false
    @Environment(ARViewManager.self) private var arViewManager: ARViewManager
    
    var body: some View {
            ZStack {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                
                ZStack {
                    VStack(spacing: 20) {
                        ButtonPauseView(title: "Continuar", action: {})
                        ButtonPauseView(title: isMuted ? "Desmutar" : "Mutar", action: toggleMute)
                        ButtonPauseView(title: "Sair", action: {})
                    }
                    .frame(width: screenWidth * 0.5, height: screenHeight * 0.6)
                    .padding()
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 2)
                    )
                    .shadow(radius: 10)
                    
                    VStack {
                        HStack{
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    isPresented.toggle()
                                }
                            }) {
                                Image(systemName: "xmark")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundStyle(.black)
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .overlay(
                                        Circle()
                                            .stroke(Color.black, lineWidth: 8)
                                    )
                            }
                            .offset(x: 32, y: 20)
                        }
                        Spacer()
                    }
                    .frame(width: screenWidth * 0.5)
                }
                .padding()
            }
        }
    
    private func toggleMute() {
        isMuted.toggle()
        
        if isMuted {
            AudioTimerManager.shared.pause()

            return
        }
        
        AudioTimerManager.shared.start()
    }
}



