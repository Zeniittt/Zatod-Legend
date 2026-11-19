---
name: zatod-design
description: Maintain agreed Zatod Legend design decisions and check project analysis, planning and changes against Design.md. Use for work in this repository, especially Hero config, combat, animation, replay and networking.
---

# Zatod design decisions

Read the repository-root [Design.md](../../../Design.md) before project work. Follow root [AGENTS.md](../../../AGENTS.md), and read the specific documents/code needed for the task. Do not load all reverse assets or chat histories by default.

## Check and maintain decisions

- Identify the relevant decision IDs and distinguish agreed design from implemented behavior and open brainstorming.
- When the user clearly agrees to or changes a decision, update Design.md in the same task, including its scope, date and implementation status. Record the final decision, not a transcript or an agent's unapproved proposal.
- If a proposed change conflicts with a decision and the user has not already authorized that change, explain the conflicting decision ID and concrete impact, and stop only that conflicting change for discussion. Continue independent, authorized work.
- A new explicit user instruction takes precedence over the old decision; update the record without asking the same permission again.
- Design agreement alone does not authorize immediate implementation. Respect brainstorm/read-only requests; documentation maintenance specifically requested by the user remains allowed.
- Keep Design.md as the single decision record. Update old docs or mark their historical scope when necessary instead of creating competing rules.

## Relevant context

- Use docs/crystal-legends-reference.txt for the copied source layout, prior chats and reverse-engineering evidence. Use the copy under the project, not the original C: path, for new project references.
- Preserve the difference between observed Crystal client/checker code and unknown backend behavior.
- For timing, distinguish action/animation progression, cooldown progression, projectile impact and buff duration. A release marker is not automatically a visible impact marker.
- Keep the current implementation status accurate after actual work and validation. Do not claim that documenting a design has implemented it.
