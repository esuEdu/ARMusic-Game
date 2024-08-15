//
//  SwiftUIView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 31/07/24.
//

import SwiftUI
import RealityKit
import ARPackage
import AudioPackage

struct TimeComponent: View {
    let timeText: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack {
            Image("selectPurpleNote")
                .resizable()
                .opacity(isSelected ? 0.5 : 1.0)
                .frame(width: self.screenWidth * 0.079, height: self.screenWidth * 0.140)
                .overlay(
                    RoundedRectangle(cornerRadius: 42)
                        .stroke(Color.black, lineWidth: 2)
                )
                .onTapGesture {
                    action()
                }
            
            Image("noteTime")
                .resizable()
                .frame(width: self.screenWidth * 0.048, height: self.screenWidth * 0.048)
                .overlay(
                    Text(timeText)
                        .foregroundColor(.black)
                        .font(.headline)
                )
                .offset(y: -40)
        }
    }
}

struct NoteTimeSelectionView: View {
    
    @Environment(ARViewManager.self) private var arViewManager: ARViewManager
    
    @State private var tempo: [Int] = []
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<8) { index in
                TimeComponent(
                    timeText: "\(index + 1)/8",
                    isSelected: tempo.contains(index)
                ) {
                    withAnimation {
                        if let removeIndex = tempo.firstIndex(of: index) {
                            tempo.remove(at: removeIndex)
                        } else {
                            tempo.append(index)
                        }
                        
                        arViewManager.changeAudioComponent(tempo: Set(tempo))
                    }
                }
            }
        }.onAppear {
            tempo = arViewManager.getIndiceOfTempo()
        }
        
        .position(x: self.screenWidth * 0.55, y: self.screenHeight * 0.88)
    }
}




