//
//  HistoryPlantData+CoreDataProperties.swift
//  PlantX
//
//  Created by Rabia Abdioğlu on 29.12.2022.
//
//

import Foundation
import CoreData


extension HistoryPlantData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<HistoryPlantData> {
        return NSFetchRequest<HistoryPlantData>(entityName: "HistoryPlantData")
    }

    @NSManaged public var plantName: String?

}

extension HistoryPlantData : Identifiable {

}
