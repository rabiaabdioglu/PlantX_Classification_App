//
//  ViewController.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 30.11.2022.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      

    }
    
    @IBAction func buttonClicked(entry button: UIButton ) {
        
    performSegue(withIdentifier: "EntrytoHome", sender: self)
print("içeride")
    }
  
        
    
}
