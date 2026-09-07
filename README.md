# 🔐 SSH Brute-Force Detection & Incident Investigation Lab

## 📌 Overview

This project demonstrates how SSH brute-force activity can be identified and investigated using Linux authentication logs and a custom Bash detection script.

I created an isolated virtual lab consisting of a Kali Linux machine used to simulate suspicious activity and an Ubuntu 22.04 machine acting as the target system.

The project covers reconnaissance, authentication monitoring, log analysis, source IP identification, detection engineering, and incident response.

---

## 🎯 Objectives

- Build an isolated cybersecurity testing environment
- Identify exposed SSH services using Nmap
- Establish a baseline for legitimate SSH authentication
- Simulate repeated failed SSH login attempts
- Analyze Linux SSH authentication logs
- Identify the source of suspicious authentication activity
- Develop a Bash-based detection script
- Generate alerts when failed authentication attempts reach a defined threshold
- Validate the detection logic with additional activity

---

## 🖥️ Lab Architecture

```text
┌──────────────────────────┐
│       Kali Linux         │
│      192.168.64.3        │
│                          │
│ Nmap / Attack Simulation │
└────────────┬─────────────┘
             │
             │ SSH / TCP 22
             ▼
┌──────────────────────────┐
│      Ubuntu 22.04        │
│      192.168.64.2        │
│                          │
│ OpenSSH Server           │
│ systemd Journal          │
│ ssh_detector.sh          │
└──────────────────────────┘
```

The environment was isolated within a virtual network and used only for authorized cybersecurity testing.

---

## 🛠️ Tools & Technologies

- Kali Linux
- Ubuntu 22.04 LTS
- UTM Virtualization
- Nmap
- OpenSSH
- Bash
- journalctl
- grep
- awk
- Linux command line

---

## 🔎 Reconnaissance

Nmap was used from the Kali Linux system to identify the SSH service running on the Ubuntu target.

```bash
nmap -sV -p 22 192.168.64.2
```

The scan identified TCP port 22 as open and detected an OpenSSH service.

---

## ✅ Authentication Baseline

Before generating suspicious activity, a legitimate SSH connection was established from Kali Linux to Ubuntu.

The successful authentication event was identified in the Ubuntu system journal.

```bash
sudo journalctl -u ssh --no-pager | grep "Accepted"
```

Establishing this baseline provided a comparison between legitimate and suspicious authentication activity.

---

## 🚨 Attack Simulation

Repeated failed SSH authentication attempts were generated from the Kali Linux system against the Ubuntu VM in the isolated lab.

Ubuntu recorded events including:

```text
Failed password for invalid user fakeuser from 192.168.64.3
```

No unauthorized access was obtained during the simulation.

---

## 🔍 Log Analysis

Authentication events were filtered from the system journal:

```bash
sudo journalctl -u ssh --no-pager | grep "Failed password"
```

The source IPs were extracted and aggregated to determine how many failed attempts originated from each system.

The investigation identified:

```text
Source IP: 192.168.64.3
Initial Failed Attempts: 3
```

---

## 🧠 Detection Engineering

I developed `ssh_detector.sh` to automate analysis of SSH authentication failures.

The script:

1. Reads SSH events using `journalctl`
2. Filters failed password events
3. Extracts source IPv4 addresses
4. Groups authentication failures by source
5. Counts the number of failed attempts
6. Compares the count against a detection threshold
7. Generates an alert when the threshold is reached

The detection threshold was configured at:

```text
3 failed authentication attempts
```

---

## 🚨 Detection Result

After three failed authentication attempts, the script generated:

```text
[ALERT] Possible SSH brute-force activity detected!
Source IP: 192.168.64.3
Failed Attempts: 3
Threshold: 3
Recommended Action: Investigate and consider blocking source.
```

Additional activity was then generated to validate the detector.

The script successfully updated the count to:

```text
Failed Attempts: 6
```

This demonstrated that the alert was based on authentication log data rather than a hard-coded result.

---

## 🛡️ Incident Response Recommendations

Based on the investigation, potential defensive measures include:

- Implement SSH key-based authentication
- Disable password authentication when appropriate
- Restrict SSH access through firewall rules
- Implement rate limiting or Fail2ban
- Disable unnecessary accounts
- Apply the principle of least privilege
- Continuously monitor authentication events
- Investigate repeated authentication failures

---

## 🧩 Skills Demonstrated

- Cybersecurity lab development
- Linux administration
- Network reconnaissance
- Nmap scanning
- SSH security
- Authentication log analysis
- Bash scripting
- Regular expressions
- Detection engineering
- Event correlation
- Incident investigation
- Source IP attribution
- Security monitoring
- Incident response

---

## 📊 Project Result

The project successfully demonstrated the process of moving from raw security events to actionable detection:

**Reconnaissance → Baseline → Attack Simulation → Log Analysis → Detection → Alert → Investigation → Response**

The custom Bash detector successfully identified repeated SSH authentication failures and generated an alert after the configured threshold was reached.

---

## ⚠️ Disclaimer

This project was performed in an isolated virtual lab using systems that I own and control. The techniques demonstrated are intended solely for cybersecurity education, defensive security research, and authorized testing.
