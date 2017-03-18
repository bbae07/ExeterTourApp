//
//  InfoVC.swift
//  ExeterTourApp
//
//  Created by Brian Bae on 2017. 3. 18..
//  Copyright © 2017년 bbae07. All rights reserved.
//

import UIKit

class InfoVC: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var text: UITextView!
    var currentlocation:loc? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        text.text = currentlocation?.explain
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
