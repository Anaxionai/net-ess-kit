# Guided starters

Every project has three levels. **Core** students start from an empty folder. **Guided** students start from a starter here. **Stretch** students do Core plus the project's Stretch goals. Your mentor tells you your level.

A starter takes away the set-up that is not the point of the project: file layouts, table headings, diagram frames, script frames and configuration that only repeats what you already did. **It never holds the answers.** Every piece a task asks you to work out is marked `TODO(task N)`, where N is the task's number in that project.

| Starter | Copy it as | First task that uses it | Copy command |
|---|---|---|---|
| `p01-labnet/` | `labnet/` | P1 task 8 | Ubuntu terminal: `cp -r ~/net-ess-kit/starters/p01-labnet labnet` |
| `p02-officelab/` | `officelab/` | P2 task 7 | Git Bash: `cp -r ~/net-ess-kit/starters/p02-officelab officelab` |
| `p03-cloudnet/` | `cloudnet/` | P3 task 7 | Git Bash: `cp -r ~/net-ess-kit/starters/p03-cloudnet cloudnet` |

Run the copy command in the task's folder, the one your brief names. Each starter's `STARTER.md` lists what is included, every TODO with its task, and what you still write yourself. After the first task, you copy your own folder forward from task to task, as the briefs say: never copy the starter again, or you lose your work.

Find every TODO left in a folder with:

```bash
grep -rn "TODO(task" labnet/
```
