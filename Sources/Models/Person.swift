import Foundation
import CoreData



@objc(Person)
final public class Person: NSManagedObject {
  @NSManaged public var firstName: String
  @NSManaged public var lastName: String
  @NSManaged public var company: Company?
}



extension Person: Manageable {
  public static var defaultSortDescriptors: [NSSortDescriptor] {
    return [
      NSSortDescriptor(keyPath: \Person.lastName, ascending: true),
      NSSortDescriptor(keyPath: \Person.firstName, ascending: true),
    ]
  }
}


extension Person: ProvidesContext {
  static var context: NSManagedObjectContext? {
    return (container as! InternalContext).context
  }
}
