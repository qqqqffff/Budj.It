// swiftlint:disable all
import Amplify
import Foundation

public struct UserProfile: Model {
  public let owner: String
  public var email: String
  public var firstName: String
  public var lastName: String
  public var authenticated: Bool?
  public var premium: Bool?
  public var createdAt: Temporal.DateTime
  public var updatedAt: Temporal.DateTime
  public var userBudgets: List<UserBudgetItem>?
  
  public init(owner: String,
      email: String,
      firstName: String,
      lastName: String,
      authenticated: Bool? = nil,
      premium: Bool? = nil,
      createdAt: Temporal.DateTime,
      updatedAt: Temporal.DateTime,
      userBudgets: List<UserBudgetItem>? = []) {
      self.owner = owner
      self.email = email
      self.firstName = firstName
      self.lastName = lastName
      self.authenticated = authenticated
      self.premium = premium
      self.createdAt = createdAt
      self.updatedAt = updatedAt
      self.userBudgets = userBudgets
  }
}