# SAML Authentication Specification

**Feature Branch**: `001-saml-sso-auth`
**Status**: Draft
**Last Updated**: 2025-11-30

---

## 1. Overview

This specification defines the implementation of SAML 2.0 Single Sign-On (SSO) for the SAVote system. It covers the integration with the university's Identity Provider (IdP), user session management via JWT, and the generation of the client-side Nullifier Secret for anonymous voting.

## 2. User Stories

### US1: First-time Login & Nullifier Setup (P1)
**As a** student,
**I want to** log in using my school account and generate a secure voting secret,
**So that** I can vote anonymously in future elections.

**Acceptance Criteria**:
1.  User is redirected to School IdP for authentication.
2.  Upon return, if no Nullifier Secret exists in LocalStorage, generate a new one.
3.  Display the secret to the user with a warning to save it.
4.  Store the secret in LocalStorage (never send to backend).

### US2: Returning User Login (P1)
**As a** returning student,
**I want to** log in and have my voting secret automatically recognized,
**So that** I can access the dashboard immediately.

**Acceptance Criteria**:
1.  If Nullifier Secret exists in LocalStorage, redirect to Dashboard after SAML auth.
2.  If missing, prompt user to manually enter their backup secret.

### US3: Admin Voter Import (P2)
**As an** admin,
**I want to** import a list of eligible voters (Student IDs),
**So that** the system can verify eligibility using Zero-Knowledge Proofs.

**Acceptance Criteria**:
1.  Admin uploads CSV (Student ID, Class).
2.  Backend generates a Merkle Tree from the list.
3.  Root hash is stored for the election.

---

## 3. Functional Requirements

-   **FR-001**: Integrate with SAML 2.0 IdP.
-   **FR-002**: Extract only minimal attributes (Student ID Hash, Class).
-   **FR-003**: Generate 256-bit Nullifier Secret on client-side.
-   **FR-004**: Store Nullifier Secret ONLY in LocalStorage.
-   **FR-005**: Issue JWT (Access + Refresh) upon successful SAML auth.
-   **FR-006**: Support Merkle Tree generation from voter lists.

---

## 4. Implementation Tasks

### Phase 1: Setup
- [x] T001 Define Prisma schema (`User`, `Session`).
- [x] T002 Generate RSA keys for JWT.
- [x] T003 Configure `.env` for SAML settings.

### Phase 2: Backend Core
- [x] T010 Configure Passport SAML strategy.
- [x] T014 Implement AuthService (JWT issuance).
- [x] T027 Implement `/auth/saml/login` endpoint.
- [x] T028 Implement `/auth/saml/callback` endpoint.

### Phase 3: Frontend Core
- [x] T015 Implement `crypto.service.ts` (Nullifier generation).
- [x] T037 Create Login Page with SAML redirect.
- [x] T038 Create Callback Page for token handling.
- [x] T039 Create Setup Page for Nullifier generation.

### Phase 4: Voter Management
- [x] T059 Implement `/voters/import` endpoint.
- [x] T058 Implement Merkle Tree generation logic.

---

## 5. API Contract

See `specs/api/openapi.yaml` for full definition.

### Key Endpoints
-   `GET /auth/saml/login`: Initiate SSO.
-   `POST /auth/saml/callback`: Handle IdP response.
-   `POST /auth/refresh`: Refresh access token.
-   `POST /voters/import`: Import eligible voters (Admin).
