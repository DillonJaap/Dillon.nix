---
name: comby-refactor
description: Perform structural code refactoring using the Comby tool. Use when user wants to refactor, rename, rewrite, or search-and-replace code structurally (not regex), mentions "comby", or needs language-aware find-and-replace across files.
---

# Comby Refactor

## Quick start

```bash
# Basic rewrite (preview diff)
comby 'old_fn(:[args])' 'new_fn(:[args])' .ext -diff

# Apply in-place
comby 'old_fn(:[args])' 'new_fn(:[args])' .ext -i

# With rule constraint
comby 'log(:[x])' 'logger.info(:[x])' .js -i -rule 'where :[x] != "\"debug\"'
```

## Workflows

### Single-file refactor
1. Build the match template using `:[hole]` syntax
2. Build the rewrite template referencing the same holes
3. Preview with `-diff` or `-review`
4. Apply with `-i`

### Multi-file refactor
```bash
comby 'MATCH' 'REWRITE' .ext -d path/to/dir -i -exclude-dir vendor,node_modules
```

### Batch rewrites with template directories
```bash
comby -templates path/to/templates/ -f .ext -d .
```

Template directory structure:
```
templates/
├── rename-foo/
│   ├── match
│   ├── rewrite
│   └── rule        # optional
└── wrap-bar/
    ├── match
    └── rewrite
```

## Key flags

| Flag | Purpose |
|------|---------|
| `-i` | Rewrite files in-place |
| `-d dir` | Target directory |
| `-diff` | Output unified diff |
| `-review` | Interactive accept/reject per change |
| `-matcher .ext` | Force language parser (`.go`, `.js`, `.py`, `.c`, etc.) |
| `-rule 'where ...'` | Add constraints |
| `-exclude-dir x,y` | Skip directories |
| `-exclude prefix` | Skip files by name/path prefix |
| `-match-only` | Find without rewriting |
| `-json-lines` | Machine-readable output |
| `-stdin` / `-stdout` | Pipe mode |

## Rules

See [REFERENCE.md](REFERENCE.md) for full hole syntax, rewrite properties, and rule language.
