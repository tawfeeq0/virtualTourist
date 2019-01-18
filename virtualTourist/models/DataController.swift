//
//  DataController.swift
//  virtualTourist
//
//  Created by Tawfeeq on 25/12/2018.
//  Copyright © 2018 tam. All rights reserved.
//

import Foundation
import CoreData

class DataController{
    let persistentContainer:NSPersistentContainer
    
    var context:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { storeDescripation , error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
