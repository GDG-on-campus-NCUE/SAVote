# SAVote (Secure Anonymous Voting)

**Decentralized, Privacy-Preserving Voting System for NCUESA**

SAVote is a next-generation electronic voting platform built with **Zero-Knowledge Proofs (Groth16)**. It guarantees that votes are:
1.  **Anonymous**: No one (including admins) can link a vote to a specific user.
2.  **Verifiable**: Any user can cryptographically verify their vote was counted.
3.  **Unique**: Each eligible voter can only vote once per election.

---

## 📚 Documentation

We have organized our documentation to help you find what you need quickly:

### 🚀 [Deployment Guide](./docs/DEPLOYMENT.md)
**For DevOps & SysAdmins.**
The single source of truth for deploying SAVote to production. Includes Docker, Nginx, and SSL setup.

### 🏗️ [System Architecture](./docs/ARCHITECTURE.md)
**For Architects & Leads.**
Deep dive into the technical stack, ZK circuit design, SAML authentication flow, database schema, and UI design system.

### 💻 [Development Guide](./docs/DEVELOPMENT.md)
**For Developers.**
How to set up your local environment, project structure, coding standards, and testing strategies.

### 📅 [Project Plan](./docs/PROJECT_PLAN.md)
**For Project Managers.**
Roadmap, sprint breakdown, risk management, and future feature planning.

---

## ⚡ Quick Start (Production)

To deploy the full stack immediately:

```bash
# 1. Clone the repo
git clone https://github.com/GDG-on-campus-NCUE/SAVote.git
cd SAVote

# 2. Run the deployment script
bash scripts/deploy.sh
```

*See [Deployment Guide](./docs/DEPLOYMENT.md) for prerequisites and configuration.*

---

## 🛠️ Tech Stack

-   **Frontend**: React, Vite, TailwindCSS
-   **Backend**: NestJS, Prisma, PostgreSQL
-   **Zero-Knowledge**: Circom, SnarkJS
-   **Auth**: SAML 2.0 (Synology C2 Identity)
-   **Infra**: Docker Compose, Nginx

---

## 📂 Repository Structure

```text
/
├── apps/            # Web & API Applications
├── packages/        # Shared Libraries & ZK Circuits
├── docs/            # Documentation Center
├── scripts/         # Deployment Scripts
├── specs/           # Detailed Feature Specifications
└── nginx/           # Server Configuration
```

---

**License**: MIT  
**Maintainer**: NCUESA Development Team
