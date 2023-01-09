//
//  HistoryViewController.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 2.12.2022.
//

import UIKit
import CoreData

class HistoryViewController: UIViewController  , UITableViewDelegate , UITableViewDataSource {
    
    var plantNameArray = [String]()
    var plantIdArray = [UUID]()

    
    @IBOutlet weak var HistoryTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HistoryTableView.delegate = self
        HistoryTableView.dataSource = self
        self.HistoryTableView.reloadData()
        getData()
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plantIdArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = HistoryTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = plantNameArray[indexPath.row]
        
        return cell
        
        
    }
    
    
    @objc func getData() {
        
        plantNameArray.removeAll(keepingCapacity: false)
        plantIdArray.removeAll(keepingCapacity: false)

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryPlantData")
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
                              
                                self.HistoryTableView.reloadData()
                                
                            }
            }
            

        } catch {
            print("error")
        }
        
    }
    
    @IBAction func deleteAllHistory(_ sender: Any) {
   
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "HistoryPlantData")
        

        let deleteRequest = NSBatchDeleteRequest(
            fetchRequest: fetchRequest
        )


        deleteRequest.resultType = .resultTypeObjectIDs

        let context = appDelegate.persistentContainer.viewContext
        
        // Perform the batch delete
        let batchDelete = try? context.execute(deleteRequest)  as? NSBatchDeleteResult
        
        guard let deleteResult = batchDelete?.result
            as? [NSManagedObjectID]
            else { return }

        let deletedObjects: [AnyHashable: Any] = [
            NSDeletedObjectsKey: deleteResult
        ]

        // Merge the delete changes into the managed
        // object context
        NSManagedObjectContext.mergeChanges(
            fromRemoteContextSave: deletedObjects,
            into: [context]
        )
        
        plantNameArray.removeAll(keepingCapacity: false)
        plantIdArray.removeAll(keepingCapacity: false)

        self.HistoryTableView.reloadData()

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
