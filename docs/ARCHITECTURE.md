# SAVote System Architecture

## 1. System Overview

SAVote is a decentralized voting system designed for NCUESA, leveraging **Groth16 Zero-Knowledge Proofs (ZKP)** to ensure voting privacy and verifiability. Unlike traditional centralized systems, SAVote mathematically guarantees that votes are anonymous while remaining verifiable.

### Core Technologies

- **Frontend**: React 18, Vite, TailwindCSS
- **Backend**: NestJS (Node.js), Prisma ORM
- **Database**: PostgreSQL 16, Redis (Session/Caching)
- **Auth**: SAML 2.0 (Passport.js), JWT
- **ZKP**: Circom 2.1, SnarkJS, Groth16 (BN128 curve)
- **Infrastructure**: Docker, Nginx

---

## 2. High-Level Architecture

```text
[Client Browser]
      |
    (HTTPS)
      |
[Load Balancer / Nginx Reverse Proxy]
      |
      +-----> [Frontend Container] (Static Assets / React App)
      |
      +-----> [Backend Container Cluster] (NestJS API)
                     |
        +------------+------------+
        |            |            |
   [PostgreSQL]   [Redis]    [Log Service]
```

### Key Components

1.  **Frontend (Web Client)**:
    -   Hosted via Nginx.
    -   Generates ZK Proofs client-side using Web Workers (WASM).
    -   Manages authentication state via SAML/JWT.

2.  **Backend (API)**:
    -   Handles business logic, election management, and vote submission.
    -   Verifies ZK Proofs before recording votes.
    -   Manages user sessions and eligibility.

3.  **Database (PostgreSQL)**:
    -   Stores election data, candidate info, and anonymized vote records.
    -   **Crucial**: Does NOT store links between users and their votes.

---

## 3. Authentication Architecture (SAML SSO)

The system integrates with the university's Identity Provider (IdP) via SAML 2.0.

### Flow
1.  User clicks "Login" -> Redirects to IdP (Synology C2 Identity).
2.  User authenticates at IdP.
3.  IdP posts SAML Response to `SAVote API`.
4.  API verifies signature, extracts attributes (Student ID Hash), and issues a JWT.

### Configuration Details

-   **IdP**: Synology C2 Identity
-   **Protocol**: SAML 2.0
-   **NameID Format**: `urn:oasis:names:tc:SAML:2.0:nameid-format:persistent`
-   **Signature Algorithm**: RSA-SHA256

**Environment Variables (`apps/api/.env`):**
```env
SAML_ENTRY_POINT="https://..."
SAML_ISSUER="https://api.voting.ncuesa.edu.tw/saml/metadata"
SAML_CALLBACK_URL="https://api.voting.ncuesa.edu.tw/auth/saml/callback"
SAML_IDP_CERT="-----BEGIN CERTIFICATE-----..."
```

*For detailed SAML troubleshooting and setup, refer to the internal `specs/001-saml-sso-auth/` documentation.*

---

## 4. Database Design

### Schema Overview

-   **User**: Stores user eligibility info (hashed student ID, class). *No vote history linked here.*
-   **Election**: Stores election metadata (title, dates, config).
-   **Candidate**: Candidates linked to an election.
-   **Vote**: Stores the anonymous vote.
    -   `nullifier`: Unique hash derived from user secret + election ID. Prevents double voting.
    -   `proof`: The ZK proof string.
    -   `publicSignals`: Public inputs for verification.

### Infrastructure Setup

-   **Production**: Managed PostgreSQL (e.g., AWS RDS, Azure DB).
-   **Development**: Docker container (`postgres:16`).

**Default Dev Config:**
-   Host: `localhost`
-   Port: `5432`
-   Database: `savote_dev`
-   User/Pass: `postgres` / `password`

---

## 5. Frontend Architecture & UI Design

### Design System
-   **Framework**: TailwindCSS
-   **Theme**: Google Material-inspired (Blue/White/Gray).
-   **Glassmorphism**: Extensive use of blur and translucency for modern aesthetics.

### Key Pages
1.  **Login**: SAML SSO entry point.
2.  **Dashboard**: Election list and user status.
3.  **Voting Booth**:
    -   Step 1: Select Candidate.
    -   Step 2: Generate ZK Proof (Client-side).
    -   Step 3: Submit & Verify.
4.  **Verification Center**: Check vote inclusion via Nullifier Hash.

### ZK Integration
-   **Circuits**: Compiled `.wasm` and `.zkey` files are served as static assets in `public/zk/`.
-   **Web Workers**: Proof generation happens in a background thread to prevent UI freezing.

---

## 6. API Design

### Core Endpoints

-   **Auth**:
    -   `POST /auth/saml/login`: Initiate SSO.
    -   `POST /auth/saml/callback`: Handle IdP response.
    -   `GET /auth/me`: Get current user context.

-   **Elections**:
    -   `GET /elections`: List active elections.
    -   `GET /elections/:id`: Get election details.

-   **Votes**:
    -   `POST /votes/submit`: Submit a ZK vote.
        -   Payload: `{ proof, publicSignals, electionId }`
    -   `GET /votes/:id/result`: Get tally (if public).

-   **Verification**:
    -   `GET /verify/:electionId/logs`: Get all public proofs for independent audit.

---

## 7. Security Considerations

1.  **Double Voting**: Prevented via `Nullifier` mechanism in ZK circuit.
2.  **Vote Privacy**: Backend only sees the proof and nullifier, never the user's choice linked to their identity.
3.  **Frontend Integrity**: Use SRI (Subresource Integrity) and CSP.
4.  **Rate Limiting**: Applied to API endpoints to prevent DDoS.
