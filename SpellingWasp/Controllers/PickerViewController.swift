//
//  PickerViewController.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 9/4/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {
    
    var selectedNum: Int?

    // MARK: - IB Outlets
    @IBOutlet weak var tenWordsOutlet: UIButton!
    @IBOutlet weak var fifteenWordsOutlet: UIButton!
    @IBOutlet weak var twentyWordsOutlet: UIButton!
    @IBOutlet weak var twentyFiveWordsOutlet: UIButton!
    @IBOutlet weak var pickOneButton: UIButton!
    
    
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttons = [tenWordsOutlet, fifteenWordsOutlet, twentyWordsOutlet, twentyFiveWordsOutlet, pickOneButton]
        DispatchQueue.main.async {
            self.userInterfaceSetup()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IB Actions
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

    @IBAction func chooseTapped(_ sender: UIButton) {
        let vc = SpellingViewController()
        vc.numberOfWordsToPresent = selectedNum!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func userInterfaceSetup() {
        for button in buttons {
            button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
            button.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
            button.layer.shadowOpacity = 1.0
            button.layer.shadowRadius = 0.0
            button.layer.masksToBounds = true
            button.layer.cornerRadius = 10.0
        }
        pickOneButton.isEnabled = false
        title = "SpellingWasp"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
