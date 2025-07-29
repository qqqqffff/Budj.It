// swiftlint:disable all
import Amplify
import Foundation

// Contains the set of classes that conforms to the `Model` protocol. 

final public class AmplifyModels: AmplifyModelRegistration {
  public let version: String = "7a8efe1524d828670de5bd8db9ddffb0"
  
  public func registerModels(registry: ModelRegistry.Type) {
    ModelRegistry.register(modelType: UserBudgetItem.self)
    ModelRegistry.register(modelType: UserProfile.self)
  }
}