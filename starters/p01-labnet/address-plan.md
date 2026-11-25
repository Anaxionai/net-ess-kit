# Address plan: the clinic's office

Block: `10.20.0.0/22`. Today: 40 staff devices, 60 guest Wi-Fi devices, 10 servers. Each group may double within two years.

<!-- TODO(task 8): work out each subnet's size and prefix, place the largest first on its own block boundary, then fill every cell. -->

| Subnet | Purpose | Prefix | Network | Gateway | First host | Last host | Broadcast | Usable | Needed now | Needed in 2 years |
|---|---|---|---|---|---|---|---|---|---|---|
| Staff | Staff laptops and printers | | | | | | | | 40 | |
| Guest | Guest Wi-Fi | | | | | | | | 60 | |
| Servers | Servers | | | | | | | | 10 | |
| Spare | Not used yet | | | — | — | — | — | | 0 | — |

## Growth

<!-- TODO(task 8): the office needs 60 more guest devices next year. What does your plan do, and what would you change? -->

## Why these sizes

<!-- TODO(task 8): one sentence per subnet on the prefix you chose. -->
