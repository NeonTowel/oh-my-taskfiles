# Code Style Guide

## File Organization Principles

### File Size Limits

- **Maximum 250 lines per file** (excluding tests) [web:21][web:25]
- **Maximum 150 lines preferred** for optimal maintainability
- Files exceeding limits indicate insufficient decomposition
- Extract to new modules rather than growing existing files [web:25]

### One Responsibility Per File

- Single top-level class/interface/module per file [web:25]
- File name must match primary export exactly
- Related types (delegates, enums) can share a file only if < 50 lines total
- Test files are exception: one test file per implementation file

### Module Structure

```shell
module/
├── domain/ # Core business logic (no external deps)
├── application/ # Use cases and workflows
├── infrastructure/ # External integrations (DB, API, filesystem)
└── interfaces/ # Public contracts and adapters
```

## Clean Code Principles

### Function Guidelines

- **Maximum 20 lines per function** [web:23][web:28]
- **Maximum 3 parameters** [web:28]
- Use parameter objects for > 3 related values
- Single responsibility: function does ONE thing well
- No side effects beyond function name's promise

### Naming Conventions

- **Functions**: Verbs describing action (`calculateTotal`, `fetchUser`, `validateInput`)
- **Variables**: Nouns describing content (`userProfile`, `totalAmount`, `isValid`)
- **Boolean**: Predicate form (`isActive`, `hasPermission`, `canExecute`)
- **No abbreviations** except universally known (HTTP, API, ID)
- Reveal intent: `elapsedTimeInDays` not `daysSinceModification` not `d`

### Complexity Limits

- **Cyclomatic complexity ≤ 10** per function
- **Nesting depth ≤ 3 levels**
- Use early returns to flatten conditionals
- Extract complex conditions to named boolean functions

### Line Length

- **Maximum 100 characters** per line [web:28]
- Break at logical boundaries (after operators, before parameters)
- Indent continuation lines by 4 spaces

## Modular Architecture

### Domain-Driven Design [web:27][web:30]

- **Bounded Contexts**: Clear module boundaries with explicit interfaces
- **Domain Models**: Business logic isolated from infrastructure
- **Value Objects**: Immutable types for domain concepts
- **Aggregates**: Single entry point for related entities

### Dependency Rules

- **Domain layer**: Zero external dependencies
- **Application layer**: Depends only on domain
- **Infrastructure**: Implements domain interfaces
- Dependencies flow inward only (ports & adapters pattern)

### Self-Contained Modules [web:27][web:29]

- Each module can be understood independently
- Public API defined in single `index` file
- Internal implementation hidden from consumers
- No circular dependencies between modules
- Document module boundaries in README

## Idiomatic Code Patterns [web:26][web:29]

### Error Handling

```go
// Good: Explicit error handling
result, err := doOperation()
if err != nil {
return fmt.Errorf("operation failed: %w", err)
}

// Bad: Silent failures
result, _ := doOperation()
```

### Guard Clauses

```go
// Good: Early returns reduce nesting
func processUser(user *User) error {
  if user == nil {
    return ErrInvalidUser
  }
  if !user.IsActive {
    return ErrInactiveUser
  }
  // main logic here
}

// Bad: Nested conditions
func processUser(user *User) error {
  if user != nil {
    if user.IsActive {
      // main logic buried deep
    }
  }
}
```

### Composition Over Inheritance

- Prefer small interfaces with single methods
- Compose behavior through struct embedding
- Avoid deep inheritance hierarchies (max 2 levels)

### Immutability

- Default to immutable data structures
- Pure functions without side effects preferred
- Mutate only when performance-critical and documented

## Code Organization

### Import Grouping

1. Standard library
2. Third-party packages
3. Internal packages
   (blank line between groups)

### Comment Standards

- **Public APIs**: Godoc/JSDoc format, examples for non-obvious usage
- **Complex logic**: Explain WHY not WHAT
- **TODOs**: Include ticket reference and date
- **No commented-out code** (use version control)

### Magic Values

- No magic numbers: use named constants
- Configuration in dedicated config files
- Feature flags instead of conditionals

## Testing Standards

### Test File Structure

- `_test` suffix matching implementation file [web:25]
- Test functions named `TestFunctionName_Scenario`
- Table-driven tests for multiple inputs
- Arrange-Act-Assert structure

### Test Coverage

- **Minimum 80% line coverage**
- 100% coverage for critical paths
- Test edge cases explicitly
- Mock external dependencies

### Test Size

- Unit tests complete in < 100ms
- Integration tests isolated and repeatable
- No shared state between tests

## Documentation Requirements

### README per Module

- Purpose and responsibilities
- Public API overview with examples
- Dependencies and constraints
- Architecture decisions

### Code Comments

- Complex algorithms: Explain approach with examples
- Workarounds: Reference issue/ticket
- Performance optimizations: Document assumptions

### API Documentation

- All public functions/methods documented
- Parameter descriptions with types
- Return value explanation
- Error conditions listed
- Usage examples for non-trivial APIs

## Language-Specific Idioms

### Go

- Errors as values, not exceptions
- Interfaces discovered not declared
- Accept interfaces, return structs
- Use `context.Context` for cancellation

### Rust

- Leverage type system for correctness
- `Result<T, E>` for recoverable errors
- `Option<T>` instead of null
- Ownership for resource management

### Python

- PEP 8 compliance
- Type hints for all public APIs
- Context managers for resources
- List comprehensions for simple transformations

### TypeScript

- Strict mode enabled
- Prefer `const` over `let`
- Discriminated unions over enums
- Type inference over explicit annotations
