//
//  TextToSpeech.swift
//  YachtTimer
//
//  Created by Szamódy Zs. Balázs on 2017. 07. 26..
//  Copyright © 2017. Szamódy Zs. Balázs. All rights reserved.
//

import Foundation
import AVFoundation

class TextToSpeech {
    
    let synthesizer = AVSpeechSynthesizer()
    
    func sayOutLoud(_ text: String) {
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.rate = 0.55
        
        
        synthesizer.speak(utterance)
    }
    
    func sayOutLoud(_ number: Int) {
        var text = ""
        let minutes = number / 60
        let seconds = number % 60
        
        switch minutes {
        
        case 1:
            text += "\(minutes) minute "
        case 0:
            text += ""
        default:
            text += "\(minutes) minutes"
        }
        
        text += "\(seconds)"
       
        sayOutLoud(text)
    }
}
