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
    
    @State private var sliderValue: Double = 50
    let sliderRange: ClosedRange<Double> = 0...200
    
    let limitedBPM: Double = 150.0

    var body: some View {
        VStack(spacing: 20) {
            if showSlider {
                CustomSlider(
                            value: $selectedBPM,
                            range: sliderRange,
                            trackImage: "back",
                            progressImage: "barraP",
                            thumbImage: "circuloP"
                        )
                .rotationEffect(.degrees(-90))
                .frame(width: self.screenHeight * 0.3)
                .offset(y: -14)
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
        .position(x: self.screenWidth * 0.2, y: self.screenHeight * 0.75)
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
        .background(
            Image(.bpmButton)
                .resizable()
                .scaledToFill()
                .frame(width: self.screenWidth * 0.32, height: self.screenHeight * 0.155)
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

struct CustomSlider: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let trackImage: String
    let progressImage: String
    let thumbImage: String
    
    private func thumbOffset(geometry: GeometryProxy) -> CGFloat {
        let percentage = (value - range.lowerBound) / (range.upperBound - range.lowerBound)
        return percentage * (geometry.size.width - 30) // Ajuste 30 para o tamanho do thumb
    }
    
    private func updateValue(from gesture: DragGesture.Value, in geometry: GeometryProxy) {
        let percentage = gesture.location.x / (geometry.size.width - 30)
        value = range.lowerBound + percentage * (range.upperBound - range.lowerBound)
        value = min(max(value, range.lowerBound), range.upperBound)
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Barra de fundo
                Image(self.trackImage)
                    .resizable()
                    .frame(width: geometry.size.width, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // Barra que vai por cima
                Image(self.progressImage)
                    .resizable()
                    .frame(width: thumbOffset(geometry: geometry) + 30, height: 30)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // Círculo de arrastar
                Image(self.thumbImage)
                    .resizable()
                    .frame(width: 55, height: 55)
                    .offset(x: self.thumbOffset(geometry: geometry))
                    .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                self.updateValue(from: gesture, in: geometry)
                            }
                    )
            }
        }
        .frame(height: 50)
    }
}
