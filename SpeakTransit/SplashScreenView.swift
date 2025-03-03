//
//  SplashScreenView.swift
//  SpeakTransit
//
//  Created by Shuai Yuan on 26/02/2025.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack {
            Text("SpeakTransit")
                .font(.largeTitle)
                .bold()
                .foregroundStyle(.black)
            Image("SpeakTransitLogo")
            Text("Covnerting Transport Screen Text\ninto Clear, Audible Speech.")
                .font(.body)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(hex: "2F2F2F"))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(edges: .all)
        .background(
            LinearGradient(colors: [.white, Color(hex: "#DFDFDF")], startPoint: .top, endPoint: .bottom)
        )
    }
}

#Preview {
    SplashScreenView()
}
