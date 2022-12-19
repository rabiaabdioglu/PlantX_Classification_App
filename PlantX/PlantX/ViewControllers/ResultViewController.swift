//
//  ResultViewController.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 2.12.2022.
//

import UIKit

class ResultViewController: UIViewController {

   
    @IBOutlet weak var predictionLabels: UILabel!
    var user = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        predictionLabels.text = user
print(user)
        // Do any additional setup after loading the view.
    }
    @IBAction func dismissBtnPressed() {
           dismiss(animated: true) {
           }
       }
    
   
    
    @IBAction func ResultToMyPlants(plants button : UIButton){
        
        performSegue(withIdentifier: "ResultToMyPlants", sender: self)
        
    }
}
