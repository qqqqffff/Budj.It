// swiftlint:disable all
import Amplify
import Foundation

extension UserProfile {
  // MARK: - CodingKeys 
   public enum CodingKeys: String, ModelKey {
    case owner
    case email
    case firstName
    case lastName
    case authenticated
    case premium
    case createdAt
    case updatedAt
    case userBudgets
  }
  
  public static let keys = CodingKeys.self
  //  MARK: - ModelSchema 
  
  public static let schema = defineSchema { model in
    let userProfile = UserProfile.keys
    
    model.authRules = [
      rule(allow: .owner, ownerField: "owner", identityClaim: "cognito:username", provider: .userPools, operations: [.read, .delete]),
      rule(allow: .groups, groupClaim: "cognito:groups", groups: ["ADMINS"], provider: .userPools, operations: [.create, .update, .delete, .read])
    ]
    
    model.listPluralName = "UserProfiles"
    model.syncPluralName = "UserProfiles"
    
    model.attributes(
      .index(fields: ["owner"], name: nil),
      .primaryKey(fields: [userProfile.owner])
    )
    
    model.fields(
      .field(userProfile.owner, is: .required, ofType: .string),
      .field(userProfile.email, is: .required, ofType: .string),
      .field(userProfile.firstName, is: .required, ofType: .string),
      .field(userProfile.lastName, is: .required, ofType: .string),
      .field(userProfile.authenticated, is: .optional, ofType: .bool),
      .field(userProfile.premium, is: .optional, ofType: .bool),
      .field(userProfile.createdAt, is: .required, ofType: .dateTime),
      .field(userProfile.updatedAt, is: .required, ofType: .dateTime),
      .hasMany(userProfile.userBudgets, is: .optional, ofType: UserBudgetItem.self, associatedFields: [UserBudgetItem.keys.ownerProfile])
    )
    }
    public class Path: ModelPath<UserProfile> { }
    
    public static var rootPath: PropertyContainerPath? { Path() }
}

extension UserProfile: ModelIdentifiable {
  public typealias IdentifierFormat = ModelIdentifierFormat.Custom
  public typealias IdentifierProtocol = ModelIdentifier<Self, ModelIdentifierFormat.Custom>
}

extension UserProfile.IdentifierProtocol {
  public static func identifier(owner: String) -> Self {
    .make(fields:[(name: "owner", value: owner)])
  }
}
extension ModelPath where ModelType == UserProfile {
  public var owner: FieldPath<String>   {
      string("owner") 
    }
  public var email: FieldPath<String>   {
      string("email") 
    }
  public var firstName: FieldPath<String>   {
      string("firstName") 
    }
  public var lastName: FieldPath<String>   {
      string("lastName") 
    }
  public var authenticated: FieldPath<Bool>   {
      bool("authenticated") 
    }
  public var premium: FieldPath<Bool>   {
      bool("premium") 
    }
  public var createdAt: FieldPath<Temporal.DateTime>   {
      datetime("createdAt") 
    }
  public var updatedAt: FieldPath<Temporal.DateTime>   {
      datetime("updatedAt") 
    }
  public var userBudgets: ModelPath<UserBudgetItem>   {
      UserBudgetItem.Path(name: "userBudgets", isCollection: true, parent: self) 
    }
}