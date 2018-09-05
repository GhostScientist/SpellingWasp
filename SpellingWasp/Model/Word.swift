//
//  Word.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 7/14/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import Foundation

struct Word {
    var word: String
    var classification: String
    var originOfWord: String
    var examplesOfUsage: [String]?
    var pronunciationAudioURL: String?
    
    // The method convertToUnderscores returns a string with one underscore per letter in the word.
    // For example, if the word is "Cake" this method would return "__ __ __ __ ". There
    // is an extra space at the end, but that's not really a problem. It shouldn't affect our testing.
    
    func convertToUnderscores() -> String {
        var stringToReturn = ""
        for _ in word {
            stringToReturn += "__ "
        }
        return stringToReturn
    }
}
