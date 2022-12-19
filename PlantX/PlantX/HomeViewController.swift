//
//  HomeViewController.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 30.11.2022.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func HomeToMyPlant(plants button : UIButton){
        
        performSegue(withIdentifier: "HomeToMyPlant", sender: self)
        
    }
    @IBAction func HomeToHistory(plants button : UIButton){
        
        performSegue(withIdentifier: "HomeToHistory", sender: self)
        
    }
    @IBAction func HomeToFind(plants button : UIButton){
        
        performSegue(withIdentifier: "HomeToFind", sender: self)
        
    }
 
}
