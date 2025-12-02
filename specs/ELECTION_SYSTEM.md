# Election System & ZK Circuits Specification

**Feature Branch**: `002-election-system`
**Status**: In Progress
**Last Updated**: 2025-12-03

---

## 1. Overview

This specification covers the core election management logic and the Zero-Knowledge Proof (ZKP) circuit implementation. It defines how elections are created, how candidates are managed, and how votes are submitted and verified anonymously.

## 2. User Stories

### US4: Candidate Management (P1)
**As an** admin,
**I want to** manage candidates for an election,
**So that** voters can see who they are voting for.

**Acceptance Criteria**:
1.  CRUD operations for Candidates.
2.  Support for candidate metadata (Name, Bio, Photo).

### US5: ZK Circuit Implementation (P1)
**As a** developer,
**I want to** implement a Groth16 circuit,
**So that** votes can be proven valid without revealing the voter's identity.

**Acceptance Criteria**:
1.  Circuit verifies Merkle Proof (Eligibility).
2.  Circuit generates Nullifier (Uniqueness).
3.  Circuit outputs Vote Hash (Integrity).

### US6: Vote Submission (P1)
**As a** voter,
**I want to** submit my vote using a ZK proof,
**So that** my vote is counted but my identity remains secret.

**Acceptance Criteria**:
1.  Client generates proof in Web Worker.
2.  Backend verifies proof and nullifier uniqueness.
3.  Vote is recorded in database.

---

## 3. Implementation Tasks

### Phase 1: Database & Candidates
- [x] T101 Update Prisma Schema (`Candidate`, `Vote`).
- [x] T104 Implement Candidate CRUD Service.
- [x] T105 Implement Candidate Management API.

### Phase 2: ZK Circuits
- [x] T201 Initialize `packages/circuits`.
- [x] T202 Implement `vote.circom` (Merkle + Nullifier).
- [x] T203 Write Circuit Unit Tests.
- [x] T204 Perform Trusted Setup (Powers of Tau).
- [x] T205 Implement `crypto-lib` (Proof Generation).

### Phase 3: Voting Flow
- [x] T301 Implement `/votes/submit` API.
    -   Double Voting Check.
    -   Proof Verification.
    -   Merkle Root Check.
- [x] T302 Implement Voting Booth UI.
- [x] T303 Integrate Web Worker for Proof Generation.

### Phase 4: Tally & Audit
- [x] T401 Implement Tally API.
- [x] T402 Implement Audit Logs API.
- [x] T403 Implement Verification Center UI.

---

## 4. Circuit Design

### Inputs
-   **Public**: `root` (Merkle Root), `electionId`, `vote` (Candidate ID).
-   **Private**: `secret` (Nullifier Secret), `pathIndices`, `siblings` (Merkle Path).

### Outputs
-   **Nullifier Hash**: `Poseidon(secret, electionId)` - Prevents double voting.
-   **Vote Hash**: `Poseidon(vote, secret)` - Binds vote to proof.

---

## 5. API Contract

### Key Endpoints
-   `POST /elections`: Create election.
-   `POST /elections/:id/candidates`: Add candidate.
-   `POST /votes/submit`: Submit ZK vote.
-   `GET /verify/:id/logs`: Get audit logs.
