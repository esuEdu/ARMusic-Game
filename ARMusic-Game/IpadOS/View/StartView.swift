//
//  StartView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Thiago Pereira de Menezes on 30/07/24.
//

import SwiftUI

struct StartView: View {
    
    
    var body: some View {
        HStack {
            VStack{
                btn()
                
                btn()
            }
 
            Image("legoLogo")
        }
        .background {
            Image("background")
        }
    }
    
    func btn() -> some View {        RoundedRectangle(cornerRadius: 25.0)
            .foregroundStyle(.pink)
            .overlay {
                Text("text")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.blue)
            }
            .onTapGesture {
                print("clicked")
            }
    }
}

#Preview {
    StartView()
}
