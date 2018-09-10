//
//  SpellingViewController.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 9/5/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import UIKit
import SwiftyJSON
import GameplayKit

class SpellingViewController: UIViewController, PickerDelegate {
    
    internal var numberOfWordsToPresent: Int? {
        didSet {
            chosenNum = true
        }
    }
    
    internal var chosenNum = false
    
    var wordToPresent: Word?
    var wordsToPresent = [Word]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "SpellingWasp"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Solve", style: .plain, target: self, action: #selector(solveTapped))
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if chosenNum == false {
            super.viewDidAppear(animated)
            let vc = storyboard?.instantiateViewController(withIdentifier: "PickerView") as! PickerViewController
            vc.pickerDelegate = self
            present(vc, animated: true)
        }
    }
    
    override func loadView() {
        super.loadView()
        //view.backgroundColor = UIColor.white
    }
    
    @objc func solveTapped() {
        // This will present an alert controller with a text field for the user to submit their
        // spelling attempt. If they're correct, it will play a noise and load a "Tap to Continue" screen
        // for when the user is ready.
        
        if let num = numberOfWordsToPresent {
            print("solve works - \(num)")
        }
    }
    
    @objc func skipTapped() {
        // The user can choose to skip the current word without it counting against their selected goal.
        print("Skip works")
    }
    
    func loadUI() {
        let networker = Networker.shared
        networker.grabWordInfo(word: <#T##String#>)
    }
    
    // MARK: - IB Actions
    
    @IBAction func repeatTapped(_ sender: UIButton) {
        // Will play the audio file downloaded from the dictionary.
        
    }
    
    @IBAction func exampleTapped(_ sender: UIButton) {
        // Will use speech generator to read the example aloud
        
    }

    func didTap(num: Int) {
        numberOfWordsToPresent = num
        print(chosenNum)
        print(numberOfWordsToPresent)
    }
}

extension SpellingViewController {
    func generateWord() -> String? {
        if let filePath = Bundle.main.path(forResource: "all_words", ofType: "txt") {
            if let allWords = try? String.init(contentsOfFile: filePath) {
                let mixedList = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords.components(separatedBy: "\n")) as! [String]
                return mixedList[0]
            }
        }
        return nil
    }
}
