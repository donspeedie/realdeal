# CloudCalcs Functions - TypeScript

RealDeal.ai cloud functions for real estate investment calculations, now with TypeScript and domain-driven design.

## Project Structure

```
src/
├── domain/                 # Business logic layer
│   ├── entities/          # Domain entities
│   ├── value-objects/     # Domain value objects
│   └── services/          # Domain services
├── infrastructure/        # External dependencies layer
│   ├── apis/             # External API integrations
│   └── cache/            # Caching implementations
├── application/          # Application logic layer
│   └── use-cases/        # Application use cases
├── presentation/         # Presentation layer
│   └── functions/        # Firebase Cloud Functions
└── shared/               # Shared utilities
    ├── types/            # TypeScript type definitions
    ├── utils/            # Utility functions
    └── constants/        # Application constants

tests/                    # Test files
├── unit/                 # Unit tests
├── integration/          # Integration tests
└── setup.ts             # Test setup

prompts/                  # AI agent prompts
├── PLANNER_AGENT.md
├── IMPLEMENTER_MINIMAL_DIFF.md
└── REVIEWER_STRICT.md

demo/                     # Demo scripts
test/                     # Legacy test scripts
explain/                  # Analysis scripts
```

## Scripts

- `npm run build` - Compile TypeScript to JavaScript
- `npm run dev` - Watch mode compilation
- `npm run test` - Run tests with Vitest
- `npm run test:watch` - Run tests in watch mode
- `npm run test:coverage` - Run tests with coverage
- `npm run lint` - Lint TypeScript files
- `npm run format` - Format code with Prettier
- `npm run deploy` - Build and deploy to Firebase

## Development

1. Install dependencies:
   ```bash
   npm install
   ```

2. Set up environment variables:
   ```bash
   cp .env.example .env
   # Edit .env with your API keys
   ```

3. Start development:
   ```bash
   npm run dev
   ```

4. Run tests:
   ```bash
   npm run test
   ```

## Architecture

This codebase follows Domain-Driven Design (DDD) principles:

- **Domain Layer**: Contains the core business logic for real estate investment calculations
- **Infrastructure Layer**: Handles external dependencies like APIs and caching
- **Application Layer**: Orchestrates domain services for specific use cases
- **Presentation Layer**: Exposes functionality via Firebase Cloud Functions

## Investment Strategies

The system calculates multiple investment strategies:

1. **Fix & Flip**: Property renovation and resale
2. **Add-On**: Adding bedrooms/bathrooms for value increase
3. **ADU (Accessory Dwelling Unit)**: Building additional units
4. **New Build**: Demolition and new construction
5. **Rental**: Long-term rental income strategy

## Testing

Tests are organized by type:

- **Unit Tests**: Test individual components in isolation
- **Integration Tests**: Test component interactions
- **Setup**: Mock external dependencies (Firebase, APIs)

Coverage reports are generated in the `coverage/` directory.

## Deployment

The project deploys to Firebase Cloud Functions:

```bash
npm run deploy
```

This will:
1. Compile TypeScript to JavaScript
2. Deploy compiled functions to Firebase
3. Update function configurations

### Post-Deployment Workflow

After deploying to Firebase, **always push changes to GitHub**:

```bash
git push origin master
```

Or use the combined workflow:
```bash
firebase deploy --only functions && git push origin master
```

This ensures:
- GitHub repository stays in sync with deployed code
- Changes are backed up remotely
- Team members have access to latest code
- Deployment history is tracked

## Legacy Structure

The original JavaScript files are being gradually migrated to TypeScript. Old files are organized in:

- `demo/` - Demo and analysis scripts
- `test/` - Legacy test files
- `explain/` - Calculation explanation scripts

## AI Development Workflow

This project includes structured AI agent prompts for development:

- **Planner**: Analyzes requirements and creates implementation plans
- **Implementer**: Applies minimal changes while preserving behavior
- **Reviewer**: Validates changes against system invariants

### Claude Development Logs

**Log Location**: `C:\Users\donsp\.claude\file-history`

These logs track all Claude iterations, changes, and progress. Use them to:
- Review previous implementation decisions
- Access iteration history and context
- Track changes across development sessions
- Maintain continuity until git process is established

**Temporary workaround until git workflow is implemented.**