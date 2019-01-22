import Foundation
import CoreData


public class SQLiteContainer: Container {
  private var container: NSPersistentContainer?
  private let modelName: String
  
  
  public init(_ modelName: String) {
    self.modelName = modelName
  }
  
  
  public func establish(isWritable: Bool) throws {
    try establish(isWritable: isWritable, storeURL: nil)
  }
  
  
  public func establish(isWritable: Bool, storeURL: URL?) throws {
    guard container == nil else {
      return
    }
    let description = Helper.makeSyncSQLDescription(name: modelName, url: storeURL, isWritable: isWritable)
    let newContainer = Helper.makeContainer(name: modelName, description: description)
    try Helper.syncLoadStore(of: newContainer)
    container = newContainer
  }

  
  public func save() throws {
    guard let someContext = context else {
      return
    }
    
    if someContext.hasChanges {
      try someContext.save()
    }
  }
}



extension SQLiteContainer: InternalContext {
  internal var context: NSManagedObjectContext? {
    return container?.viewContext
  }
}



private enum Helper {
  private class Here {}
  
  
  static func makeSyncSQLDescription(name: String, url: URL?, isWritable: Bool) -> NSPersistentStoreDescription {
    let storeDescription = NSPersistentStoreDescription(url: url ?? makeDocumentURL(name: name))
    storeDescription.type = NSSQLiteStoreType
    storeDescription.isReadOnly = !isWritable
    storeDescription.shouldAddStoreAsynchronously = false
    return storeDescription
  }
  
  
  static func makeContainer(name: String, description: NSPersistentStoreDescription) -> NSPersistentContainer {
    let container = NSPersistentContainer(name: name, managedObjectModel: makeModel(with: name))
    container.persistentStoreDescriptions = [description]
    return container
  }
  
  
  static func syncLoadStore(of container: NSPersistentContainer) throws {
    var error: Error?
    
    let group = DispatchGroup()
    group.enter()
    container.loadPersistentStores { _, e in
      error = e
      group.leave()
    }
    group.wait()
    
    if let e = error {
      throw e
    }
  }
  
  
  private static func makeDocumentURL(name: String) -> URL {
    guard let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
      fatalError("Unable to find document directory.")
    }
    return url.appendingPathComponent("\(name).sqlite")
  }
  
  
  private static func makeModel(with name: String) -> NSManagedObjectModel {
    let url = makeModelURL(with: name)
    guard let model = NSManagedObjectModel(contentsOf: url) else {
      fatalError("Unable to read model from \(url).")
    }
    return model
  }
  
  
  private static func makeModelURL(with name: String) -> URL {
    let bundle = Bundle(for: Here.self)
    guard let url = bundle.url(forResource: name, withExtension: "momd") else {
      fatalError("Could not find “\(name).momd” in \(bundle.bundlePath).")
    }
    return url
  }
}
