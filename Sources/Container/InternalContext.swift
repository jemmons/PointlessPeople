import Foundation
import CoreData



internal protocol InternalContext {
  var context: NSManagedObjectContext? { get }
}



internal protocol ProvidesContext {
  static var context: NSManagedObjectContext? { get }
}
