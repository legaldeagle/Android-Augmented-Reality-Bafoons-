# Android-Augmented-Reality-Bafoons-

Important: this repository contains user-facing guidance for people who believe their Android phone has been compromised by stalkers, spyware, malware, exploits etc. The instructions below are for preserving evidence, collecting non-destructive data using ADB (non-root), securing accounts, and next steps (law enforcement wont help many users with digital forensics, so we will do it ourselves). This is NOT a how-to for attackers and does not include instructions to bypass device security or perform rooting that may damage evidence.

## Quick safety checklist (read this first)

- If you are in immediate danger, call local emergency services, or get to a public area around more people and or cameras first.
- Check NICB by calling, put a freeze on your credit too. You could be targetted for various reasons but its very scary when its insurance fraud and hackers are paid overseas as a persistent service to try and isolate / monitor you. they are bullies and its best to get rid of any insurance policies, find the people that are beneficiaries and report this to every possible government agency.
- If safe to do so, put the phone in a proper metal housing - faraday cage made of stainless steel, copper, steel, or last resort is aluminum foil with 3-4 layers and the devices sitting inside must be insulated from the aluminum with tape or something. The faraday cage has to be without any gaps, cracks, and aluminum foil is only good as long as your not touching it to much, the foil wears out and gets tiny holes. The wear and pinholes will allow the signal to penetrate the enclosure. Its better to use a copper wire to ground the cage _ at a minimum keep some open metal / foil surface area for the connection to work and shift it away from the internal device(s). Airplane Mode, even powering off, is bypassed in sophisticated attacks. Pull the radio chip(s) out or cut the battery and CAUTION the capacitors can keep some charge so drain the residual power by holiding the power button- not guaranteed tho.. These hacker / criminal groups use a suit of scripts in python, perl, bash, etc etc and I prefer keep the device powered on in a faraday to preserve volatile logs, settings and keep the hackers from covering their tracks. Otherwise on some phones or tablets and laptops if you know exactly where and how to remove the bluetooth, wifi, NFC, and antennas you can secretly disconnect it while the attacker doesnt suspect it and once the device is truly offline you can perfectly preserve the evidence without risking the attacker removing or destroying the evidence. 
- Do NOT factory reset the phone if you want evidence for your own knowledge or the court - in my experience law enforcement is not helpful. Maybe the FBI and or other agencies will help if it end goal to commit fraud, or some other awful scam. 
- Photograph the device and suspicious screens, and write down timestamps, write down anything you can, or quickly go buy a cheap regular camera that doesnt connect to any wifi or bluetooth etc. 
- if you buy a new phone it may be compromised in minutes or days but actually you may be better off using flash drives and try to prep the important files you need, you can also sometimes just export all the bad files and ur imoortant files.. ill make a guide for this. 

## Who this guide is for

This README is for people who suspect a stalker installed spyware on their Android phone or used Google account data and/or AR devices to harass them. It focuses on non-root evidence collection (what you can collect without modifying the device), account containment, and safe next steps.

I have been harrased by people I know for over a year at one point. I knew the whole time, and was lucky because in my case they did try to hurt me and i was hit by a vehicle that ran a red light and slammed into the front passenger side of my vehicle. By that time it was very obviously a setup, and ill write more about this part later. Just remember to be vigilant, dont let them continue to get away with this disgusting and evil criminal behavior. Ill share some last resort tactics to expose the bad actors, very soon. This is day one, i want to do something to help combat this. When local criminals use paid stalking in an attempt to get away with high stakes and deadly fraud schemes, there are many other bad actors too. No one should have to deal with this kind of attack, its against human rights, its also a long term and permanent effect on victims. In my case ive become very paranoid, ptsd haunts me and it drove me crazy at times. I know how it feels to be targetted, and for anyone whos knowledgable in networking, programming, its almost worse because we know its happening and we get obsessed with revealing the people, mostly friends or exes, maybe jealous or evil neighbors.. It can be connected to you personally or people you know somehow. . . 

If you need an immediate, full forensic image or the device has been heavily tampered with, contact a certified digital forensics professional or law enforcement — do not attempt risky procedures that will alter or destroy evidence.

## Short plan (what we'll cover)

1. Immediate actions for safety
2. Preserve evidence and notes to collect
3. Preparing your Linux host for collection
4. Step-by-step ADB commands (non-root) to capture bugreports, logs, and user files
5. Limitations and when to stop and call a professional
6. Account cleanup and recovery actions
7. Reporting, legal help, and support resources

---

## 1) Immediate safety (do these now if you can)

- If you are in danger, call emergency services now.
- Get trusted family to help
- Buy bear spray or get a permit to carry and train yourself.
- Learn offensive hacking to counter and defend yourself if your in a situation like mine where its obviously a more elaborate coordinated scheme.
- If possible buy the VR tech for augmented reality and see through walls from the attackers device to monitor the stalker and plan a way to catch them. Get leo involved if your able to go this route. 
- If safe: enable Airplane Mode on the phone (manually is safest). Do not connect the device to unknown networks.
- Photograph any suspicious home screen, notifications, or prompt. Save timestamps (note date/time and timezone).
- Keep the phone powered on to preserve logs; powering off may lose volatile diagnostic data. If your priority is personal safety, powering off and seeking shelter is reasonable — weigh risks.

## 2) Preserve evidence (do not factory reset)

- Do not factory reset, reflash, or root the phone if you plan to involve law enforcement or a forensics lab.
- Collect screenshots and photos of suspicious apps, permissions, or UI elements. Save them with timestamps.
- Use the steps below to pull non-destructive evidence to a clean host.

## 3) Prepare your Linux host

Requirements:
- A Linux computer you control and trust (this repo assumes Ubuntu-like environment).
- A USB cable that connects the phone reliably.
- Basic terminal familiarity.

Create an isolated evidence folder:

```bash
mkdir -p ~/phone_evidence
cd ~/phone_evidence
```

Install Android platform tools (ADB):

```bash
sudo apt update
sudo apt install -y android-tools-adb android-tools-fastboot
```

Notes:
- Use an isolated or dedicated machine when possible. Do not upload collected evidence to public cloud accounts.

## 4) Step-by-step ADB evidence collection (non-root)

Prerequisite: USB debugging must be enabled on the phone (Settings → About phone → tap Build number 7 times → Developer options → USB debugging). If you cannot enable it, non-destructive collection is limited.

1) Connect the phone via USB and allow the host's RSA key when prompted on the device.

2) Verify ADB connection:

```bash
adb devices
```

Expect to see a device id and the word "device". If you see "unauthorized", accept the prompt on the phone.

3) Place device in Airplane Mode manually, or via ADB if necessary (vendor behavior varies):

```bash
adb shell settings put global airplane_mode_on 1
adb shell am broadcast -a android.intent.action.AIRPLANE_MODE --ez state true
```

4) Capture a bugreport (this collects system state and logs):

```bash
adb bugreport bugreport.zip
```

This will produce a zip containing logs and diagnostics. Keep it secure.

5) Capture logcat (runtime logs):

```bash
adb logcat -d > logcat.txt
```

6) Pull user-accessible storage (photos, downloads, some app caches):

```bash
adb pull /sdcard ./sdcard_backup
du -sh sdcard_backup
```

7) List installed packages and try to pull readable APKs:

```bash
adb shell pm list packages -f > packages.txt
mkdir -p apks
# Example: for each readable path in packages.txt, run:
# adb pull /data/app/com.example.app-1/base.apk ./apks/
```

Note: Many app APKs or app data live in protected locations and cannot be pulled without root.

8) Try an adb backup (often blocked on modern Android versions):

```bash
adb backup -all -f backup.ab
# If you need to extract backup.ab, use android-backup-extractor tools in a safe VM.
```

9) Gather additional device info and permissions:

```bash
adb shell pm list packages -3 > user_packages.txt
adb shell getprop > device_props.txt
adb shell dumpsys activity > dumpsys_activity.txt
```

10) Hash and secure collected files:

```bash
sha256sum bugreport.zip > bugreport.zip.sha256
sha256sum logcat.txt > logcat.txt.sha256
find sdcard_backup -type f -exec sha256sum {} \; > sdcard_hashes.txt
```

Store these files on a separate, clean machine or encrypted external drive and keep the hashes.

## 5) Limitations — when to stop and call a professional

- Some spyware hides in system partitions or requires root to remove. Rooting or tampering will alter evidence and may make later forensic analysis impossible.
- Full disk images (complete /data partition and system images) typically require specialist tools, rooting, or the device bootloader unlocked — these actions will change the device and can destroy legal evidence.
- If you need a full forensic image, contact a certified mobile forensics lab or law enforcement and follow their instructions.

## 6) Account containment and cleanup (use another device)

From a separate, trusted computer or phone:

- Change your Google account password and enable two-factor authentication.
- Visit https://myaccount.google.com/security to review devices and sign out unknown devices.
- Revoke access to suspicious third-party apps (Security → Third-party apps with access).
- Review Google Ads/Ad Settings (https://adssettings.google.com) and Activity (https://myactivity.google.com) for suspicious activity.

If you must regain immediate personal security, after preserving what you can, a factory reset is an option — but only after you have saved critical evidence or if your immediate safety requires it.

## 7) Reporting, forensics, and support

- Local law enforcement: file a report and provide the evidence folder, timestamps, screenshots, and any logs. Ask for guidance on digital evidence handoff.
- Certified forensics firms: look for "mobile device forensics" + your city. They can create a full image and analyze it without altering key data.
- Support and hotlines: if stalking or harassment is occurring, seek local stalking/harassment support resources, victim services, or domestic violence hotlines in your area.

## 8) Privacy & safety notes

- The artifacts you collect (bugreports, logcat, photos) may contain extremely sensitive personal data. Keep them encrypted and share only with law enforcement or a trusted forensics lab.
- Do not upload evidence to public sites or social media.

## 9) If you want help from me (what I can do here)

- I can walk you through each ADB command and help you interpret outputs if you paste them here.
- I can help prepare a packet of evidence (checksums + README of what you collected) to share with police or a forensics firm.
- I cannot perform remote actions on your devices or contact authorities for you.

## 10) Quick checklist (copyable)

- [ ] Are you in immediate danger? If yes, call emergency services.
- [ ] Photograph device and suspicious screens.
- [ ] Put the phone in Airplane Mode and keep it powered on if safe.
- [ ] Prepare Linux host and install ADB.
- [ ] Connect device, accept RSA key, run `adb bugreport` and `adb logcat -d`.
- [ ] Pull `/sdcard` and collect package list and readable APKs.
- [ ] Hash all collected files and store them offline/encrypted.
- [ ] Change Google password from a separate device and enable 2FA.
- [ ] Contact law enforcement and a mobile forensics firm as needed.

---

If you want me to add a template evidence README or sample email to law enforcement, tell me and I'll generate them next.

Stay safe. Preserve evidence first; get professional help for full recovery.
