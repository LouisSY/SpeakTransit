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
    
    @State private var currentShutterSpeed: String = "1/100"
    let shutterSpeeds1 = [10, 15, 30, 50, 60, 100, 125]
    let shutterSpeeds2 = [200, 400, 500, 1000, 2000, 5000]
    
    var body: some View {
        HStack {
            ForEach(shutterSpeeds1, id: \.self) { speed in
                Button {
                    currentShutterSpeed = "1/\(speed)"
                    model.camera.setShutterSpeed(CMTime(value: 1, timescale: CMTimeScale(speed)))
                } label: {
                    Text("1/\(String(speed))")
                        .font(.headline)
                        .foregroundStyle(currentShutterSpeed == "1/\(speed)" ? .red : .gray)
                        .fontWeight(currentShutterSpeed == "1/\(speed)" ? .bold : .regular)
                }
            }
        }
        
        HStack {
            ForEach(shutterSpeeds2, id: \.self) { speed in
                Button {
                    currentShutterSpeed = "1/\(speed)"
                    model.camera.setShutterSpeed(CMTime(value: 1, timescale: CMTimeScale(speed)))
                } label: {
                    Text("1/\(String(speed))")
                        .font(.headline)
                        .foregroundStyle(currentShutterSpeed == "1/\(speed)" ? .red : .gray)
                        .fontWeight(currentShutterSpeed == "1/\(speed)" ? .bold : .regular)
                }
            }
        }
        
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
            
            Button {
                model.camera.takePhoto()
            } label: {
                Label {
                    Text("Take Photo")
                } icon: {
                    ZStack {
                        Circle()
                            .strokeBorder(.white, lineWidth: 3)
                            .frame(width: 62, height: 62)
                        Circle()
                            .fill(.white)
                            .frame(width: 50, height: 50)
                    }
                }
            }
            
            Button {
                model.camera.switchCaptureDevice()
            } label: {
                Label("Switch Camera", systemImage: "arrow.triangle.2.circlepath")
                    .font(.system(size: 36, weight: .bold))
                    .foregroundColor(.white)
            }
            
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
