//
//  CameraDisplayView.swift
//  SpeakTransit
//
//  Created by Shuai Yuan on 26/02/2025.
//

import SwiftUI
import MijickCamera
import CoreMedia
import Photos

struct CameraDisplayView: View {
    var body: some View {
        MCamera()
            .setFlashMode(.auto)
            .setAudioAvailability(false)
            .setResolution(.hd1920x1080)
            .setCameraExposureMode(.custom)
            .setCameraExposureDuration(CMTime(value: 1, timescale: 3000))
            .setCameraHDRMode(.off)
            .onImageCaptured({ image, controller in
                PHPhotoLibrary.shared().performChanges({
                    // Create a change request to add the image to the library
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }) { success, error in
                    DispatchQueue.main.async {
                        if success {
                            print("Image saved to the library.")
                        } else {
                            if let error = error {
                                print("Error saving image: \(error.localizedDescription)")
                            }
                        }
                    }
                }
            })
            .startSession()
    }
}

#Preview {
    CameraDisplayView()
}
