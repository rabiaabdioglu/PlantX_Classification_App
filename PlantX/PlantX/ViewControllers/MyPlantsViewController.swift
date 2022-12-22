//
//  MyPlantsViewController.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 30.11.2022.
//

import UIKit

class MyPlantsViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
   
    

    @IBOutlet weak var myPlantTableView: UITableView!
    var plantData = [SavedPlantData]()
    var plantName = "Bilinmiyor.."
    var imageView: UIImageView!
    var isSaveButtonPressed = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
      


        if isSaveButtonPressed == true {
            savePlant()
        }
        myPlantTableView.reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myPlantTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = plantData[indexPath.row].plantName
        
        return cell
        
        
    }
    func savePlant(){
        
        let cdh = CoreDataHandler()
        cdh.saveData(savePlantName: self.plantName)
        self.plantData = cdh.fetchData()
        self.myPlantTableView.reloadData()

        
        isSaveButtonPressed = false
    }
    
    
    
    //Segue işlemleri
    @IBAction func dismissBtnPressed() {
           dismiss(animated: true) {
           }
       }
    @IBAction func MyPlantToHome(plants button : UIButton){
        
        performSegue(withIdentifier: "MyPlantToHome", sender: self)
        
    }
    @IBAction func MyPlantToFind(plants button : UIButton){
        
        performSegue(withIdentifier: "MyPlantToFind", sender: self)
        
    }
}
