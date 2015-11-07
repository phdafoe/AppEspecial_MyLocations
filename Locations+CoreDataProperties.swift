//
//  Locations+CoreDataProperties.swift
//  App_MyLocations
//
//  Created by User on 7/11/15.
//  Copyright © 2015 iCologic. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

// Fase 1 -> importancio de CoreLocation
import CoreLocation



extension Locations {

    // Fase 1 -> modificacion de estas dos propiedades
    // de aqui nos vamos al AppDelegate OOOOOJJJJOOOO
    //@NSManaged var placemark: NSObject?
    @NSManaged var placemark: CLPlacemark?
    @NSManaged var longitude: Double
    @NSManaged var locationDescription: String?
    @NSManaged var latitude: Double
    //@NSManaged var date: NSTimeInterval
    @NSManaged var date: NSDate
    @NSManaged var category: String?

}
