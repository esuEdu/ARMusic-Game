//
//  InstrumentCardView.swift
//  ARMusic-Game (IpadOS)
//
//  Created by Erick Ribeiro on 04/08/24.
//

import SwiftUI

struct InstrumentCardView: View {
    var instrumentInfo: InstrumentInfo
    
    var body: some View {
        VStack(alignment: .center, spacing: 10) {
            Image(instrumentInfo.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipShape(.rect(cornerRadius: 15))
                .containerRelativeFrame(.vertical){ height, _ in height * 0.25}
            
            VStack(spacing: 5) {
                Text(instrumentInfo.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(instrumentInfo.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)

            }
            .containerRelativeFrame(.vertical){ height, _ in height * 0.1}
        }
        .padding(10)
        .background(.blue)
        .clipShape(.rect(cornerRadius: 15))
        .frame(maxWidth: .infinity)
        .shadow(color: .gray, radius: 5)
    }
}

//#Preview {
//    InstrumentCardView(instrumentInfo: InstrumentInfo(name: "", imageName: "", description: ""))
//}
