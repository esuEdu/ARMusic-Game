//
//  DetailCDModel.swift
//  ImageParallax
//
//  Created by Thiago Pereira de Menezes on 09/08/24.
//
//
import SwiftUI

struct DetailCDModalView: View {
    var item: CDItem
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            // Fundo transparente que fecha a modal ao clicar fora dela
//            Color.black.opacity(0.4)
//                .edgesIgnoringSafeArea(.all)
//                .onTapGesture {
//                    withAnimation(.easeInOut) {
//                        isPresented = false
//                    }
//                }

            VStack {
                // Background transparente da modal
                Image("modalBackground")
                    .resizable()
                    .scaledToFit()
                    .overlay {
                        VStack {
//                            header
                            modalImage
                            
                            Image("backgroundTextFieldModalDetailDisco")
                                .overlay {
                                    Text(" \(item.text)")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .bold()
                                }
                            
                            Button {
                                
                            } label: {
                                Image("btnCompletoSalvar")
                            }
                        }
                    }
                    .overlay(alignment: .topTrailing) {
                        Button {
                            withAnimation(.easeInOut) {
                                self.isPresented.toggle()
                            }

                        }label: {
                            Image("btnCancelar")
                        }
                    }

            }
            .background(Color.clear) // Fundo da modal transparente
            .cornerRadius(20)
            .padding(20)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .animation(.easeInOut(duration: 0.3))
            .frame(maxWidth: .infinity)
                    }
    }
    
    var header: some View {
        HStack {
            modalButton(text: "Cancelar") {
                withAnimation(.easeInOut) {
                    self.isPresented.toggle()
                }
            }
            Spacer()
            modalButton(text: "Salvar") {
                // Ação de salvar
            }
        }
        .padding(24)
    }
    
    var modalImage: some View {
        VStack {
            Image("capaDisco")
                .resizable()
                .scaledToFit()
                .frame(width: 250, height: 250)
                .padding()
                .foregroundStyle(.red)
            
            Button {
                
            } label: {
                Image("buttonInteiroAlterarImagem")
            }
        }
    }
    
    func modalButton(text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text)
                .frame(maxWidth: 60)
                .font(.system(size: 18))
                .padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .cornerRadius(25)
        }
    }
}

#Preview {
    LibraryView()
}
