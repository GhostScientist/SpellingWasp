//
//  Word.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 7/14/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import Foundation

class Word {
    var word = ""
    var group = ""
    var origin = ""
    var exampleOfUsage = [String]() // These will be read aloud using AVSpeechSynthesizer
    var pronunciation : String // This will be the file name for the audio pronounciation.
    
    init(word: String, group: String, origin: String, exampleOfUsage: [String], pronunciation: String) {
        self.word = word
        self.group = group
        self.origin = origin
        self.exampleOfUsage = exampleOfUsage
        self.pronunciation = pronunciation
    }
    
    func returnDescriptiveStringFor() -> String {
        return "\(self.group) - \(self.origin)"
    }
}
