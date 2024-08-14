//
//  Toolbar.swift
//  ImageParallax
//
//  Created by Thiago Pereira de Menezes on 12/08/24.
//

import SwiftUI

// MARK: - Toolbar
struct Toolbar: View {
    @Binding var searchText: String
    
    let toolbarButtonWeight: CGFloat = UIScreen.screenWidth * 0.1025
    let toolbarButtonHeigth: CGFloat = UIScreen.screenHeight * 0.1367
    
    var body: some View {
        HStack {
            circleButton(imageName: "chevron.left", action: {})
                .padding(.leading, 20)
            Spacer()
            SearchBar(searchText: $searchText)
            Spacer()
            circleButton(imageName: "line.horizontal.3.decrease.circle", action: {})
                .padding(.trailing, 20)
        }
        .padding(.vertical)
    }
    
    func circleButton(imageName: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Circle()
                .frame(width: toolbarButtonWeight,
                       height: toolbarButtonHeigth)
                .foregroundColor(.gray)
                .overlay {
                    Image(systemName: imageName)
                        .font(.system(size: 32))
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
        }
    }
    
    struct SearchBar: View {
        @Binding var searchText: String
        
        var body: some View {
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
    }
}

#Preview {
    Toolbar(searchText: .constant("aaaa lelek"))
}
