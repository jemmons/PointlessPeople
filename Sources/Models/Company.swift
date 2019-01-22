import Foundation
import CoreData



@objc(Company)
final public class Company: NSManagedObject {
  @NSManaged public var name: String
  @NSManaged public var employees: Set<Person>
}



extension Company: Manageable {}
