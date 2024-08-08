//
//  LibraryView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Thiago Pereira de Menezes on 08/08/24.
//

import SwiftUI

// representa um CD / Cena
struct CDItem: Identifiable {
    let id = UUID()
    let text: String
    let descricao: String
    var image: String?
}


struct LibraryView: View {
    private var data: [CDItem] = [
        CDItem(text: "Item 1", descricao: "Rock"),
        CDItem(text: "Item 2", descricao: "Filantropia"),
        CDItem(text: "Item 3", descricao: "Estequiometria"),
        CDItem(text: "Item 4", descricao: "Esternocleidomastoide"),
    ]
    
    @State private var searchText: String = ""
    @State private var selectedItemIndex: Int? = nil
    @State private var showModal: Bool = false
    
    var body: some View {
        HStack {
            VStack {
                toolbar
                scroll
            }
            .frame(width: UIScreen.main.bounds.width * 0.6712)
            
            VStack {
                player
            }
            .frame(width: UIScreen.main.bounds.width * 0.323)
            .background(Color.gray)
        }
        .ignoresSafeArea(.all)
        .sheet(isPresented: $showModal) {
            if let index = selectedItemIndex {
                DetailCDModal(item: data[index], isPresented: $showModal)
            }
        }
    }
    
    private var toolbar: some View {
        HStack {
            toolbarButton(imageName: "chevron.left")
                .padding(.leading, 20)
            Spacer()
            searchBar
            Spacer()
            toolbarButton(imageName: "line.horizontal.3.decrease.circle")
                .padding(.trailing, 20)
        }
        .padding(.vertical)
    }
    
    private func toolbarButton(imageName: String) -> some View {
        Circle()
            .frame(width: UIScreen.main.bounds.width * 0.1025, height: UIScreen.main.bounds.height * 0.1367)
            .foregroundColor(.gray)
            .overlay {
                Image(systemName: imageName)
                    .font(.system(size: 32))
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
            }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 8)
            
            TextField("Pesquisar", text: $searchText)
                .padding(8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
        }
    }
    
    private var player: some View {
        VStack {
            moreOptionsButton
            explicationCDText
                .padding(.bottom)
            
            playerCircle
            
            playPauseButton
            
            actionButton(text: "Entrar") {
                showModal = true
            }
        }
        .padding(36)
        .frame(maxHeight: .infinity)
    }
    
    private var moreOptionsButton: some View {
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
    
    private var explicationCDText: some View {
        Rectangle()
            .foregroundColor(.blue)
            .overlay {
                Text(selectedItemIndex != nil ? data[selectedItemIndex!].descricao : "Lorem ipsum dolor sit amet.")
                    .bold()
                    .padding()
                    .font(.caption)
            }
            .frame(width: UIScreen.main.bounds.width * 0.2342, height: UIScreen.main.bounds.height * 0.2416)
    }
    
    private var playerCircle: some View {
        Rectangle()
            .foregroundColor(.green)
            .frame(width: UIScreen.main.bounds.width * 0.2342, height: UIScreen.main.bounds.width * 0.2342)
            .overlay {
                Circle()
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .overlay(
                        Text(selectedItemIndex != nil ? "Índice: \(selectedItemIndex!)" : "Tocador")
                            .foregroundColor(.white)
                    )
            }
    }
    
    private var playPauseButton: some View {
        Circle()
            .frame(maxWidth: UIScreen.main.bounds.width * 0.1)
            .padding(.vertical)
            .foregroundColor(.black)
            .overlay {
                Image(systemName: "pause.fill")
                    .bold()
                    .foregroundColor(.gray)
                    .font(.system(size: 60))
            }
    }
    
    private func actionButton(text: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(text)
                .frame(minWidth: 0, maxWidth: .infinity)
                .font(.system(size: 18))
                .padding()
                .foregroundColor(.white)
        }
        .background(Color.blue)
        .cornerRadius(25)
        .padding(.horizontal, 70)
    }
    
    private var scroll: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: [GridItem(), GridItem()]) {
                ForEach(data.indices, id: \.self) { index in
                    CDItemCell(cdItem: data[index])
                        .onTapGesture {
                            selectedItemIndex = index
                        }
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width * 0.66)
    }
}


#Preview {
    LibraryView()
}
