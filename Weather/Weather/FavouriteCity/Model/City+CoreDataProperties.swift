//
//  City+CoreDataProperties.swift
//  Weather
//
//  Created by Thiyagu  on 16/03/21.
//  Copyright © 2021 Thiyagu . All rights reserved.
//
import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var cityID: Int16
    @NSManaged public var cityName: String?
    @NSManaged public var weatherDetails: String?

}
