import { a } from "@aws-amplify/backend";

export const UserBudgetCategory = a.enum([
  'Housing', 
  'Car', 
  'Food', 
  'Utilities', 
  'Loans', 
  'Credit', 
  'Savings', 
  'Investments',
  'Transportation',
  'Entertainment',
  'Subscriptions',
  'Shopping',
  'Other'
])