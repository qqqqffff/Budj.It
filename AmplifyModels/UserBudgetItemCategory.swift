// swiftlint:disable all
import Amplify
import Foundation

public enum UserBudgetItemCategory: String, EnumPersistable {
  case housing = "Housing"
  case car = "Car"
  case food = "Food"
  case utilities = "Utilities"
  case loansAndCredit = "LoansAndCredit"
  case savingsAndInvestments = "SavingsAndInvestments"
  case transportation = "Transportation"
  case entertainment = "Entertainment"
  case shopping = "Shopping"
  case other = "Other"
}