//
//  CoreDataHandler.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 22.12.2022.
//

import Foundation
import CoreData
import UIKit

class CoreDataHandler{
    
    
    func saveData (savePlantName : String){
        
        let appDel = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let plantObject = NSEntityDescription.insertNewObject(forEntityName: "SavedPlantData", into: context) as! SavedPlantData
        plantObject.plantName = savePlantName
        plantObject.date = Date()
        do{
            try context.save()
            
        }catch{print("Error has been occured during save data..")}
        
        
    }
    
    
    
    func addHistory (savePlantName : String){
        
        let appDel = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        let plantObject = NSEntityDescription.insertNewObject(forEntityName: "HistoryPlantData", into: context) as! HistoryPlantData
        plantObject.plantName = savePlantName
        
        do{
            try context.save()
            fetchData()
        }catch{print("Error has been occured during save data..")}
        
        
        
        
        
    }
    
    func fetchData()-> [SavedPlantData]{
        
        var plantData = [SavedPlantData]()
        let appDel = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        do{
            plantData = try context.fetch(SavedPlantData.fetchRequest()) as! [SavedPlantData]
            
   
        }catch{
            print("Error has been occured fetch request..")}

        return plantData
    }
    
    func fetchHistoryData()-> [HistoryPlantData]{
        
        var plantData = [HistoryPlantData]()
        let appDel = (UIApplication.shared.delegate) as! AppDelegate
        let context = appDel.persistentContainer.viewContext
        do{
            plantData = try context.fetch(SavedPlantData.fetchRequest()) as! [HistoryPlantData]
        }catch{
            print("Error has been occured fetch request..")}

        return plantData
    }
    
    
    func deleteObjectsfromCoreData(context:NSManagedObjectContext) {
        
        let fetchRequest = NSFetchRequest<SavedPlantData>(entityName: "plantName")
        
        do{     let plantObject = try context.fetch(fetchRequest)
            _=plantObject.map({context.delete($0)})
            try context.save()

        }catch{print("Deleting error")}
        
    
        
    }
   
    
    
    
}
