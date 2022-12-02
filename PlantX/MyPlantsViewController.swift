//
//  MyPlantsViewController.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 30.11.2022.
//

import UIKit

class MyPlantsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func MyPlantToHome(plants button : UIButton){
        
        performSegue(withIdentifier: "MyPlantToHome", sender: self)
        
    }
    @IBAction func MyPlantToFind(plants button : UIButton){
        
        performSegue(withIdentifier: "MyPlantToFind", sender: self)
        
    }
}
