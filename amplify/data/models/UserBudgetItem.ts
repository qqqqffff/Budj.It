import { a } from "@aws-amplify/backend";
import { UserBudgetCategory } from "../enums/UserBudgetCategory";

export const UserBudgetItemModel = a.model({
  id: a.id().required(),
  category: UserBudgetCategory,
  amount: a.float().required().validate(v => v.gt(0, 'Budget amount must be greater than 0')),
  max: a.float().required().validate(v => v.gt(0, 'Budget amount must be greater than 0')),
  evalMonth: a.integer().required().default(new Date().getMonth()),
  evalYear: a.integer().required().default(new Date().getFullYear()),
  displayPercent: a.boolean(),
  owner: a.string().authorization(allow => [allow.owner().to(['read', 'delete'])]),
  ownerProfile: a.belongsTo('UserProfile', 'owner')
})
.authorization(allow => [
  allow.owner().to([ 
    'create', 
    'update', 
    'delete', 
    'read'
  ]), 
  allow.group('ADMINS')
])
.secondaryIndexes((index) => [index('evalYear').sortKeys(['evalMonth'])])
.identifier(['id'])