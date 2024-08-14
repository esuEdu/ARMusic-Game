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
        VStack {
            header
            modalImage
            Spacer()
            Text("Nome do disco: \(item.text)")
                .font(.largeTitle)
                .bold()
            Spacer()
        }
    }
    
    var header: some View {
        HStack {
            modalButton(text: "Cancelar") {
                self.isPresented.toggle()
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
            Image(systemName: item.image ?? "heart.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .padding()
                .foregroundStyle(.red)

            Button("Alterar Imagem") {
                // Ação para alterar a imagem
            }
            .padding()
            .foregroundColor(.blue)
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
