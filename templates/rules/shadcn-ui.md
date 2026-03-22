# shadcn/ui Rules

## Installation
```bash
npx shadcn@latest init        # Initialize project
npx shadcn@latest add button  # Add individual components
npx shadcn@latest add -a      # Add all components
```

## Key Concepts
- Components live in `components/ui/` — they are YOUR code, not a package dependency
- You own and can modify every component freely
- Components are built on Radix UI primitives + Tailwind CSS

## Tailwind CSS v4 (Current)
- CSS-native configuration — use `@theme` in CSS, NOT `tailwind.config.js`
- `tailwind.config.js` is deprecated in v4

```css
/* app/globals.css */
@import "tailwindcss";
@import "tw-animate-css";

@custom-variant dark (&:is(.dark *));

@theme inline {
  --color-background: oklch(1 0 0);
  --color-foreground: oklch(0.145 0 0);
  --color-primary: oklch(0.205 0.042 264.695);
  --color-primary-foreground: oklch(0.985 0.002 264.695);
  --radius-sm: calc(var(--radius) - 4px);
  --radius-md: calc(var(--radius) - 2px);
  --radius-lg: var(--radius);
  --radius: 0.625rem;
}
```

## Color System
- Use OKLCH color space (NOT HSL — HSL is deprecated in shadcn v2+)
- Semantic tokens: `background`, `foreground`, `primary`, `secondary`, `muted`, `accent`, `destructive`
- Each color has a `-foreground` counterpart for text on that background

## `cn()` Utility
```typescript
import { cn } from "@/lib/utils"

// Merge classes with conflict resolution
<div className={cn("px-4 py-2", isActive && "bg-primary", className)} />
```

## Form Patterns (react-hook-form + Zod)
```typescript
import { useForm } from "react-hook-form"
import { zodResolver } from "@hookform/resolvers/zod"
import { z } from "zod"
import { Form, FormControl, FormField, FormItem, FormLabel, FormMessage } from "@/components/ui/form"

const formSchema = z.object({
  email: z.string().email(),
  name: z.string().min(2),
})

function MyForm() {
  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: { email: "", name: "" },
  })

  function onSubmit(values: z.infer<typeof formSchema>) {
    // Handle submission
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)}>
        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
      </form>
    </Form>
  )
}
```

## Dark Mode (next-themes)
```typescript
import { ThemeProvider } from "next-themes"

// In layout
<ThemeProvider attribute="class" defaultTheme="system" enableSystem>
  {children}
</ThemeProvider>

// Toggle
import { useTheme } from "next-themes"
const { setTheme, theme } = useTheme()
```

## Common Component Patterns
```typescript
// Dialog
import { Dialog, DialogContent, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"

// Sheet (slide-over panel)
import { Sheet, SheetContent, SheetHeader, SheetTitle, SheetTrigger } from "@/components/ui/sheet"

// Command palette
import { Command, CommandInput, CommandList, CommandItem } from "@/components/ui/command"

// Data table (tanstack/react-table)
import { DataTable } from "@/components/ui/data-table"
```

## DO NOT
- Import from `@shadcn/ui` — there is no such package. Components are local files
- Use `tailwindcss-animate` — use `tw-animate-css` instead (Tailwind v4 compatible)
- Use HSL for colors — use OKLCH (shadcn v2+ default)
- Use `tailwind.config.js` with Tailwind v4 — use CSS `@theme` instead
- Install shadcn components via npm — use `npx shadcn@latest add`
- Modify `node_modules` for component changes — edit `components/ui/` directly
