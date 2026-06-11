# Comby Reference

## Hole syntax

| Syntax | Matches |
|--------|---------|
| `:[var]` | Zero or more chars (lazy, respects delimiters). Stops at newline outside delimiters. |
| `:[[var]]` | One or more alphanumeric + `_` (word) |
| `:[var:e]` | Expression — contiguous non-whitespace OR balanced blocks like `fn(a, b)` |
| `:[var.]` | Alphanumeric + punctuation (no delimiters) |
| `:[var\n]` | Up to and including newline |
| `:[ var]` | Whitespace only (no newlines) |
| `:[var~regex]` | PCRE regex (careful: greedy regex can swallow delimiters) |
| `...` / `:[_]` | Anonymous (unnamed) match-anything hole |

## Rewrite properties

Append to hole in rewrite template: `:[var].property`

### Case conversion
- `.lowercase` / `.UPPERCASE`
- `.Capitalize` / `.uncapitalize`
- `.UPPER_SNAKE_CASE` — camelCase → UPPER_SNAKE
- `.lower_snake_case` — camelCase → lower_snake
- `.UpperCamelCase` — snake_case → UpperCamel
- `.lowerCamelCase` — snake_case → lowerCamel

### Metadata
- `.length` — character count
- `.lines` — line count
- `.line` / `.line.start` / `.line.end` — line numbers
- `.column` / `.column.start` / `.column.end`
- `.offset` / `.offset.start` / `.offset.end`
- `.file` / `.file.path` / `.file.name` / `.file.directory`

### Identity (escape)
- `.value` — literal hole value (use to escape property names: `:[x].value.length` outputs text ".length")

## Rule language

Rules follow the rewrite template via `-rule` flag or `rule` file.

### Equality
```
where :[x] == :[y]
where :[x] != "some_literal"
```
Multiple conditions (AND): separate with commas.

### Rewrite expressions
Rewrite content inside a captured hole:
```
where rewrite :[args] { ":[[k]]=:[[v]]" -> "\":[k]\": :[v]" }
```

### Pattern match
```
where match :[x] {
| "pattern_a" -> true
| ":[_]" -> false
}
```

### Regex submatch in rules
```
where match :[hole] {
| ":[_~\\d+]" -> true
| ":[_]" -> false
}
```

## Fresh identifiers

Use `:[id()]` in rewrite template for random unique IDs. Label to reuse: `:[id(label)]`.

## Examples

### Rename function across a codebase
```bash
comby 'oldFunc(:[args])' 'newFunc(:[args])' .py -d . -i
```

### Swap arguments
```bash
echo 'foo(a, b)' | comby 'foo(:[x], :[y])' 'foo(:[y], :[x])' -stdin -stdout .js
```

### Convert snake_case names to camelCase
```bash
comby ':[[name]]_handler' ':[[name]].lowerCamelCase.value Handler' .rb -diff
```

### Constrained rewrite (skip specific values)
```bash
comby 'console.log(:[x])' 'logger.info(:[x])' .ts -i \
  -rule 'where :[x] != "\"error\"'
```

### Extract matches as JSON
```bash
comby 'TODO(:[user]): :[msg]' '' -match-only -json-lines .py
```

### Pipe mode (chain rewrites)
```bash
echo 'foo(a, b)' | \
  comby 'foo(:[x], :[y])' 'bar(:[y], :[x])' -stdin -stdout .c | \
  comby 'bar(:[a])' 'baz(:[a])' -stdin -stdout .c
```
