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
        utterance.voice = AVSpeechSynthesisVoice(language: "en-AU")
        
        synthesizer.speak(utterance)
    }
    
    func sayOutLoud(_ number: Int) {
        var text = ""
        if number / 60 == 0 {
            text = "\(number % 60)"
        } else {
            if number % 60 == 0 {
               text = "\(number / 60) minutes"
            } else {
                text = "\(number / 60) minutes \(number % 60)"
            }
            
        }
        
        sayOutLoud(text)
    }
}
