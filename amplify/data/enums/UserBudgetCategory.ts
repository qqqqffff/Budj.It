import { a } from "@aws-amplify/backend";

export const UserBudgetCategory = a.enum([
  'Housing', 
  'Car', 
  'Food', 
  'Utilities', 
  'LoansAndCredit', 
  'SavingsAndInvestments', 
  'Transportation',
  'Entertainment',
  'Shopping',
  'Other'
])