//
//  ExtractTextView.swift
//  SpeakTransit
//
//  Created by Shuai Yuan on 09/03/2025.
//

import SwiftUI
import Vision

struct ExtractTextView: View {
    
    @ObservedObject var model: DataModel
    
    @State private var infos: [UpcomingVehicleInfo] = []
    
    @State private var errorString: String = ""
    
    var body: some View {
        ZStack {
            Color.charcoalBlue
                .ignoresSafeArea(edges: .all)
            
            VStack {
                let capturedImage = model.camera.capturedImage ?? UIImage(named: "TestImage")
                
                customBorder
                
                Image(uiImage: capturedImage ?? UIImage())
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .frame(height: 300)
                    .padding()
                    .onAppear {
                        extractText(from: capturedImage ?? UIImage()) { extractedText, error in
                            DispatchQueue.main.async {
                                guard error == nil else {
                                    self.errorString = error!
                                    return
                                }

                                let structuredText = parseUpcomingVehicleInfo(from: extractedText)
                                
                                if structuredText.isEmpty {
                                    withAnimation(.easeInOut) {
                                        self.infos = []
                                        self.errorString = "No text detected in the image."
                                    }
                                } else {
                                    withAnimation(.easeInOut) {
                                        self.infos = structuredText
                                    }
                                }
                            }
                        }
                    }
                
                customBorder
                
                // display info
                if infos.isEmpty && errorString.isEmpty {
                    Text("Please wait...")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundStyle(.vibrantGold)
                } else if !infos.isEmpty {
                    ScrollView {
                        ForEach(infos) { info in
                            infoDisplay(info: info)
                        }
                    }
                    .scrollIndicators(.visible)
                    .overlay(
                        VStack {
                            Spacer()
                            
                            Rectangle()
                                .frame(height: 1) // Bottom border
                                .foregroundColor(Color(hex: "555555"))
                        }
                    )
                } else if !errorString.isEmpty {
                    VStack {
                        Text(errorString)
                        Text("Please retake the image")
                    }
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundStyle(.vibrantGold)
                }
                
                // retake photo
                if !infos.isEmpty || !errorString.isEmpty {
                    Button {
                        model.camera.capturedImage = nil
                        self.infos.removeAll()
                        self.errorString.removeAll()
                    } label: {
                        Label("Retake Photo", systemImage: "camera")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundStyle(.charcoalBlue)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 20, style: .continuous)
                                    .fill(.vibrantGold)
                            )
                            .padding()
                    }
                }
                
            }
        }
    }
    
    private var customBorder: some View {
        Rectangle()
            .frame(height: 1)
            .foregroundColor(Color(hex: "555555"))
    }
    
    func infoDisplay(info: UpcomingVehicleInfo) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(info.destination)
                Spacer()
            }
            Text(info.waitingTime)
        }
        .font(.largeTitle)
        .fontWeight(.heavy)
        .foregroundStyle(.vibrantGold)
        .padding()
        
    }
    
    func extractText(from image: UIImage, completion: @escaping ([String], String?) -> Void) {
        // Convert image to grayscale
        guard let enhancedImage = enhanceContrast(of: image) else {
            completion([], "Failed to enhance contrast of image.")
            return
        }
        
        guard let grayscaleImage = convertToGrayscale(enhancedImage) else {
            completion([], "Failed to convert image to grayscale.")
            return
        }
        
        guard let cgImage = grayscaleImage.cgImage else {
            completion([], "Failed to convert grayscale image to CGImage.")
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation], error == nil else {
                completion([], "Error recognizing text: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            let extractedText = observations.compactMap { $0.topCandidates(1).first?.string }
            if extractedText.isEmpty {
                completion([], "No text detected in image.")
            } else {
                completion(extractedText, nil)
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true // Enable language correction
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try requestHandler.perform([request])
            } catch {
                completion([], "Error performing text recognition: \(error)")
            }
        }
    }
    
    // Helper function to convert UIImage to grayscale
    func convertToGrayscale(_ image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        
        let filter = CIFilter(name: "CIPhotoEffectMono")!  // Apply grayscale effect
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard let outputCIImage = filter.outputImage else {
            return nil
        }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
    
    func enhanceContrast(of image: UIImage) -> UIImage? {
        guard let ciImage = CIImage(image: image) else { return nil }
        
        let filter = CIFilter(name: "CIColorControls")!
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        filter.setValue(70.0, forKey: kCIInputContrastKey) // Increase contrast
        
        guard let outputCIImage = filter.outputImage else { return nil }
        
        let context = CIContext(options: nil)
        guard let cgImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}

#Preview {
    ExtractTextView(model: DataModel())
}
