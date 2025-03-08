//
//  TextToSpeech.swift
//  SpeakTransit
//
//  Created by Shuai Yuan on 10/03/2025.
//


import AVFoundation
import SwiftUI

class TextToSpeech {
    private static var synthesizer = AVSpeechSynthesizer()

    static func readTextAloud(infos: [UpcomingVehicleInfo]) {
        if HapticFeedbackHelper.isDeviceInSilentMode {
            HapticFeedbackHelper.provideHapticFeedback(style: .light, duration: 5.0)
        }
        for info in infos {
            let utterance = AVSpeechUtterance(string: info.destination + " " + info.waitingTime)
            utterance.rate = 0.5
            utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
            
            synthesizer.speak(utterance)
        }
    }

    static func readTextAloud(error: String) {
        if HapticFeedbackHelper.isDeviceInSilentMode {
            HapticFeedbackHelper.provideHapticFeedback(style: .light, duration: 5.0)
        }
        let utterance = AVSpeechUtterance(string: error)
        utterance.rate = 0.5
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        
        synthesizer.speak(utterance)
    }
    
    static func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
    }
}
