# Supabase Rules

## Version Pins
- Supabase JS: `@supabase/supabase-js` v2+
- SSR helper: `@supabase/ssr` (required for Next.js/SvelteKit server-side usage)

## Client Setup

### Browser Client (Client Components)
```typescript
import { createBrowserClient } from '@supabase/ssr'

export function createClient() {
  return createBrowserClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!
  )
}
```

### Server Client (Server Components, Route Handlers, Server Actions)
```typescript
import { createServerClient } from '@supabase/ssr'
import { cookies } from 'next/headers'

export async function createClient() {
  const cookieStore = await cookies()
  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() { return cookieStore.getAll() },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options))
        },
      },
    }
  )
}
```

### Middleware (Session Refresh)
```typescript
import { createServerClient } from '@supabase/ssr'
import { NextResponse, type NextRequest } from 'next/server'

export async function middleware(request: NextRequest) {
  let supabaseResponse = NextResponse.next({ request })
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        getAll() { return request.cookies.getAll() },
        setAll(cookiesToSet) {
          cookiesToSet.forEach(({ name, value }) => request.cookies.set(name, value))
          supabaseResponse = NextResponse.next({ request })
          cookiesToSet.forEach(({ name, value, options }) =>
            supabaseResponse.cookies.set(name, value, options))
        },
      },
    }
  )
  await supabase.auth.getUser()
  return supabaseResponse
}
```

## Auth Patterns
- OAuth: `supabase.auth.signInWithOAuth({ provider: 'github' })`
- Email/password: `supabase.auth.signUp({ email, password })` / `signInWithPassword`
- Session refresh: always call `supabase.auth.getUser()` in middleware
- Use `getUser()` not `getSession()` for server-side auth checks (session can be spoofed)

## Row Level Security (RLS)
- RLS is ALWAYS ON in production — no exceptions
- Every table needs at least one policy
- Policy patterns:
  - `auth.uid() = user_id` for user-owned rows
  - `auth.jwt() ->> 'role' = 'admin'` for role-based access
- Test policies with different user contexts

## Database Queries
```typescript
// Select
const { data, error } = await supabase.from('posts').select('*, author:profiles(name)')

// Insert
const { data, error } = await supabase.from('posts').insert({ title, content }).select()

// Update
const { data, error } = await supabase.from('posts').update({ title }).eq('id', id).select()

// Delete
const { error } = await supabase.from('posts').delete().eq('id', id)

// RPC (database functions)
const { data, error } = await supabase.rpc('function_name', { param: value })
```

## Realtime
```typescript
const channel = supabase.channel('room').on(
  'postgres_changes',
  { event: '*', schema: 'public', table: 'messages' },
  (payload) => console.log(payload)
).subscribe()
```

## Storage
```typescript
// Upload
await supabase.storage.from('bucket').upload('path/file.png', file)
// Download
const { data } = supabase.storage.from('bucket').getPublicUrl('path/file.png')
```

## Edge Functions
- Deploy: `supabase functions deploy function-name`
- Runtime: Deno — use `Deno.serve` pattern
- Access Supabase client via `createClient` with `Authorization` header from request

## Environment Variables
```
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key  # Server-only, never expose
```

## DO NOT
- Disable RLS in production
- Expose `service_role` key in client-side code
- Use `getSession()` for server-side auth validation (use `getUser()`)
- Skip middleware session refresh (causes stale auth)
- Use `supabase-js` v1 patterns (deprecated)
