//
//  SavedPlantData+CoreDataProperties.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 22.12.2022.
//
//

import Foundation
import CoreData


extension SavedPlantData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedPlantData> {
        return NSFetchRequest<SavedPlantData>(entityName: "SavedPlantData")
    }

    @NSManaged public var plantName: String?
    @NSManaged public var date: Date?

}

extension SavedPlantData : Identifiable {

}
