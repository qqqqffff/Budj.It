import type { PostConfirmationTriggerHandler } from "aws-lambda";
import {
  CognitoIdentityProviderClient,
  AdminAddUserToGroupCommand
} from '@aws-sdk/client-cognito-identity-provider'
import { getAmplifyDataClientConfig } from "@aws-amplify/backend/function/runtime";
import { env } from "$amplify/env/post-confirmation"
import { Amplify } from "aws-amplify";
import { generateClient } from "aws-amplify/api";
import { Schema } from "../../data/resource";

const { resourceConfig, libraryOptions } = await getAmplifyDataClientConfig(env)
Amplify.configure(resourceConfig, libraryOptions)

const dynamoClient = generateClient<Schema>()
const client = new CognitoIdentityProviderClient()

export const handler: PostConfirmationTriggerHandler = async (event) => {
  const groupRandomizer = Math.random() > 0.5 ? "USERS" : "USERS-B"

  const command = new AdminAddUserToGroupCommand({
    GroupName: groupRandomizer,
    Username: event.userName,
    UserPoolId: event.userPoolId
  })

  const dynamoResponse = dynamoClient.models.UserProfile.create({
    owner: event.userName,
    email: event.request.userAttributes.email,
    firstName: event.request.userAttributes.given_name || "",
    lastName: event.request.userAttributes.family_name || "",
    authenticated: false,
    premium: false, 
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  })

  const userGroupResponse = client.send(command)

  await Promise.all([userGroupResponse])
  
  return event
}