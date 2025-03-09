//
//  ContentView.swift
//  SpeakTransit
//
//  Created by Shuai Yuan on 01/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    
    var body: some View {
        if showSplash {
            SplashScreenView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation {
                            showSplash = false
                        }
                    }
                }
        } else {
            CameraView()
        }
    }
}

#Preview {
    ContentView()
}
