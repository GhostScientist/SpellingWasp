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
}

//class Word {
//    var word = ""
//    var group = ""
//    var origin = ""
//    var exampleOfUsage : String // These will be read aloud using AVSpeechSynthesizer
//
//    init(word: String, group: String, origin: String, exampleOfUsage: String) {
//        self.word = word
//        self.group = group
//        self.origin = origin
//        if exampleOfUsage.count > 0 {
//            self.exampleOfUsage = exampleOfUsage
//        } else {
//            self.exampleOfUsage = "There are no examples for the word \(word)."
//        }
//    }
//
//    func returnDescriptiveStringFor() -> String {
//        var stringToReturn = ""
//        if group.count != 0 {
//            stringToReturn += group.capitalized
//            if origin.count != 0 {
//                stringToReturn += " - "
//                stringToReturn += origin.firstUppercased
//            }
//        }
//        return stringToReturn
//    }
//
//    func replaceLettersWithUnderscore() -> String {
//        var finalWord = ""
//        for _ in self.word {
//            finalWord += "_ "
//        }
//        return finalWord
//    }
//
//}
//
//extension StringProtocol {
//    var firstUppercased: String {
//        guard let first = first else {return "" }
//        return String(first).uppercased() + dropFirst()
//    }
//}
