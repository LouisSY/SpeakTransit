//
//  HapticFeedbackHelper.swift
//  SpeakTransit
//
//  Created by Shuai Yuan on 10/03/2025.
//

import Foundation
import AVFoundation
import UIKit

class HapticFeedbackHelper {
    
    static func isDeviceInSilentMode() -> Bool {
        let audioSession = AVAudioSession.sharedInstance()
        
        if audioSession.secondaryAudioShouldBeSilencedHint {
            return true
        }
        
        return audioSession.outputVolume == 0.0
    }
    
    static func provideHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium) {
        if isDeviceInSilentMode() {
            let generator = UIImpactFeedbackGenerator(style: style)
            generator.prepare()
            generator.impactOccurred()
        }
    }
    
    static func provideHapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .medium, duration: TimeInterval) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.prepare()
        
        let endTime = Date().addingTimeInterval(duration)
        
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            generator.impactOccurred()
            
            if Date() >= endTime {
                timer.invalidate()
            }
        }
    }
}
