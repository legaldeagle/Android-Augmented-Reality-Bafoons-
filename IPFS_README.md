# Publishing to IPFS and pinning (overview)

This document explains safe options for publishing the repository README or user-submitted evidence archives to IPFS and pinning them with a pinning service. Use these steps only after you have explicit consent and after you have preserved evidence and redacted personal data as required by local law.

Important safety notes:
- Do NOT upload raw personal data to public IPFS unless the user explicitly consents and knows the data will be public.
- Prefer client-side encryption before uploading sensitive archives and only share keys with law enforcement or trusted parties.

Options:

1) web3.storage (easy, free tier)
 - Create an account at https://web3.storage
 - Generate an API token
 - Install `web3` CLI (or use curl):

    npm install -g web3.storage

 - Upload a file:

    web3.storage put path/to/file

 - The command returns a CID (content identifier). Save the CID and optionally pin it with another service for redundancy.

2) Pinata (paid / free tiers)
 - Create an account at https://pinata.cloud
 - Use their web UI or API to pin files (you'll need an API key/secret). See Pinata docs for details.

3) IPFS node + public gateways
 - Run a local IPFS node (go-ipfs or js-ipfs), add the file with `ipfs add`, then pin with a third-party pinning service.

Client-side encryption before upload (recommended for sensitive evidence):

```bash
# create a password-protected zip
zip -e evidence.zip files_to_upload/
# or use gpg symmetric encryption
gpg --symmetric --cipher-algo AES256 --output evidence.zip.gpg evidence.zip
```

Storing and sharing CIDs:
- Save CIDs and hashes in `evidence_manifest.txt` alongside the hashed artifacts.
- Consider pinning the CID to multiple services (web3.storage + Pinata) and adding the CIDs to the Internet Archive (optional).

Legal/ethical reminder:
- Publishing user data to a public, immutable network can have permanent privacy consequences. Only proceed with explicit informed consent or under instruction from law enforcement.
