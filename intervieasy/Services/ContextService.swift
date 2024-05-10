//
//  ContextService.swift
//  intervieasy
//
//  Created by jevania on 08/05/24.
//


import CoreData
import UIKit

class ContextService {
    
    static let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static func saveChanges(){
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("error saving changes context")
            }
        }
    }
    
    static func fetchPractice(request : NSFetchRequest<Practice>) -> [Practice]{
        
        do {
            return try context.fetch(request)
        } catch  {
            print("error fetching practice")
        }
        
        return []
    }
    
    static func deletePractice(practice : Practice) {
        context.delete(practice)
        saveChanges()
    }
    
}
