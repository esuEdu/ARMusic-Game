//
//  DefailCDModal.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Thiago Pereira de Menezes on 08/08/24.
//

import SwiftUI

// modal q aparece na view LibraryView
struct DetailCDModal: View {
    var item: CDItem
    @Binding var isPresented: Bool
    
    var body: some View {
        VStack {
            modalHeader
            modalImage
            Spacer()
            Text("Nome do disco: \(item.text)")
                .font(.largeTitle)
                .bold()
            Spacer()
        }
    }
    
    private var modalHeader: some View {
        HStack {
            modalButton(text: "Cancelar") {
                isPresented.toggle()
            }
            Spacer()
            modalButton(text: "Salvar") {
                // Adicione a ação de salvar aqui
            }
        }
        .padding(24)
    }
    
    private var modalImage: some View {
        VStack {
            Image(systemName: item.image ?? "photo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding()
            
            Button("Alterar Imagem") {
                // Ação para alterar a imagem
            }
            .padding()
            .foregroundColor(.blue)
        }
    }
    
    private func modalButton(text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text)
                .frame(minWidth: 0, maxWidth: 60)
                .font(.system(size: 18))
                .padding()
                .foregroundColor(.white)
        }
        .background(Color.blue)
        .cornerRadius(25)
    }
}

#Preview {
    DetailCDModal(item: CDItem(text: "Mamonas assacinas", descricao: "Alelek", image: "pencil.fill"), isPresented: .constant(true))
}
