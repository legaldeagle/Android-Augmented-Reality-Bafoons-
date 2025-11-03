# Non-root Android collector (starter)

This folder contains a starter, non-root Android evidence collector that:

- Uses ADB to collect non-root artifacts: `adb bugreport`, `adb logcat`, `/sdcard` contents, package lists, and device properties.
- Performs best-effort redaction of obvious PII from plaintext artifacts (emails, phone numbers) using regex-based filters. This is not perfect—manual review is required.
- Packages artifacts into a timestamped archive and creates SHA-256 hashes for integrity.
- Provides an optional publish script template (upload to web3.storage/pinata) — you must supply your own API key.

Security & legal notes:
- Do not run this collector on devices you do not own or have explicit consent to analyze.
- Avoid uploading raw personal data to public IPFS unless the user explicitly consents and understands the permanence.
- If a full forensic image is needed, stop and contact a professional.

How to use (basic):

1. Ensure `adb` is installed and the device allows USB debugging.
2. Plug the device into a Linux host and accept the RSA key prompt on the phone.
3. Run `./collect_nonroot.sh` from this directory. The script will create a `output/` folder with artifacts.
4. Review and, if appropriate, encrypt the archive before uploading to IPFS via the provided template.
