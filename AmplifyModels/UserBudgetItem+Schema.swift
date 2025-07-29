// swiftlint:disable all
import Amplify
import Foundation

extension UserBudgetItem {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case id
    case category
    case amount
    case max
    case evalMonth
    case evalYear
    case displayPercent
    case ownerProfile
    case createdAt
    case updatedAt
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userBudgetItem = UserBudgetItem.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.create, .update, .delete, .read]),
      rule(allow: .groups, groupClaim: "cognito:groups", groups: ["ADMINS"], provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "UserBudgetItems"
    model.syncPluralName = "UserBudgetItems"
    
    model.attributes(
      .index(fields: ["id"], name: nil),
      .index(fields: ["evalYear", "evalMonth"], name: "userBudgetItemsByEvalYearAndEvalMonth"),
      .primaryKey(fields: [userBudgetItem.id])
    )
    
    model.fields(
      .field(userBudgetItem.id, is: .required, ofType: .string),
      .field(userBudgetItem.category, is: .optional, ofType: .enum(type: UserBudgetItemCategory.self)),
      .field(userBudgetItem.amount, is: .required, ofType: .double),
      .field(userBudgetItem.max, is: .required, ofType: .double),
      .field(userBudgetItem.evalMonth, is: .required, ofType: .int),
      .field(userBudgetItem.evalYear, is: .required, ofType: .int),
      .field(userBudgetItem.displayPercent, is: .optional, ofType: .bool),
      .belongsTo(userBudgetItem.ownerProfile, is: .optional, ofType: UserProfile.self, targetNames: ["owner"]),
      .field(userBudgetItem.createdAt, is: .optional, isReadOnly: true, ofType: .dateTime),
      .field(userBudgetItem.updatedAt, is: .optional, isReadOnly: true, ofType: .dateTime)
    )
    }
    public class Path: ModelPath<UserBudgetItem> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension UserBudgetItem: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Default
  public typealias IdentifierProtocol = DefaultModelIdentifier<Self>
}
extension ModelPath where ModelType == UserBudgetItem {
  public var id: FieldPath<String>   {
      string("id") 
    }
  public var amount: FieldPath<Double>   {
      double("amount") 
    }
  public var max: FieldPath<Double>   {
      double("max") 
    }
  public var evalMonth: FieldPath<Int>   {
      int("evalMonth") 
    }
  public var evalYear: FieldPath<Int>   {
      int("evalYear") 
    }
  public var displayPercent: FieldPath<Bool>   {
      bool("displayPercent") 
    }
  public var ownerProfile: ModelPath<UserProfile>   {
      UserProfile.Path(name: "ownerProfile", parent: self) 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
}