# SAVote Development Guide

## 1. Getting Started

### Prerequisites
-   **Node.js**: v20+ (LTS)
-   **pnpm**: v9+
-   **Docker**: For local database and services.
-   **OS**: Linux/macOS recommended (Windows via WSL2).

### Quick Start

1.  **Install Dependencies**:
    ```bash
    pnpm install
    ```

2.  **Environment Setup**:
    -   Copy `.env.example` to `.env` in `apps/api` and `apps/web`.
    -   Ensure `DATABASE_URL` is set correctly.

3.  **Start Infrastructure**:
    ```bash
    docker compose up -d postgres
    ```

4.  **Initialize Database**:
    ```bash
    pnpm db:migrate
    pnpm db:seed
    ```

5.  **Start Development Server**:
    ```bash
    pnpm dev
    ```
    -   Web: `http://localhost:5173`
    -   API: `http://localhost:3000`

---

## 2. Project Structure (Monorepo)

We use **Turborepo** and **pnpm workspaces**.

```text
/
├── apps/
│   ├── web/                 # React Frontend (Vite)
│   ├── api/                 # NestJS Backend
│   └── admin/               # (Future) Admin Panel
├── packages/
│   ├── circuits/            # Circom ZK Circuits
│   ├── shared-types/        # Shared TypeScript Interfaces
│   └── crypto-lib/          # ZK Proof Generation/Verification Lib
├── docs/                    # Documentation
├── scripts/                 # Deployment & Utility Scripts
└── specs/                   # Detailed Specifications
```

---

## 3. Development Standards

### Git Workflow
-   **Main Branch**: `main` (Production Ready).
-   **Feature Branches**: `feature/description`.
-   **Fix Branches**: `fix/issue-description`.

### Commit Convention
Follow **Conventional Commits**:
-   `feat: add zk proof generation`
-   `fix: resolve nullifier collision`
-   `docs: update api schema`
-   `chore: upgrade dependencies`

### Code Quality
-   **Linter**: ESLint.
-   **Formatter**: Prettier.
-   **Pre-commit**: Husky + lint-staged runs automatically on commit.

---

## 4. Testing Strategy

### ZK Circuits
-   **Critical**: Faulty circuits allow fake votes.
-   **Tools**: `circom_tester`, `mocha`.
-   **Tests**:
    -   Constraint checks.
    -   Negative testing (invalid inputs must fail).
    -   Witness generation verification.

### Backend
-   **Unit Tests**: Jest (Service logic).
-   **E2E Tests**: Supertest (API endpoints).

### Frontend
-   **Unit Tests**: Vitest / React Testing Library.
-   **E2E**: Playwright (Critical user flows).

---

## 5. Common Commands

-   **Build All**: `pnpm build`
-   **Build Circuits**: `pnpm --filter circuits build`
-   **Run Tests**: `pnpm test`
-   **Database Studio**: `pnpm --filter api prisma studio`
