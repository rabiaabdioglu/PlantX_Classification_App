//
//  HistoryViewController.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 2.12.2022.
//

import UIKit

class HistoryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Segue işlemleri

    @IBAction func HistoryToHome(plants button : UIButton){
        
        performSegue(withIdentifier: "HistoryToHome", sender: self)
        
    }
    @IBAction func HistoryToFind(plants button : UIButton){
        
        performSegue(withIdentifier: "HistoryToFind", sender: self)
        
    }
    @IBAction func HistoryToMyPlant(plants button : UIButton){
        
        performSegue(withIdentifier: "HistoryToMyPlant", sender: self)
        
    }
    @IBAction func dismissBtnPressed() {
           dismiss(animated: true) {
           }
       }
    
}
