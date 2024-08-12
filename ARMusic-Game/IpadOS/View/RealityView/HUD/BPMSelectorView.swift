//
//  BPMSelectorView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 30/07/24.
//

import SwiftUI
import AudioPackage

struct BPMSelectorView: View {
    @State private var selectedBPM: Double = Double(AudioUtils.shared.BPM)
    @State private var showSlider: Bool = false
    
    let limitedBPM: Double = 150.0

    var body: some View {
        VStack(spacing: 20) {
            if showSlider {
                Slider(value: $selectedBPM, in: 1...limitedBPM, step: 1)
                    .rotationEffect(.degrees(-90))
                    .frame(width: self.screenHeight * 0.3)
                    .padding()
            }
            
            Spacer()
            
            BPMButton(action: {
                withAnimation {
                    showSlider.toggle()
                }
            }, title: "\(Int(selectedBPM)) BPM")
            
        }
        .padding()
        .frame(height: self.screenHeight * 0.32)
        .position(x: self.screenWidth * 0.1, y: self.screenHeight * 0.75)
        .onChange(of: selectedBPM) { oldValue, newValue in
            AudioUtils.shared.BPM = Int(newValue)
        }
    }
}

struct BPMButton: View {
    var action: () -> Void
    var title: String
    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            Text(title)
                .customFont(.metarin, textStyle: .title)
                .bold()
                .foregroundStyle(.primaryPurple)
                .padding(.horizontal, 15)
                .padding(.vertical, 15)
                .shadow(
                    color: Color.black.opacity(0.5),
                    radius: 0.5,
                    x: 1.2,
                    y: 2.97
                )
        }
        .frame(maxWidth: .infinity, minHeight: 50)
        .background(
            Image(.bpmButton)
                .resizable()
                .scaledToFit()
        )
        .scaleEffect(isPressed ? 0.85 : 1.0)
        .animation(.easeInOut(duration: 0.4), value: isPressed)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation {
                        isPressed = false
                    }
                }
        )
    }
}



struct BPMSelectorView_Previews: PreviewProvider {
    static var previews: some View {
        BPMSelectorView()
    }
}
