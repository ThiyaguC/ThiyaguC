//
//  CoreDataStack.swift
//  Weather
//
//  Created by Thiyagu  on 16/03/21.
//  Copyright © 2019 Thiyagu . All rights reserved.
//

import Foundation
import CoreData
import UIKit


class CoreDataStack: NSObject {
    
    static let sharedInstance = CoreDataStack()
    private override init() {}
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    // MARK: - Add Data to Core Data 
    func createCityEntity(cityID: Int, cityName: String, weatherDetails: String) {
        
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        do {
            if let cityEntity = NSEntityDescription.insertNewObject(forEntityName: "City", into: context) as? City {
                cityEntity.setValue(cityID, forKey: "cityID")
                cityEntity.setValue(cityName, forKey: "cityName")
                cityEntity.setValue(weatherDetails, forKey: "weatherDetails")
            }
            try context.save()
        }catch _ {
            
        }
    }
    
    func addRemoveFromCoreData(cityID: Int, cityName: String, weatherDetails: String){
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        fetchRequest.predicate = NSPredicate(format:"cityName = %@", cityName)
        
        do {
            let objects = try context.fetch(fetchRequest)
            if objects.count <= 0 {
                self.createCityEntity(cityID: cityID, cityName: cityName, weatherDetails: weatherDetails)
            }else {
                self.removeFromFavourite(cityName: cityName)
            }
        } catch _ {
        }
    }
    
    func isFavouriteCity(cityID: Int, cityName: String, weatherDetails: String) -> Int{
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        fetchRequest.predicate = NSPredicate(format:"cityName = %@", cityName)
        do {
            let objects = try context.fetch(fetchRequest)
            return objects.count
        } catch _ {
            return 0
        }
    }
    
    // MARK: - Remove data from Core Data
    func removeFromFavourite(cityName: String) {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        fetchRequest.predicate = NSPredicate(format:"cityName = %@", cityName)
        
        do {
            let objects = try context.fetch(fetchRequest)
            for object in objects {
                context.delete(object as! NSManagedObject)
            }
            try context.save()
        } catch _ {
        }
    }
}



