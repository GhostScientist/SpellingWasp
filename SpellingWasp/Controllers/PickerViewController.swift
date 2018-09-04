//
//  PickerViewController.swift
//  SpellingWasp
//
//  Created by Dakota Kim on 9/4/18.
//  Copyright © 2018 Dakota Kim. All rights reserved.
//

import UIKit

class PickerViewController: UIViewController {

    // MARK: - IB Outlets
    @IBOutlet weak var tenWordsOutlet: UIButton!
    @IBOutlet weak var fifteenWordsOutlet: UIButton!
    @IBOutlet weak var twentyWordsOutlet: UIButton!
    @IBOutlet weak var twentyFiveWordsOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IB Actions
    @IBAction func didSelectNumberOfWords(_ sender: UIButton) {
        
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
