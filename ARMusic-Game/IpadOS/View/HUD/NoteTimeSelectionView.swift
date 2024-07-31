//
//  SwiftUIView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 31/07/24.
//

import SwiftUI

struct TimeComponent: View {
    let timeText: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 42)
                .fill(isSelected ? Color.blue : Color.white)
                .frame(width: 112, height: 194)
                .overlay(
                    RoundedRectangle(cornerRadius: 42)
                        .stroke(Color.black, lineWidth: 2)
                )
                .onTapGesture {
                    action()
                }
            
            Circle()
                .fill(Color.gray)
                .frame(width: 50, height: 50)
                .overlay(
                    Text(timeText)
                        .foregroundColor(.white)
                        .font(.headline)
                )
                .offset(y: -35)
        }
    }
}

struct NoteTimeSelectionView: View {
    @State private var selectedTimes: [Bool] = Array(repeating: false, count: 8)
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(0..<8) { index in
                TimeComponent(timeText: "\(index + 1)/8", isSelected: selectedTimes[index]) {
                    withAnimation {
                        selectedTimes[index].toggle()
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    NoteTimeSelectionView()
}

