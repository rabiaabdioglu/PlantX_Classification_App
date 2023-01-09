//
//  MyPlantsViewController.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 30.11.2022.
//

import UIKit
import CoreData

class MyPlantsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    var plantName = "Bilinmiyor.."
    var imageView: UIImageView!
    var isSaveButtonPressed = false
    
    var selectedCellLabel = ""

    
    @IBOutlet weak var tableView: UITableView!
    
    var plantNameArray = [String]()
    var plantIdArray = [UUID]()
    var plantImageArray = [Data]()

    var selectedPlant = ""
    var selectedPlantId : UUID?

    
    
    @IBOutlet weak var textLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
   
    private let refreshControl = UIRefreshControl()


    override func viewDidLoad() {

            super.viewDidLoad()
        
            tableView.delegate = self
            tableView.dataSource = self
            
            if isSaveButtonPressed == true {
                    savePlant()
               
                }
        getData()
            
            
        }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    
    
    @objc func getData() {
        
        plantNameArray.removeAll(keepingCapacity: false)
        plantIdArray.removeAll(keepingCapacity: false)
        plantImageArray.removeAll(keepingCapacity: false)

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedPlantData")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            print(results)
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                                if let name = result.value(forKey: "plantName") as? String {
                                    self.plantNameArray.append(name)
                                }
                                
                                if let id = result.value(forKey: "plantId") as? UUID {
                                    self.plantIdArray.append(id)
                                }
                                if let image = result.value(forKey: "plantImage") as? Data {
                                    self.plantImageArray.append(image)
                                }
                                self.tableView.reloadData()
                                
                            }
            }
            

        } catch {
            print("error")
        }
        
    }
    
    
        func savePlant() {
        
       
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let plantData = NSEntityDescription.insertNewObject(forEntityName: "SavedPlantData", into: context)
        
        //Attributes
            if imageView.image != nil {
                let imageData = imageView.image!.pngData()
                
                
                
                do{
                    plantData.setValue(self.plantName, forKey: "plantName")
                    plantData.setValue(imageData, forKey: "plantImage")
                    plantData.setValue(Date(), forKey: "date")
                    plantData.setValue(UUID(), forKey: "plantId")
                    
                    
                    
                    try context.save()
                    
                }catch{print("Error has been occured during save data..")
                }
                
                
                
                NotificationCenter.default.post(name: NSNotification.Name("newData"), object: nil)
                self.navigationController?.popViewController(animated: true)
            }
            else { print("You cant save nil value")}
    }
    
    
    //get number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantNameArray.count
    }
    
    //get cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
    
            let image = UIImage(data: plantImageArray[indexPath.row])
            if image != nil{
                cell.imageView?.image = imageWithImage(image: image!, scaledToSize: CGSize(width: 60  , height: 60))
                
            }
        
             cell.textLabel?.text = plantNameArray[indexPath.row]
        return cell
    }
    


    
    //allert for detail and delete plants
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            tableView.deselectRow(at: indexPath, animated: true )
          
            let item = plantIdArray[indexPath.row]
            
            let sheet = UIAlertController(title: plantNameArray[indexPath.row] , message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
            
            sheet.addAction(UIAlertAction(title: "Detay", style: .default, handler: {_ in
                self.getDetail()
            }))
            sheet.addAction(UIAlertAction(title: "Sil", style: .destructive, handler: {[weak self] _ in
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SavedPlantData")
            
                let idString = self?.plantIdArray[indexPath.row].uuidString
   

                fetchRequest.predicate = NSPredicate(format: "plantId = %@", idString!)
      
                fetchRequest.returnsObjectsAsFaults = false
   

                do {
                    let results = try context.fetch(fetchRequest)
             

                    if results.count > 0 {

                        for result in results as! [NSManagedObject] {

                            if let id = result.value(forKey: "plantId") as? UUID {
                                
                                if id == self?.plantIdArray[indexPath.row] {

                                    context.delete(result)

                                    self?.plantNameArray.remove(at: indexPath.row)
                                    self?.plantIdArray.remove(at: indexPath.row)

                                    tableView.reloadData()
                                    
                                    do {
                                        try context.save()
                                        
                                    } catch {
                                        print("error")
                                    }
                                    
                                    break
                                    
                                }
                                
                            }
                            
                            
                        }
                        
                        
                    }
                } catch {
                    print("error")
                }
                
                
                
                
                
                DispatchQueue.main.async {
                          tableView.reloadData()
                      }

            }))

            selectedPlant = plantNameArray[indexPath.row]
            selectedPlantId = plantIdArray[indexPath.row]
            
       present(sheet,animated: true)
    }
   

    
    
    
    func getDetail(){
  
        do{
            
            if selectedPlant != nil {
                self.selectedCellLabel =  selectedPlant
                performSegue(withIdentifier: "MyPlantsToResult", sender: nil)
            }
        }catch{print("Cant get detail ")}
    
    }
    //for resize image
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0 ,y: 0 ,width: newSize.width ,height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!.withRenderingMode(.alwaysOriginal)
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
