//
//  SplashScreenView.swift
//  SpeakTransit
//
//  Created by Shuai Yuan on 26/02/2025.
//

import SwiftUI

struct SplashScreenView: View {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack {
            Text("RideOnTime")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(colorScheme == .light ? .charcoalBlue : .vibrantGold)
            
            Image(colorScheme == .dark ? "LogoGold" : "LogoBlue")
                .resizable()
                .scaledToFit()
                .frame(width: 177, height: 177)
                .padding()
            
            Text("Covnerting Transport Screen\nText into Clear Text and\nAudible Speech.")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundStyle(colorScheme == .light ? .charcoalBlue : .vibrantGold)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .all)
        .background(
            colorScheme == .light ? .vibrantGold : .charcoalBlue
        )
    }
}

#Preview {
    SplashScreenView()
}
