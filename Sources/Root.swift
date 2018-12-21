import Foundation
import CoreData

public enum PersonStack {
  public static let container = NSPersistentContainer(name: "DataThing")

  public static func load() {
    container.loadPersistentStores { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    }
  }
}

