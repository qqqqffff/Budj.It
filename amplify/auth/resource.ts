import { defineAuth, secret } from '@aws-amplify/backend';

/**
 * Define and configure your auth resource
 * @see https://docs.amplify.aws/gen2/build-a-backend/auth
 */
export const auth = defineAuth({
  loginWith: {
    email: true,
    externalProviders: {
      logoutUrls: [
        "http://localhost:5173/logout",
        "https://www.budjit.net/logout"
      ],
      callbackUrls: [
        "http://localhost:5173/profile",
        "http://localhost:5173/plaid",
        "https://www.budjit.net/profile",
        "https://www.budjit.net/plaid",
      ],
      google: {
        clientId: secret('GOOGLE_CLIENT_ID'),
        clientSecret: secret('GOOGLE_CLIENT_SECRET')
      },
      signInWithApple: {
        clientId: secret('APPLE_CLIENT_ID'),
        teamId: secret('APPLE_TEAM_ID'),
        keyId: secret('APPLE_KEY_ID'),
        privateKey: secret('APPLE_PRIVATE_KEY')
      }
    }
  },
});
