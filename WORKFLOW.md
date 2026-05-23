# Safe Workflow

`main` is the stable version of this repository.

## Default rule

Before any noticeable change:

1. create a working branch from `main`;
2. make changes only in that branch;
3. merge back to `main` only after verification.

## Quick start

From the project root:

```bash
./scripts/start-change.sh hero-fix
```

The script:

- creates a working branch like `work/20260516-1600-hero-fix`;
- creates a local backup tag like `snapshot/20260516-1600-hero-fix`;
- attempts to publish the branch to `origin`.
