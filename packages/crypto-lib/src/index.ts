import * as snarkjs from 'snarkjs';
// @ts-ignore
import { buildPoseidon } from 'circomlibjs';
import * as fs from 'fs';
import * as path from 'path';

// Load verification key from build artifacts or expected location
// In production, this file should be placed in the same directory or a known location
let verificationKey: any;
try {
    // Try to load from local file (if copied during build)
    const localPath = path.join(__dirname, 'verification_key.json');
    if (fs.existsSync(localPath)) {
        verificationKey = JSON.parse(fs.readFileSync(localPath, 'utf-8'));
    } else {
        // Try to load from circuits build directory (monorepo dev mode)
        const buildPath = path.resolve(__dirname, '../../../circuits/build/verification_key.json');
        if (fs.existsSync(buildPath)) {
            verificationKey = JSON.parse(fs.readFileSync(buildPath, 'utf-8'));
        } else {
            console.warn('Verification key not found. Verification will fail.');
        }
    }
} catch (e) {
    console.warn('Error loading verification key:', e);
}

export interface ProofInput {
    root: string;
    electionId: string;
    vote: string;
    secret: string;
    pathIndices: number[];
    siblings: string[];
}

export interface FullProof {
    proof: any;
    publicSignals: string[];
}

export async function verifyVoteProof(proof: any, publicSignals: string[]): Promise<boolean> {
    try {
        const res = await snarkjs.groth16.verify(verificationKey, publicSignals, proof);
        return res;
    } catch (error) {
        console.error('Proof verification failed:', error);
        return false;
    }
}

export async function generateNullifier(secret: bigint, electionId: bigint): Promise<string> {
    const poseidon = await buildPoseidon();
    const hash = poseidon([secret, electionId]);
    return poseidon.F.toString(hash);
}

export async function generateVoteProof(
    input: ProofInput, 
    wasmPath: string, 
    zkeyPath: string
): Promise<FullProof> {
    const { proof, publicSignals } = await snarkjs.groth16.fullProve(input, wasmPath, zkeyPath);
    return { proof, publicSignals };
}
