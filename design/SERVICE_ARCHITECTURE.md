# Service architecture: privacy-first non-root evidence collection & IPFS pinning

Goal: provide a fast, easy, no-login way for someone in distress to collect non-root Android artifacts, redact identifying data client-side, and publish a pinned CID to IPFS for safe sharing with law enforcement or trusted parties.

High-level constraints and ethics:
- No central server should receive raw evidence by default; client-side collection and upload reduces privacy risk and legal liability.
- Explicit consent and clear warnings are mandatory.
- Abuse prevention: rate limits and anti-abuse policies are required if any server components are used.
- Forensic integrity: generate SHA-256 hashes and manifest files. Record timestamps and minimal metadata.

Components:

1) Client CLI / Desktop app (local)
 - Runs on the user's Linux (or Windows/macOS with equivalent tooling) machine.
 - Uses `adb` to collect only non-root artifacts (bugreport, logcat, /sdcard, package lists).
 - Performs best-effort automatic redaction (regex-based) of plaintext artifacts.
 - Produces a tar.gz archive, an evidence manifest, and SHA-256 hashes.
 - Optional: encrypt the archive locally via GPG symmetric encryption.
 - Uploads directly to a pinning service (web3.storage / Pinata) using the user's API key, so the server never sees raw data.

2) Optional Relay/Mirroring Service (opt-in)
 - Acts only as a metadata registrar: accepts only a CID and minimal metadata (consent timestamp, contact method) and returns a short URL.
 - The relay should never accept raw evidence or store decrypted content.
 - Use strict rate limiting, abuse reporting, and require a trusted contact or backup email.

3) Pinning & Mirroring
 - Encourage users to pin to multiple services for redundancy (web3.storage + Pinata + institutional mirror).
 - Provide instructions for trusted organizations (advocacy groups) to pin CIDs or mirror them.

4) Governance, Legal & Safety
 - Clear terms of service and privacy policy explaining permanence and risks.
 - Hotline and guidance for emergency cases.
 - Mechanisms for removal requests by consent (difficult on IPFS — rely on pinning services dropping pins and legal takedown avenues).

Threat model and mitigations:
- Risk: malicious actor uses the tool to exfiltrate data. Mitigate by making explicit consent required, local-only default, and logging/notice on the local machine.
- Risk: tool leaks API keys. Mitigate by never storing API keys in server-side logs; prefer environment variables or ephemeral prompts.
- Risk: incomplete redaction. Mitigate by labeling redaction as best-effort and advising manual review and optional encryption.

Next steps to implement MVP:
 - Build the cross-platform CLI wrapper (start with Bash + small Python utilities).
 - Harden redaction rules and add an interactive review step.
 - Add client-side encryption and clear UI prompts for consent.
 - Pilot with a trusted advocacy partner and legal counsel.
