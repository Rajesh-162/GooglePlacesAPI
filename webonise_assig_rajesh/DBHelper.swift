//
//  DBHelper.swift
//  webonise_assig_rajesh
//
//  Created by Rajesh on 10/06/17.
//  Copyright © 2017 Rajesh. All rights reserved.
//

import UIKit
import CoreData

class DBHelper: NSObject {

    // Get context
    func getContext() -> NSManagedObjectContext{
        return AppDelegate().persistentContainer.viewContext
    }
    
    // Save history data
    func save(searchText: String) -> Bool{        
        let context = getContext()
        let entity = NSEntityDescription.entity(forEntityName: "SearchHistory", in: context)
        let object = NSManagedObject(entity: entity!, insertInto: context)
        object.setValue(searchText, forKey: "searchText")
        do {
            try context.save()
            return true
        }
        catch{
            return false
        }
    }
    
    // Get history data
    func getSearchHistory(forText text: String) -> [String]{
        let request: NSFetchRequest<SearchHistory> = SearchHistory.fetchRequest()
        
        // Filter
        let predicate = NSPredicate(format: "searchText contains[c] %@", text)
        request.predicate = predicate
        
        var searchResults = [String]()
        do {
            searchResults = getRecordsInString(try getContext().fetch(request))
        } catch {
            print("Error with request: \(error)")
        }
        return searchResults
    }
    
    // Convert history data to readables
    private func getRecordsInString(_ records: [NSManagedObject]?) -> [String]{
        var values = [String]()
        if let fetchedData = records{
            for searchEntry in fetchedData{
                values.append(searchEntry.value(forKey: "searchText") as! String)
            }
        }
        return values
    }
}
