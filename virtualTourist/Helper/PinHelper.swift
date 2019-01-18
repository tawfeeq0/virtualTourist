//
//  Pin.swift
//  virtualTourist
//
//  Created by Tawfeeq on 26/12/2018.
//  Copyright © 2018 tam. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class PinHelper{
    static func add(latitude: Double ,longitude: Double,context:NSManagedObjectContext) -> Pin {
        let pin = Pin(context: context)
        pin.latitude = latitude
        pin.longitude = longitude
        do
        {
            try context.save()
        }
        catch
        {
            print(error)
        }
        return pin
    }
    
    static func getPins(context:NSManagedObjectContext) -> [Pin]{
        var pins: [Pin] = []
        let fetchRequest = NSFetchRequest<Pin>(entityName: "Pin")
        do {
            pins = try context.fetch(fetchRequest)
        } catch {
            fatalError("error fetching : \(error.localizedDescription)")
        }
        
        return pins
    }
    
    static func getPinByCoordination(pins:[Pin],coordinate:CLLocationCoordinate2D?)->Pin?{
        guard let coordinate = coordinate else {
            return nil
        }
        for pin in pins {
            if pin.latitude == coordinate.latitude && pin.longitude == coordinate.longitude {
                return pin
            }
        }
        return nil
    }
}
