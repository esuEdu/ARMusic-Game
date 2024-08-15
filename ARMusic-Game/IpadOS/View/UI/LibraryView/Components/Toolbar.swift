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
            circleButton(image: "backButton", action: {})
                .padding(.leading, 20)
            SearchBar(searchText: $searchText)
                .padding(.horizontal, 40)
            circleButton(image: "filterButton", action: {})
                .padding(.trailing, 20)
        }
        .padding(.vertical)
    }
        
    private func circleButton(image: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image("backgroundPurpleRoundedBtn")
                .frame(width: toolbarButtonWeight,
                       height: toolbarButtonHeigth)
                .foregroundColor(.gray)
                .overlay {
                    Image(image)
                        .font(.system(size: 32))
                        .fontWeight(.heavy)
                        .foregroundColor(.black)
                }
        }
    }

    struct SearchBar: View {
        let searchBarHeigth: CGFloat = UIScreen.screenHeight * 0.13
        @Binding var searchText: String
        
        var body: some View {
//            HStack {
//                RoundedRectangle(cornerRadius: .infinity)
//                    .foregroundColor(.primaryPurple)
//                    .shadow(color: .black.opacity(0.8), radius: 10, x: 0, y: 0)
//                    .clipShape(RoundedRectangle(cornerRadius: .infinity))
//                    .overlay(
//                        RoundedRectangle(cornerRadius: .infinity)
//                            .stroke(Color.black, lineWidth: 2)
//                            .shadow(color: .black.opacity(0.8), radius: 10, x: 0, y: 0)
//                            .clipShape(RoundedRectangle(cornerRadius: .infinity))
//                    )
//                    .overlay {
//                        HStack {
//                            Image("lupaIcon")
//                                .foregroundColor(.blue)
//                                .padding(.leading, 8)
//
//                            TextField("NOME DO DISCO", text: $searchText)
//                                .padding(8)
//                                .customFont(.metarin, textStyle: .title)
//
//                        }
//                        .padding()
//                        .padding(.horizontal)
//                        .foregroundStyle(.white)
//                    }
//                    .frame(height: searchBarHeigth)
//            }
            
            Image("seachBarFakehehehehhe")
        }
    }
}


#Preview {
    Toolbar(searchText: .constant("aaaa lelek"))
}
