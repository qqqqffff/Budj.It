// swiftlint:disable all
import Amplify
import Foundation

public struct UserBudgetItem: Model {
  public let id: String
  public var category: UserBudgetItemCategory?
  public var amount: Double
  public var max: Double
  public var evalMonth: Int
  public var evalYear: Int
  public var displayPercent: Bool?
  internal var _ownerProfile: LazyReference<UserProfile>
  public var ownerProfile: UserProfile?   {
      get async throws { 
        try await _ownerProfile.get()
      } 
    }
  public var createdAt: Temporal.DateTime?
  public var updatedAt: Temporal.DateTime?
  
  public init(id: String = UUID().uuidString,
      category: UserBudgetItemCategory? = nil,
      amount: Double,
      max: Double,
      evalMonth: Int,
      evalYear: Int,
      displayPercent: Bool? = nil,
      ownerProfile: UserProfile? = nil) {
    self.init(id: id,
      category: category,
      amount: amount,
      max: max,
      evalMonth: evalMonth,
      evalYear: evalYear,
      displayPercent: displayPercent,
      ownerProfile: ownerProfile,
      createdAt: nil,
      updatedAt: nil)
  }
  internal init(id: String = UUID().uuidString,
      category: UserBudgetItemCategory? = nil,
      amount: Double,
      max: Double,
      evalMonth: Int,
      evalYear: Int,
      displayPercent: Bool? = nil,
      ownerProfile: UserProfile? = nil,
      createdAt: Temporal.DateTime? = nil,
      updatedAt: Temporal.DateTime? = nil) {
      self.id = id
      self.category = category
      self.amount = amount
      self.max = max
      self.evalMonth = evalMonth
      self.evalYear = evalYear
      self.displayPercent = displayPercent
      self._ownerProfile = LazyReference(ownerProfile)
      self.createdAt = createdAt
      self.updatedAt = updatedAt
  }
  public mutating func setOwnerProfile(_ ownerProfile: UserProfile? = nil) {
    self._ownerProfile = LazyReference(ownerProfile)
  }
  public init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      id = try values.decode(String.self, forKey: .id)
      category = try? values.decode(UserBudgetItemCategory?.self, forKey: .category)
      amount = try values.decode(Double.self, forKey: .amount)
      max = try values.decode(Double.self, forKey: .max)
      evalMonth = try values.decode(Int.self, forKey: .evalMonth)
      evalYear = try values.decode(Int.self, forKey: .evalYear)
      displayPercent = try? values.decode(Bool?.self, forKey: .displayPercent)
      _ownerProfile = try values.decodeIfPresent(LazyReference<UserProfile>.self, forKey: .ownerProfile) ?? LazyReference(identifiers: nil)
      createdAt = try? values.decode(Temporal.DateTime?.self, forKey: .createdAt)
      updatedAt = try? values.decode(Temporal.DateTime?.self, forKey: .updatedAt)
  }
  public func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(id, forKey: .id)
      try container.encode(category, forKey: .category)
      try container.encode(amount, forKey: .amount)
      try container.encode(max, forKey: .max)
      try container.encode(evalMonth, forKey: .evalMonth)
      try container.encode(evalYear, forKey: .evalYear)
      try container.encode(displayPercent, forKey: .displayPercent)
      try container.encode(_ownerProfile, forKey: .ownerProfile)
      try container.encode(createdAt, forKey: .createdAt)
      try container.encode(updatedAt, forKey: .updatedAt)
  }
}