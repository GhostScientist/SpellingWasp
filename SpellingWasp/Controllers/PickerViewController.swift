//
//  PickerViewController.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 9/4/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//
// This view controller will be presented upon launching the app if the user has not chosen
// the number of words they wish to spell.

import UIKit

// We're using delegation to handle communication between PickerViewController and SpellingViewController

protocol PickerDelegate {
    func didTap(num: Int)
}

class PickerViewController: UIViewController {
    
    // MARK: - Instance Variables
    
    var pickerDelegate: PickerDelegate!
    var selectedNum: Int?
    var buttons = [UIButton]()

    // MARK: - IB Outlets
    @IBOutlet weak var tenWordsOutlet: UIButton!
    @IBOutlet weak var fifteenWordsOutlet: UIButton!
    @IBOutlet weak var twentyWordsOutlet: UIButton!
    @IBOutlet weak var twentyFiveWordsOutlet: UIButton!
    @IBOutlet weak var pickOneButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add the UIButtons to an array to add UI properties.
        buttons = [tenWordsOutlet, fifteenWordsOutlet, twentyWordsOutlet, twentyFiveWordsOutlet, pickOneButton]
        userInterfaceSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IB Action Methods
    
    // This function disables the selected button, enables the unselected buttons, and changes the "Pick One"
    // button to say "Let's Go!."
    
    
    @IBAction func didSelectNumberOfWords(_ sender: UIButton) {
        for button in buttons {
            if button.tag == sender.tag {
                button.isEnabled = false
                pickOneButton.isEnabled = true
                pickOneButton.setTitle("Let's Go!", for: .normal)
                selectedNum = sender.tag
            } else {
                button.isEnabled = true
            }
        }
    }

    // When user is ready to begin, this method passes their chosen value to the SpellingVC.
    
    @IBAction func chooseTapped(_ sender: UIButton) {
        if let num = selectedNum {
            pickerDelegate.didTap(num: num)
            dismiss(animated: true, completion: nil)
        }
    }
    
    // Runs through the buttons array and tweaks the UI a bit.
    
    func userInterfaceSetup() {
        for button in buttons {
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            button.layer.shadowOpacity = 1.0
            button.layer.shadowRadius = 0.0
            button.layer.masksToBounds = true
            button.layer.cornerRadius = button.frame.height / 3.5
        }
        pickOneButton.isEnabled = false
        pickOneButton.titleLabel?.adjustsFontSizeToFitWidth = true
        title = "SpellingWasp"
    }
}
