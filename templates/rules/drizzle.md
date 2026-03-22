# Drizzle ORM Rules

## Version Pins
- Drizzle ORM: 0.35+
- Drizzle Kit: 0.30+

## Driver Patterns

### PostgreSQL (async)
```typescript
import { drizzle } from 'drizzle-orm/postgres-js'
import postgres from 'postgres'

const client = postgres(process.env.DATABASE_URL!)
export const db = drizzle(client)

// Queries are async
const users = await db.select().from(usersTable)
```

### SQLite with better-sqlite3 (sync)
```typescript
import { drizzle } from 'drizzle-orm/better-sqlite3'
import Database from 'better-sqlite3'

const sqlite = new Database('sqlite.db')
// Enable WAL mode for better concurrent performance
sqlite.pragma('journal_mode = WAL')
export const db = drizzle(sqlite)

// IMPORTANT: Sync driver — use .all() and .get()
const users = db.select().from(usersTable).all()
const user = db.select().from(usersTable).where(eq(usersTable.id, id)).get()
```

### Neon Serverless (async)
```typescript
import { drizzle } from 'drizzle-orm/neon-http'
import { neon } from '@neondatabase/serverless'

const sql = neon(process.env.DATABASE_URL!)
export const db = drizzle(sql)
```

## Schema Definition

### PostgreSQL
```typescript
import { pgTable, text, timestamp, boolean, integer, uuid } from 'drizzle-orm/pg-core'

export const users = pgTable('users', {
  id: uuid('id').defaultRandom().primaryKey(),
  email: text('email').notNull().unique(),
  name: text('name'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull().$onUpdate(() => new Date()),
})

export const posts = pgTable('posts', {
  id: uuid('id').defaultRandom().primaryKey(),
  title: text('title').notNull(),
  content: text('content'),
  published: boolean('published').default(false).notNull(),
  authorId: uuid('author_id').notNull().references(() => users.id),
  createdAt: timestamp('created_at').defaultNow().notNull(),
})
```

### SQLite
```typescript
import { sqliteTable, text, integer } from 'drizzle-orm/sqlite-core'

export const users = sqliteTable('users', {
  id: integer('id').primaryKey({ autoIncrement: true }),
  email: text('email').notNull().unique(),
  name: text('name'),
  createdAt: text('created_at').$defaultFn(() => new Date().toISOString()),
})
```

## Relations API
```typescript
import { relations } from 'drizzle-orm'

export const usersRelations = relations(users, ({ many }) => ({
  posts: many(posts),
}))

export const postsRelations = relations(posts, ({ one }) => ({
  author: one(users, { fields: [posts.authorId], references: [users.id] }),
}))
```

## Query Patterns
```typescript
import { eq, and, or, like, desc, asc, sql } from 'drizzle-orm'

// Select with conditions
const results = await db.select().from(users).where(eq(users.email, email))

// Select specific columns
const names = await db.select({ name: users.name }).from(users)

// Join
const postsWithAuthors = await db
  .select()
  .from(posts)
  .leftJoin(users, eq(posts.authorId, users.id))

// Insert
await db.insert(users).values({ email, name })

// Insert returning
const [newUser] = await db.insert(users).values({ email, name }).returning()

// Update
await db.update(users).set({ name: 'New Name' }).where(eq(users.id, id))

// Delete
await db.delete(users).where(eq(users.id, id))

// Relational queries (requires relations defined)
const usersWithPosts = await db.query.users.findMany({
  with: { posts: true },
})
```

## Migrations

### Development
```bash
# Push schema directly (no migration files — fast iteration)
npx drizzle-kit push
```

### Production
```bash
# Generate migration SQL files
npx drizzle-kit generate

# Apply migrations
npx drizzle-kit migrate
```

### drizzle.config.ts
```typescript
import { defineConfig } from 'drizzle-kit'

export default defineConfig({
  schema: './src/db/schema.ts',
  out: './drizzle',
  dialect: 'postgresql',  // or 'sqlite'
  dbCredentials: {
    url: process.env.DATABASE_URL!,
  },
})
```

## Type Inference
```typescript
import { InferSelectModel, InferInsertModel } from 'drizzle-orm'

type User = InferSelectModel<typeof users>
type NewUser = InferInsertModel<typeof users>
```

## DO NOT
- Forget `.all()` or `.get()` on sync drivers (better-sqlite3) — query won't execute
- Skip WAL mode for SQLite (`pragma('journal_mode = WAL')`)
- Mix `postgres` and `pg` (node-postgres) drivers — pick one
- Use `db.query.*` without defining relations first
- Forget to run `drizzle-kit generate` before deploying schema changes
- Use `drizzle-kit push` in production (use `generate` + `migrate`)
