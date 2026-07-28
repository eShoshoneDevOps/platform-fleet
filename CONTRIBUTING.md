# Contributing to platform-fleet

Lightweight SDLC for this repo, adopted 2026-07-17. Same convention
peptide-tracker uses — applies here so both repos stand on the same
process instead of each having its own tribal rules.

## Ticket keys

`PLAT-<n>`, sequential. Tickets filed by other repos (e.g. peptide-tracker)
against platform-fleet land in `tickets/inbound/` here; tickets this repo
files against another repo go in that repo's inbound equivalent. See
`tickets/BACKLOG.md` for the current board (gitignored — local planning
only, not part of repo history).

## Workflow

1. **Branch per ticket** — `feature/<TICKET-KEY>-<short-desc>`, e.g.
   `feature/PLAT-1-metallb-l2-arp`. Never commit straight to `main`.
2. **Commit messages reference the ticket key** — e.g.
   `PLAT-1: switch MetalLB to BGP mode`.
3. **Real PR per branch** (`gh pr create`) with a summary + test plan,
   even solo. Forces the change to stand on its own without needing
   tribal knowledge from the session that wrote it.
4. **Independent review pass before merge** — a fresh review pass with
   no context from the implementation (e.g. `/code-review` in a clean
   context, or an actual second set of eyes), to catch what the author
   is too close to see.
5. **Tag releases at milestone boundaries** with semver (`vX.Y.Z`) on
   the repo itself, once a PR lands that closes out a meaningful unit
   of work — not on every merge.

## No enforced branch protection

This repo is private on the free plan, which doesn't support required
reviews or status checks as an actual GitHub setting. The workflow above
is discipline-only, not a repo setting — same acknowledgment
peptide-tracker makes for the same reason. Don't claim enforcement that
isn't there.

## Why

Both repos were single-branch/no-tags before this. The ticket-per-branch
+ PR + independent-review loop is cheap insurance against "it worked when
I wrote it" — the review pass has to be convinced by the PR description
and diff alone, same bar a real second engineer would apply.
