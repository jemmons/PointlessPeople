import Foundation
import CoreData



@objc(Company) public class Company: NSManagedObject {
  @NSManaged public var name: String
  @NSManaged public var employees: Set<Person>
}
