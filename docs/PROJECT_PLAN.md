# SAVote Project Plan

## 1. Roadmap & Sprints

**Cycle**: 8 Weeks (4 Sprints)

### Phase 0: Foundation (Week 1)
- [x] Monorepo Setup.
- [x] Docker Infrastructure.
- [x] CI/CD Pipelines.
- [x] Shared Types Definition.

### Phase 1: ZK Core (Week 2-3)
- [x] `vote.circom` Implementation.
- [x] Circuit Unit Tests.
- [x] Trusted Setup (Powers of Tau).
- [x] `crypto-lib` Wrapper Implementation.

### Phase 2: Backend & Auth (Week 4-5)
- [x] SAML SSO Integration.
- [x] Election CRUD.
- [x] **Core**: Vote Submission Endpoint (`/votes/submit`).
- [x] Double Voting Prevention (Nullifiers).

### Phase 3: Frontend & UI (Week 6-7)
- [x] Login & Dashboard UI.
- [x] Voting Booth UI.
- [x] **Core**: Client-side Proof Generation (Web Worker).
- [x] Verification Center.

### Phase 4: Audit & Deploy (Week 8)
- [ ] E2E System Testing.
- [ ] Load Testing (k6).
- [ ] Security Audit (SQLi, XSS, Circuit Logic).
- [ ] Production Deployment.

---

## 2. Risk Management

| Risk | Probability | Impact | Mitigation |
| :--- | :--- | :--- | :--- |
| **Private Key Loss** | Medium | High | User cannot vote. Implement "Reset Nullifier Secret" flow (requires strict re-auth). |
| **Double Voting** | Low | Critical | ZK Nullifier mechanism + DB Unique Index. |
| **Frontend Tampering** | Low | High | SRI (Subresource Integrity) + CSP. |
| **Traffic Spikes** | Medium | Medium | Queue-based processing (BullMQ) for vote submission. |

---

## 3. Future Features

-   **Multi-Candidate Selection**: Support "Select K of N" voting logic in circuits.
-   **Weighted Voting**: Support different vote weights based on user attributes.
-   **On-Chain Settlement**: Publish root hashes to a public blockchain (Ethereum/Polygon) for immutable audit trails.
