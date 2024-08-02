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
            RoundedRectangle(cornerRadius: 42)
                .fill(isSelected ? Color.blue : Color.white)
                .frame(width: self.screenWidth * 0.079, height: self.screenWidth * 0.140)
                .overlay(
                    RoundedRectangle(cornerRadius: 42)
                        .stroke(Color.black, lineWidth: 2)
                )
                .onTapGesture {
                    action()
                }
            
            Circle()
                .fill(Color.gray)
                .frame(width: self.screenWidth * 0.048, height: self.screenWidth * 0.048)
                .overlay(
                    Text(timeText)
                        .foregroundColor(.white)
                        .font(.headline)
                )
                .offset(y: -40)
        }
    }
}

struct NoteTimeSelectionView: View {
    @Environment(InstrumentSystem.self) var instrumentSystem: InstrumentSystem
    @Binding var entity: Entity?
    @State private var tempo: Set<Int> = []
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<8) { index in
                TimeComponent(
                    timeText: "\(index + 1)/8",
                    isSelected: tempo.contains(index)
                ) {
                    withAnimation {
                        if tempo.contains(index) {
                            tempo.remove(index)
                        } else {
                            tempo.insert(index)
                        }
                        
                        if let updatedEntity = entity {
                            instrumentSystem.changeEntity(for: updatedEntity, tempos: tempo)
                        }
                    }
                }
            }
        }
        .position(x: self.screenWidth * 0.55, y: self.screenHeight * 0.88)
        .onChange(of: entity) { _,newEntity in
            
            if let audioComponent = newEntity?.components[AudioComponent.self] as? AudioComponent {
                let arrayBool = audioComponent.tempo.getArray()
                
                tempo = []
                
                for (index, value) in arrayBool.enumerated() {
                    if value {
                        tempo.insert(index)
                    }
                }
            }
            
        }
    }
}




