//
//  MyPlantsViewController.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 30.11.2022.
//

import UIKit
import CoreData

class MyPlantsViewController: UIViewController {
   
    

    var plantData = [SavedPlantData]()
    var plantName = "Bilinmiyor.."
    var imageView: UIImageView!
    var isSaveButtonPressed = false
    var selectedCellLabel = ""
    let cdh = CoreDataHandler()

    
    @IBOutlet weak var textLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.plantData = cdh.fetchData()

        
        if isSaveButtonPressed == true {
                savePlant()
           
            }
        
        
    }
    
    func savePlant(){
        cdh.saveData(savePlantName: self.plantName)
        self.plantData = cdh.fetchData()

        isSaveButtonPressed = false
    }

    
    //MARK: Segue işlemleri

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
          if segue.identifier == "MyPlantsToResult" {
              
              if let resultLabel = segue.destination as? ResultViewController {
                  
                 
                  do{ resultLabel.plantInfo.name = selectedCellLabel
                    
                      
                  }catch{
                      print("Missing parameter.")      }     } }  }
    
    

    
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
    @IBAction func MyPlantToResult(plants button : UIButton){
        
        performSegue(withIdentifier: "MyPlantToResult", sender: self)
        
    }
   
    
       
}


//MARK: Tableview functions
extension MyPlantsViewController : UITableViewDataSource, UITableViewDelegate{
    

    
    
    
    //count data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantData.count
        
    }
    
    
    // get cells
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        
        let cell = UITableViewCell()

           cell.textLabel?.text = plantData[indexPath.row].plantName
        
        return cell
    }
    //Delete
       

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            plantData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
 
    
    
    func deleteItem (item : SavedPlantData){
        
        let appDel = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let plantObject = NSEntityDescription.insertNewObject(forEntityName: "SavedPlantData", into: context) as! SavedPlantData
        
        context.delete(item)
        
        do{
            try context.save()
            cdh.fetchData()
            
        }catch{print("Error has been occured during save data..")}
           
    }
    
    //selected cell go to result page
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)

        if cell.textLabel!.text != nil {
            self.selectedCellLabel =  cell.textLabel!.text!
            performSegue(withIdentifier: "MyPlantsToResult", sender: nil)
            
        }
        else {print("Error")}
        
       
    }
   
    //for swipe right to left
      func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = UIContextualAction(style: .destructive ,  title: nil){ _, _, completion in
            self.plantData.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion (true)
        }
        delete.image = UIImage(systemName: "trash")
        delete.backgroundColor = .systemRed
        
        let config = UISwipeActionsConfiguration(actions: [delete])
        
         return config
    }

    
    
}
