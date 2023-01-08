//
//  HistoryViewController.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 2.12.2022.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource {


    
    @IBOutlet weak var HistoryTableView: UITableView!
    var plantData = [SavedPlantData]()
    let cdh = CoreDataHandler()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.plantData = cdh.fetchData()
        self.HistoryTableView.reloadData()

        // Do any additional setup after loading the view.
    }
    

    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HistoryTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = plantData[indexPath.row].plantName
        
        return cell
        
        
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
