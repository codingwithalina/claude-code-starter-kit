---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
---

# Grill Me

Stress-test a plan, design, or architecture by interviewing the user relentlessly until every branch of the decision tree is resolved.

## Process

### 1. Understand the subject

Read the plan, PRD, or design document the user wants grilled. If none exists, ask the user to describe their approach.

### 2. Map the decision tree

Identify every branch point — places where a choice was made (or avoided). Common branches:

- **Scope**: What's included vs excluded? Why those boundaries?
- **Trade-offs**: What was sacrificed for what? Are those trade-offs still valid?
- **Assumptions**: What must be true for this to work? What happens if each assumption is wrong?
- **Edge cases**: What happens at scale? With bad input? When dependencies fail?
- **Alternatives**: What other approaches were considered? Why were they rejected?
- **Dependencies**: What does this depend on? What depends on this?
- **Sequencing**: Why this order? What could be parallelized?
- **Failure modes**: What happens when each component fails? Is recovery possible?

### 3. Interview relentlessly

Walk through each branch one at a time. For each:

1. Ask a specific, pointed question (not vague "what about X?")
2. Listen to the answer
3. Follow up if the answer is vague, hand-wavy, or assumes away complexity
4. Mark the branch as resolved only when the answer is concrete and actionable
5. Move to the next branch

**Rules:**
- One question at a time — never ask multiple questions in a batch
- If a question can be answered by exploring the codebase, explore the codebase instead of asking
- Don't accept "we'll figure that out later" — push for at least a directional answer
- Challenge assumptions respectfully but firmly
- If the user changes their mind, update your understanding and re-check dependent branches

### 4. Summarize

When all branches are resolved, provide a brief summary of:
- Key decisions made during the interview
- Assumptions that were validated or changed
- Remaining risks the user accepted consciously
