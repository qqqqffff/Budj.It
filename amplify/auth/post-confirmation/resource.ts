import { defineFunction } from "@aws-amplify/backend";

export const postConfirmation = defineFunction({
  name: 'post-confirmation',
  resourceGroupName: 'auth',
  entry: './handler.ts',
  runtime: 20
})