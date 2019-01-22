import Foundation



public protocol Container {
  func save() throws
  func establish(isWritable: Bool, storeURL: URL?) throws
  func establish(isWritable: Bool) throws
}
