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
    @Binding var entity: InstrumentEntity?
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<8) { index in
                TimeComponent(
                    timeText: "\(index + 1)/8",
                    isSelected: entity?.instrument.sequence.contains(index) ?? false
                ) {
                    withAnimation {
                        if entity?.instrument.sequence.contains(index) ?? false {
                            entity?.instrument.sequence.remove(index)
                        } else {
                            entity?.instrument.sequence.insert(index)
                        }
                        
                        if let updatedEntity = entity {
                            instrumentSystem.setSequence(for: updatedEntity)
                        }
                    }
                }
            }
        }
        .position(x: self.screenWidth * 0.55, y: self.screenHeight * 0.88)
    }
}




