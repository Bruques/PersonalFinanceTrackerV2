//
//  CoreDataStack.swift
//  PersonalFinanceTracker
//
//  Created by Bruno Marques on 31/03/25.
//

import Foundation
import CoreData

class CoreDataStack: ObservableObject {
    static let shared = CoreDataStack()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PersonalFinanceTrackerV2")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent stores: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    private init() {}
}

extension CoreDataStack {
    // TODO: - Use throw on this method
    func save()  {
        guard persistentContainer.viewContext.hasChanges else { return }
        do {
            try persistentContainer.viewContext.save()
            print("Salvo com sucesso!")
        } catch {
            print("Failed to save the context:", error.localizedDescription)
        }
    }
}

// MARK: - Delete all categories from DB
extension CoreDataStack {
    func deleteAllCategories(context: NSManagedObjectContext = CoreDataStack.shared.persistentContainer.viewContext) {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()

        do {
            let categories = try context.fetch(fetchRequest)
            for category in categories {
                context.delete(category)
            }
            try context.save()
            print("Todas as categorias foram removidas.")
        } catch {
            print("Erro ao remover todas as categorias: \(error)")
        }
    }
}
