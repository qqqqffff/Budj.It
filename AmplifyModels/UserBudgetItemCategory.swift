// swiftlint:disable all
import Amplify
import Foundation

public enum UserBudgetItemCategory: String, EnumPersistable {
  case housing = "Housing"
  case car = "Car"
  case food = "Food"
  case utilities = "Utilities"
  case loans = "Loans"
  case credit = "Credit"
  case savings = "Savings"
  case investments = "Investments"
  case transportation = "Transportation"
  case entertainment = "Entertainment"
  case subscriptions = "Subscriptions"
  case shopping = "Shopping"
  case other = "Other"
}