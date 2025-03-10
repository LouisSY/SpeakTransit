//
//  CameraView.swift
//  TestProject
//
//  Created by Shuai Yuan on 03/03/2025.
//


import SwiftUI
import CoreMedia

struct CameraView: View {
    @StateObject private var model = DataModel()
    
    private static let barHeightFactor = 0.15
    
//    @State private var currentShutterSpeed: String = "1/100"
//    let shutterSpeeds1 = [1, 3, 5, 10, 15, 30, 50, 60, 100]
//    let shutterSpeeds2 = [125, 200, 400, 500, 1000, 2000, 5000]
    
    var body: some View {
//        HStack {
//            ForEach(shutterSpeeds1, id: \.self) { speed in
//                Button {
//                    currentShutterSpeed = "1/\(speed)"
//                    model.camera.setShutterSpeed(CMTime(value: 1, timescale: CMTimeScale(speed)))
//                } label: {
//                    Text("1/\(String(speed))")
//                        .font(.headline)
//                        .foregroundStyle(currentShutterSpeed == "1/\(speed)" ? .red : .gray)
//                        .fontWeight(currentShutterSpeed == "1/\(speed)" ? .bold : .regular)
//                }
//            }
//        }
//        
//        HStack {
//            ForEach(shutterSpeeds2, id: \.self) { speed in
//                Button {
//                    currentShutterSpeed = "1/\(speed)"
//                    model.camera.setShutterSpeed(CMTime(value: 1, timescale: CMTimeScale(speed)))
//                } label: {
//                    Text("1/\(String(speed))")
//                        .font(.headline)
//                        .foregroundStyle(currentShutterSpeed == "1/\(speed)" ? .red : .gray)
//                        .fontWeight(currentShutterSpeed == "1/\(speed)" ? .bold : .regular)
//                }
//            }
//        }
        
        if model.camera.capturedImage == nil {
            cameraControls
                .onAppear {
                    TextToSpeech.readTextAloud(error: "Please point your camera at a Sign Board to start")
                }
                .onDisappear {
                    Task {
                        model.camera.stop()
                    }
                }
        } else {
            ExtractTextView(model: model)
        }
        
    }
    
    private var cameraControls: some View {
        NavigationStack {
            GeometryReader { geometry in
                ViewfinderView(image: $model.viewfinderImage)
                    .overlay(alignment: .top) {
                        Color.black
                            .opacity(0.75)
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                    }
                    .overlay(alignment: .bottom) {
                        buttonsView()
                            .frame(height: geometry.size.height * Self.barHeightFactor)
                            .background(.black.opacity(0.75))
                    }
                    .overlay(alignment: .center)  {
                        Color.clear
                            .frame(height: geometry.size.height * (1 - (Self.barHeightFactor * 2)))
                            .accessibilityElement()
                            .accessibilityLabel("View Finder")
                            .accessibilityAddTraits([.isImage])
                    }
                    .background(.black)
            }
            .task {
                await model.camera.start()
                await model.loadPhotos()
                await model.loadThumbnail()
            }
            .navigationTitle("Camera")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarHidden(true)
            .ignoresSafeArea()
            .statusBar(hidden: true)
        }
    }
    
    private func buttonsView() -> some View {
        HStack(spacing: 60) {
            
            Spacer()
            
            // photo library view
            NavigationLink {
                PhotoCollectionView(photoCollection: model.photoCollection)
                    .onAppear {
                        model.camera.isPreviewPaused = true
                    }
                    .onDisappear {
                        model.camera.isPreviewPaused = false
                    }
            } label: {
                Label {
                    Text("Gallery")
                } icon: {
                    ThumbnailView(image: model.thumbnailImage)
                }
            }
            
            // camera capture button
            Button {
                model.camera.takePhoto()
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 4)
                            .frame(width: 100, height: 100)
                        Circle()
                            .fill(.white)
                            .frame(width: 80, height: 80)
                    }
                }
            }
            
            // switch camera
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            .opacity(0)
            
            Spacer()
            
        }
        .buttonStyle(.plain)
        .labelStyle(.iconOnly)
        .padding()
    }
    
}

#Preview {
    CameraView()
}
