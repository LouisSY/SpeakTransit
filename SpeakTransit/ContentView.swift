//
//  ContentView.swift
//  SpeakTransit
//
//  Created by Shuai Yuan on 01/03/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    
    @State private var cameraType: String = "1"
    
    var body: some View {
        if showSplash {
            ZStack {
                SplashScreenView()
                //            .onAppear {
                //                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                //                    withAnimation {
                //                        showSplash = false
                //                    }
                //                }
                //            }
                VStack {
                    Spacer()
                    HStack {
                        Button {
                            cameraType = "MCamera"
                            withAnimation {
                                showSplash = false
                            }
                        } label: {
                            Text("MCamera")
                        }
                        
                        Button {
                            cameraType = "ShutterSpeed"
                            withAnimation {
                                showSplash = false
                            }
                        } label: {
                            Text("ShutterSpeed")
                        }
                    }
                }
                .padding()
            }


        } else {
            if cameraType == "MCamera" {
                CameraDisplayView()
            } else {
                CameraView()
            }
            
        }
    }
}

#Preview {
    ContentView()
}
