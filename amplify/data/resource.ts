import { type ClientSchema, a, defineData } from '@aws-amplify/backend';
import { UserProfileModel } from './models/UserProfile';
import { UserBudgetItemModel } from './models/UserBudgetItem';
import { postConfirmation } from '../auth/post-confirmation/resource';

const schema = a.schema({
  UserBudgetItem: UserBudgetItemModel,
  UserProfile: UserProfileModel
})
.authorization(allow => [
  allow.resource(postConfirmation)
]);

export type Schema = ClientSchema<typeof schema>;

export const data = defineData({
  schema,
  authorizationModes: {
    defaultAuthorizationMode: 'identityPool',
  },
});
