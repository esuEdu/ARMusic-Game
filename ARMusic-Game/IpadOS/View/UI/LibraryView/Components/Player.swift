//
//  Player.swift
//  ImageParallax
//
//  Created by Thiago Pereira de Menezes on 12/08/24.
//

import SwiftUI

/// View que representa a interface do player
struct PlayerView: View {
    @Binding var selectedItem: CDItem?
    @Binding var showModal: Bool
    
    let cdExplicationTextWidth: CGFloat = 0.2342
    let cdExplicationTextHeight: CGFloat = 0.2416
    
    var body: some View {
        VStack {
            moreOptionsButton
            cdExplanationText
                .padding(.bottom)
            PlayerCircle(selectedItem: $selectedItem)
            playPauseButton
            actionButton(text: "Entrar", action: {
                showModal = true
            })
        }
        .padding(36)
        .frame(maxHeight: .infinity)
        .background(.purple)
    }
    
    // MARK: Componentes da UI
    /// Botão para mais opções.
    var moreOptionsButton: some View {
        HStack {
            Spacer()
            Circle()
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: "ellipsis")
                        .bold()
                        .foregroundColor(.white)
                }
        }
    }
    
    /// Texto explicativo do item selecionado.
    var cdExplanationText: some View {
        Rectangle()
            .foregroundColor(.blue)
            .overlay {
                Text(selectedItem?.descricao ?? "Lorem ipsum dolor sit amet.")
                    .bold()
                    .padding()
                    .font(.caption)
            }
            .frame(width: UIScreen.screenWidth * cdExplicationTextWidth,
                   height: UIScreen.screenHeight * cdExplicationTextHeight)
    }
    
    /// Botão de reprodução/pausa.
    var playPauseButton: some View {
        Circle()
            .frame(maxWidth: UIScreen.screenWidth * 0.1)
            .padding(.vertical)
            .foregroundColor(.black)
            .overlay {
                Image(systemName: "pause.fill")
                    .bold()
                    .foregroundColor(Color(red: 88/255, green: 86/255, blue: 86/255))
                    .font(.system(size: 60))
            }
            .onTapGesture {
                reproducaoPausa()
            }
    }
    
    func actionButton(text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text)
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(.system(size: 18))
                .padding()
                .foregroundColor(.black)
                .bold()
        }
        .background(Color(red: 217/255, green: 217/255, blue: 217/255))
        .cornerRadius(25)
        .padding(.horizontal, 70)
    }
    
    func reproducaoPausa() {
        // Função de reprodução/pausa
    }
}

#Preview {
    PlayerView(selectedItem: .constant(CDItem(text: "object", descricao: "object descricao")), showModal: .constant(true))
}
