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
    let cdExplicationTextHeight: CGFloat = 0.16
    
    var body: some View {
        VStack {
            moreOptionsButton
                .padding(.horizontal, 36)
                .padding(.top)

            cdExplanationText
            PlayerCircle(selectedItem: $selectedItem)
            playPauseButton
//            actionButton(text: "Entrar", action: {
//                showModal = true
//            })
            ActionButton(action: {
                showModal = true
            }, title: "Entrar")
        }
//        .padding(36)
//        .frame(maxHeight: .infinity)
//        .background(.black.opacity(0.4))
        .background(
            Image("backgroundBorrado")
                .resizable()
                .opacity(0.8)
                .frame(minHeight: UIScreen.screenHeight * 1.25)
                .frame(minWidth: UIScreen.screenWidth * 0.37)
        )
    }
    
    // MARK: Componentes da UI
    /// Botão para mais opções.
    var moreOptionsButton: some View {
        Button {
            
        } label: {
            HStack {
                Spacer()
                Circle()
                    .frame(width: 50, height: 50)
                    .overlay {
                        Image("threePointsBtn")
                    }
            }
        }
    }
    
    /// Texto explicativo do item selecionado.
    var cdExplanationText: some View {
        
            HStack {
                Text(selectedItem?.descricao ?? "Lorem ipsum dolor sit amet, consectetur adipiscing alit, sed do eiusmod tempor.")
                    .bold()
                    .padding()
                    .font(.system(size: 24.0))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.white)
                    .fontDesign(.rounded)
            }
            .frame(width: UIScreen.screenWidth * cdExplicationTextWidth,
                   height: UIScreen.screenHeight * cdExplicationTextHeight)
    }
    
    /// Botão de reprodução/pausa.
    var playPauseButton: some View {
        Button {
            reproducaoPausa()
        } label: {
            Image("backgroundPurpleRoundedBtn")
                .frame(maxWidth: UIScreen.screenWidth * 0.1)
    //            .padding(.vertical)
                .foregroundColor(.black)
                .overlay {
                    Image("playIconBtn")
                }
        }
    }
    
    struct ActionButton: View {
        
        var action: () -> Void
        var title: String
        @State private var isPressed = false
        
        var body: some View {
            Button(action: action) {
                ZStack{
                    Image("entrarBtnCompleto")
                        .resizable()
                        .scaledToFill()
                    
//                    Text(title)
//                        .customFont(.metarin, textStyle: .title)
//                        .bold()
//                        .foregroundStyle(.primaryPurple)
//                        .padding(.horizontal, 15)
//                        .padding(.vertical, 15)
//                        .shadow(
//                            color: Color.black.opacity(0.5),
//                            radius: 0.5,
//                            x: 1.2,
//                            y: 2.97
//                        )
                }
                .frame(maxWidth: .infinity)

            }
//            .frame(maxWidth: 573, minHeight: 50)
            .frame(maxWidth: .infinity)
            .scaleEffect(isPressed ? 0.85 : 1.0)
            .animation(.easeInOut(duration: 0.4), value: isPressed)

        }
        
        
    }
    
    func reproducaoPausa() {
        // Função de reprodução/pausa
    }
    
    struct PrimaryButton2: View {
        var action: () -> Void
        var title: String
        @State private var isPressed = false

        var body: some View {
            Button(action: action) {
                ZStack{
                    Image(.primaryButton)
                        .resizable()
                        .scaledToFit()
                    
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
            }
            .frame(maxWidth: 573, minHeight: 50)
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
}

//#Preview {
//    PlayerView(selectedItem: .constant(CDItem(text: "object", descricao: "object descricao")), showModal: .constant(true))
//}

#Preview {
    LibraryView()
}



