import { a } from "@aws-amplify/backend";

export const UserProfileModel = a.model({
  owner: a.string().required(),
  email: a.string().required(),
  firstName: a.string().required(),
  lastName: a.string().required(),
  authenticated: a.boolean(),
  userBudgets: a.hasMany('UserBudgetItem', 'owner')
})
.authorization(allow => [
  allow.owner().to([
    'read',
    'delete'
  ]),
  allow.group('ADMINS')
])
.identifier(['owner'])