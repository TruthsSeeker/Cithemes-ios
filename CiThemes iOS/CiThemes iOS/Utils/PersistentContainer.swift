//
//  PersistentContainer.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 27/07/2022.
//

import Foundation
import CoreData

class PersistentContainer {
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CiThemes")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load stores \(error)")
            }
        }
        
        return container
    }()
    
    func saveContext() {
        let context = container.viewContext
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            //TODO: Error handling
            fatalError("Unhandled save error: \n\(nserror)\n \(nserror.userInfo)")
        }
    }
}
