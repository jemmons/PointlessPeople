import Foundation
import CoreData



public protocol Manageable: NSFetchRequestResult {
  static var entityName: String { get }
  static var defaultSortDescriptors: [NSSortDescriptor] { get }
}



public extension Manageable {
  static var defaultSortDescriptors: [NSSortDescriptor] {
    return []
  }
  
  
  static func request(descriptors: [NSSortDescriptor] = defaultSortDescriptors) -> NSFetchRequest<Self> {
    let request = NSFetchRequest<Self>(entityName: entityName)
    request.sortDescriptors = descriptors
    return request
  }
  
  
  static func resultsController(fetchRequest: NSFetchRequest<Self> = request(), delegate: NSFetchedResultsControllerDelegate? = nil) -> NSFetchedResultsController<Self> {
    guard let context = context.context else {
      return NSFetchedResultsController()
    }
    let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
    frc.delegate = delegate
    return frc
  }

  
  @discardableResult static func insert() -> Self {
    return NSEntityDescription.insertNewObject(forEntityName: entityName, into: internalContainer.context!) as! Self
  }
}



public extension Manageable where Self: NSManagedObject {
  static var entityName: String {
    guard let name = entity().name else {
      fatalError("Expected an entity name for “\(String(describing: self))”.")
    }
    return name
  }
}
