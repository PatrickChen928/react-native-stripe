# Integrating Stripe with React Native and Supabase

This guide will walk you through the steps to integrate Stripe into a React Native app using Supabase for the database and Supabase's edge functions.

## Technologies Used

- [React Native](https://reactnative.dev/)
- [Expo](https://expo.dev/)
- [Supabase](https://supabase.com/): Supabase is an open source Firebase alternative.
- [Supabase Edge Functions](https://supabase.com/docs/guides/functions): Edge Functions are server-side TypeScript functions, distributed globally at the edge—close to your users. They can be used for listening to webhooks or integrating your Supabase project with third-parties like Stripe.
- [Supabase stripe webhooks](https://github.com/supabase/supabase/blob/master/examples/edge-functions/supabase/functions/stripe-webhooks/README.md)
- [Stripe](https://stripe.com/)
- [Stripe React Native SDK](https://docs.stripe.com/libraries/react-native)

## Step 1: Dependencies

```bash
npm i @stripe/stripe-react-native @supabase/supabase-js
```

## Step 2: Supabase

### 1. Initialize Supabase 
```bash
npm i supabase -g

supabase init

## or 

npx supabase init
```

### 2. Create Edge Function 
```bash
supabase functions new payment-sheet
```

### 3. Run sql create customers table
```sql
/**
* CUSTOMERS
* Note: this is a private table that contains a mapping of user IDs to Stripe customer IDs.
*/
create table customers (
  -- UUID from auth.users
  id uuid references auth.users not null primary key,
  -- The user's customer ID in Stripe. User must not be able to update this.
  stripe_customer_id text
);
alter table customers enable row level security;
-- Users can read own customer ID
CREATE POLICY "Can read own data" ON public.customers FOR SELECT USING ((auth.uid() = id));
```

### Step 3: Code

### 1. Initialize stripe client

```js
// APP.tsx
import { StripeProvider } from '@stripe/stripe-react-native';

function App() {
  return (
    <StripeProvider
      publishableKey="pk_test_51P9zrQBYf0B0tpE1Fb1vIPe6cDvgNHzMNVt7QMztkdShZZ53RNB06c7UfS8djVhr8Y5ERO6MZ264KnQHrursm1eZ001M3vjvzJ"
      urlScheme="your-url-scheme" // required for 3D Secure and bank redirects
      merchantIdentifier="merchant.com.{{YOUR_APP_NAME}}" // required for Apple Pay
    >
      // Your app code here
    </StripeProvider>
  );
}
```
> Add an STRIPE_SECRET_KEY secret in supabase dashboard: https://supabase.com/dashboard/project/[projectId]/settings/functions
```js
// supabase/functions/_utils/stripe.ts
import Stripe from 'https://esm.sh/stripe@11.1.0?target=deno'

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY') as string, {
  // This is needed to use the Fetch API rather than relying on the Node http
  // package.
  apiVersion: '2022-11-15',
  httpClient: Stripe.createFetchHttpClient(),
})
```

### 2. Initialize paymentIntents
```js
// supabase/functions/payment-sheet/index.ts

// create or retrieve customer with userId
const customer = await createOrRetrieveCustomer(authHeader);

// Create an ephermeralKey so that the Stripe SDK can fetch the customer's stored payment methods.
const ephemeralKey = await stripe.ephemeralKeys.create(
  { customer: customer },
  { apiVersion: "2020-08-27" }
);

// Create a PaymentIntent so that the SDK can charge the logged in customer.
const paymentIntent = await stripe.paymentIntents.create({
  amount: 1099,
  currency: "usd",
  customer: customer,
});
```

### 3. Component
```js
import {
  initStripe,
  useStripe,
  PaymentSheet,
  PaymentSheetError,
} from "@stripe/stripe-react-native";

const { initPaymentSheet, presentPaymentSheet } = useStripe();

// 1. run edge function
const { data, error } = await supabase.functions.invoke<FunctionResponse>("payment-sheet");

// 2. initializePaymentSheet
await initStripe({
  publishableKey: data.stripe_pk,
  merchantIdentifier: "merchant.com.stripe.react.native",
});
// 3. initPaymentSheet
await initPaymentSheet({
  customerId: customer,
  customerEphemeralKeySecret: ephemeralKey,
  paymentIntentClientSecret: paymentIntent,
  customFlow: false,
  merchantDisplayName: "Example Inc.",
  applePay: true,
  merchantCountryCode: "US",
  style: "automatic",
  testEnv: true,
  primaryButtonColor: "#635BFF", // Blurple
  defaultBillingDetails: billingDetails,
  allowsDelayedPaymentMethods: true,
});

// 4. openPaymentSheet
await presentPaymentSheet();
```

## Step 3: Deploy edge function
```bash
supabase functions deploy payment-sheet
```
