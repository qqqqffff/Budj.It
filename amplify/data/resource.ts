import { type ClientSchema, a, defineData } from '@aws-amplify/backend';
import { UserProfileModel } from './models/UserProfile';
import { UserBudgetItemModel } from './models/UserBudgetItem';

const schema = a.schema({
  UserBudgetItem: UserBudgetItemModel,
  UserProfile: UserProfileModel
});

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: 'identityPool',
  },
});
