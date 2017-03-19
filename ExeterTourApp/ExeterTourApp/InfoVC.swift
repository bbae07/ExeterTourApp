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
    var image_index:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.text.text = currentlocation?.explain
        self.image.image = UIImage(named:(self.currentlocation?.photo[self.image_index])!)
        // Do any additional setup after loading the view.
    }
    @IBAction func showMap(_ sender: UIButton) {
        let map:MapViewController = MapViewController()
        map.selectedLocation = self.currentlocation
        self.navigationController?.pushViewController(map, animated: true)
    }

    @IBAction func movePhoto(_ sender: UIButton){
        
        let tag:Int = sender.tag
        
        if tag == 0{
            //left
            if self.image_index != 0{
                self.image_index -= 1
                self.image.image = UIImage(named:(self.currentlocation?.photo[self.image_index])!)
            }
        }else{
            //right
            if self.image_index != ((self.currentlocation?.photo.count)! - 1){
                self.image_index += 1
                self.image.image = UIImage(named:(self.currentlocation?.photo[self.image_index])!)
            }
        }
        
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
