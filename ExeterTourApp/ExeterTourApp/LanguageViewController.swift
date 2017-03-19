//
//  LanguageViewController.swift
//  ExeterTourApp
//
//  Created by 이경문 on 2017. 3. 20..
//  Copyright © 2017년 bbae07. All rights reserved.
//

import UIKit

class LanguageViewController: UIViewController {

    @IBAction func setLang1(_ sender: UIButton) {
        UserDefaults.standard.set(1, forKey: "LANG")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main:UIViewController = storyboard.instantiateViewController(withIdentifier: "MAIN")
        self.present(main, animated: true, completion: nil)
    }
    
    @IBAction func setLANG2(_ sender: UIButton) {
        UserDefaults.standard.set(2, forKey: "LANG")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main:UIViewController = storyboard.instantiateViewController(withIdentifier: "MAIN")
        self.present(main, animated: true, completion: nil)
    }
    @IBAction func setLANG3(_ sender: UIButton) {
        UserDefaults.standard.set(3, forKey: "LANG")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main:UIViewController = storyboard.instantiateViewController(withIdentifier: "MAIN")
        self.present(main, animated: true, completion: nil)
    }
    @IBAction func setLANG4(_ sender: UIButton) {
        UserDefaults.standard.set(4, forKey: "LANG")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let main:UIViewController = storyboard.instantiateViewController(withIdentifier: "MAIN")
        self.present(main, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
