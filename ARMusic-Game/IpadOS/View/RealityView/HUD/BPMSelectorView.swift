//
//  BPMSelectorView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 30/07/24.
//

import SwiftUI

struct BPMSelectorView: View {
    @State private var selectedBPM: Double = 150.0
    @State private var showSlider: Bool = false
    
    let limitedBPM: Double = 300.0

    var body: some View {
        VStack(spacing: 20) {
            if showSlider {
                Slider(value: $selectedBPM, in: 1...limitedBPM, step: 1)
                    .rotationEffect(.degrees(-90))
                    .frame(width: self.screenHeight * 0.3)
                    .padding()
            }
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    showSlider.toggle()
                }
            }) {
                Text("\(Int(selectedBPM)) BPM")
                    .font(.headline)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .frame(height: self.screenHeight * 0.32)
        .position(x: self.screenWidth * 0.1, y: self.screenHeight * 0.75)
    }
}

struct BPMSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        BPMSelectorView()
    }
}

