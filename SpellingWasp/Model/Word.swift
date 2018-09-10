//
//  Word.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 7/14/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import Foundation
import SwiftyJSON

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
            stringToReturn += "__ "
        }
        return stringToReturn
    }
    
    init(json: JSON) {
        self.word = json["results"]["id"].stringValue.capitalized
        self.classification = json["results"]["lexicalEntries"][0]["lexicalCategory"].stringValue
        self.originOfWord = json["results"]["lexicalEntries"][0]["etymologies"][0].stringValue
        self.examplesOfUsage = json["results"]["lexicalEntries"]["pronunciations"]["examples"][0]["text"].stringValue
        self.pronunciationAudioURL = json["results"]["lexicalEntries"]["pronunciations"][0]["audioFile"].stringValue
    }
}
