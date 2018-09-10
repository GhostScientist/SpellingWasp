//
//  Word.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 7/14/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import Foundation
import SwiftyJSON
import AVFoundation

struct Word {
    var word: String
    var classification: String
    var originOfWord: String
    var examplesOfUsage: String
    var pronunciationAudioURL: String
    
    // The method convertToUnderscores returns a string with one underscore per letter in the word.
    // For example, if the word is "Cake" this method would return "__ __ __ __ ". There
    // is an extra space at the end, but that's not really a problem. It shouldn't affect our testing.
    
    func convertToUnderscores() -> String {
        var stringToReturn = ""
        for _ in word {
            stringToReturn += "__  "
        }
        return stringToReturn
    }
    
    init(json: JSON) {
        print("Building again...")
        self.word = json["results"][0]["word"].stringValue
        self.classification = json["results"][0]["lexicalEntries"][0]["lexicalCategory"].stringValue
        self.originOfWord = json["results"][0]["lexicalEntries"][0]["entries"][0]["etymologies"][0].stringValue
        self.examplesOfUsage = json["results"][0]["lexicalEntries"][0]["entries"][0]["senses"][0]["examples"][0]["text"].stringValue
        self.pronunciationAudioURL = json["results"][0]["lexicalEntries"][0]["pronunciations"][0]["audioFile"].stringValue
    }
    
    func wrongAnswer() {
        var string = "You are incorrect. The word \(word) is spelled: "
        for eachLetter in Array(word) {
            string += " \(eachLetter) "
        }
        speak(string)
    }
    
    func correctAnswer() {
        speak("You are correct!")
    }
    
    func announce() {
        speak("Your word is \(word).")
    }
    
    func speak(_ word: String) {
        let utter = AVSpeechUtterance(string: word)
        utter.rate = 0.37
        let synth = AVSpeechSynthesizer()
        synth.speak(utter)
    }
}
