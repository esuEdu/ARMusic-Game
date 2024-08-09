//
//  CDItemCell.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Thiago Pereira de Menezes on 08/08/24.
//

import SwiftUI

struct CDItemCell: View {
    let cdItem: CDItem
    private let tamanhoDosCDS = UIScreen.main.bounds.width * 0.13
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 0) {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: tamanhoDosCDS, height: tamanhoDosCDS)
                
                HalfCircle()
                    .fill(Color.black)
                    .frame(width: tamanhoDosCDS, height: tamanhoDosCDS)
            }
            .padding(.bottom, 30)
            
            Text(cdItem.descricao)
                .bold()
                .foregroundColor(.black)
                .frame(width: tamanhoDosCDS * 1.3)
                .padding(.bottom, 30)
                .multilineTextAlignment(.center)
        }
    }
}
#Preview {
    CDItemCell(cdItem: CDItem(text: "Mamonas Assacinas", descricao: "alelek", image: "pencil.fill"))
}
