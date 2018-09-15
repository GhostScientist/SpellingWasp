//
//  ResultsViewController.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 9/12/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import UIKit

// This VC will be presented to users after they have finished spelling their selected
// number of words. It's a simple presentation screen that informs users how many they got correct
// out of the total.

class ResultsViewController: UIViewController {
    
    // Instance Variables
    var totalNum : Int!
    var numCorrect: Int!
    
    // MARK: - IB Outlets
    
    @IBOutlet weak var numberCorrect: UILabel!
    @IBOutlet weak var numberTotal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let numRight = numCorrect, let numTotal = totalNum {
            numberCorrect.text = "\(numRight) Right"
            numberTotal.text = "\(numTotal) Total"
        }
    }
}
