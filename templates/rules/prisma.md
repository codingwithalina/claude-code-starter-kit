# Prisma ORM Rules

## Version Pins
- Prisma CLI & Client: v7.x+ (latest major)
- Use `@prisma/client` for runtime, `prisma` for CLI

## Schema (`prisma/schema.prisma`)

```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"  // or "sqlite", "mysql"
  url      = env("DATABASE_URL")
}

model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String?
  posts     Post[]
  createdAt DateTime @default(now()) @map("created_at")
  updatedAt DateTime @updatedAt @map("updated_at")

  @@map("users")
}

model Post {
  id        String   @id @default(cuid())
  title     String
  content   String?
  published Boolean  @default(false)
  author    User     @relation(fields: [authorId], references: [id])
  authorId  String   @map("author_id")
  createdAt DateTime @default(now()) @map("created_at")

  @@index([authorId])
  @@map("posts")
}
```

### Schema Conventions
- Use `cuid()` or `uuid()` for IDs (not auto-increment for distributed systems)
- Map model names to snake_case table names with `@@map`
- Map field names to snake_case column names with `@map`
- Always add `createdAt`/`updatedAt` timestamps
- Add `@@index` for foreign keys and frequently queried fields
- Use enums for fixed value sets

## Client Generation
```bash
npx prisma generate  # After schema changes — regenerates client types
```

## Migrations
```bash
# Development — creates migration + applies it
npx prisma migrate dev --name descriptive_name

# Production — applies pending migrations
npx prisma migrate deploy

# Reset (dev only) — drops DB, re-applies all migrations
npx prisma migrate reset
```

## Query Patterns

```typescript
import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

// Find many with filtering and pagination
const users = await prisma.user.findMany({
  where: { email: { contains: '@example.com' } },
  orderBy: { createdAt: 'desc' },
  take: 20,
  skip: 0,
})

// Find unique (throws if not found with findUniqueOrThrow)
const user = await prisma.user.findUnique({ where: { id } })

// Create
const user = await prisma.user.create({
  data: { email, name },
})

// Update
const user = await prisma.user.update({
  where: { id },
  data: { name: 'New Name' },
})

// Upsert
const user = await prisma.user.upsert({
  where: { email },
  update: { name },
  create: { email, name },
})

// Delete
await prisma.user.delete({ where: { id } })
```

## Relation Loading
```typescript
// Include — loads full related records
const userWithPosts = await prisma.user.findUnique({
  where: { id },
  include: { posts: true },
})

// Select — pick specific fields (more efficient)
const userWithPostTitles = await prisma.user.findUnique({
  where: { id },
  select: {
    name: true,
    posts: { select: { title: true } },
  },
})
```

### Avoiding N+1
- Use `include` or `select` with relations instead of querying in a loop
- Use `findMany` with `where: { id: { in: ids } }` for batch lookups

## Transactions
```typescript
// Sequential transaction
const [user, post] = await prisma.$transaction([
  prisma.user.create({ data: userData }),
  prisma.post.create({ data: postData }),
])

// Interactive transaction
const result = await prisma.$transaction(async (tx) => {
  const user = await tx.user.findUnique({ where: { id } })
  if (!user) throw new Error('User not found')
  return tx.post.create({ data: { ...postData, authorId: user.id } })
})
```

## Singleton Pattern (Next.js / serverless)
```typescript
const globalForPrisma = globalThis as unknown as { prisma: PrismaClient }
export const prisma = globalForPrisma.prisma ?? new PrismaClient()
if (process.env.NODE_ENV !== 'production') globalForPrisma.prisma = prisma
```

## DO NOT
- Skip `prisma migrate dev` and use `db push` for production
- Use raw SQL when Prisma query API can express it
- Forget to run `prisma generate` after schema changes
- Create a new `PrismaClient()` per request (use singleton)
- Use `deleteMany` without a `where` clause (deletes all rows)
- Ignore TypeScript errors from Prisma — they indicate schema/query mismatches
