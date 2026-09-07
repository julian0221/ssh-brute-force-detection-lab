# Incident Report: SSH Brute-Force Activity

## Incident Summary

During a controlled cybersecurity lab exercise, repeated failed SSH authentication attempts were detected against an Ubuntu 22.04 system.

The suspicious activity originated from a Kali Linux system at `192.168.64.3` and targeted an Ubuntu system at `192.168.64.2` over SSH (TCP port 22).

The activity was intentionally generated within an isolated virtual environment to practice security monitoring, log analysis, detection engineering, and incident investigation.

---

## Incident Details

| Field | Details |
|---|---|
| Incident Type | Suspected SSH Brute-Force Activity |
| Source System | Kali Linux |
| Source IP | 192.168.64.3 |
| Target System | Ubuntu 22.04 |
| Target IP | 192.168.64.2 |
| Target Service | SSH |
| Port | TCP 22 |
| Attempted Username | fakeuser |
| Initial Failed Attempts | 3 |
| Final Failed Attempts | 6 |
| Detection Threshold | 3 |
| Unauthorized Access | No |
| Environment | Isolated Virtual Lab |

---

## Detection

SSH authentication events were analyzed using the Ubuntu systemd journal.

The following command was used to identify failed SSH authentication attempts:

```bash
sudo journalctl -u ssh --no-pager | grep "Failed password"
```

The logs revealed multiple failed authentication attempts originating from `192.168.64.3`.

Example:

```text
Failed password for invalid user fakeuser from 192.168.64.3
```

---

## Investigation

The failed authentication events were analyzed to identify their source and determine how many attempts occurred.

The investigation initially identified:

```text
3 from 192.168.64.3
```

This indicated that multiple failed SSH authentication attempts originated from the same source IP address.

A custom Bash detection script named `ssh_detector.sh` was developed to automate this analysis.

---

## Detection Logic

The custom detector performs the following actions:

1. Reads SSH events from `journalctl`
2. Filters events containing `Failed password`
3. Extracts the source IPv4 address
4. Groups events by source IP address
5. Counts failed authentication attempts
6. Compares the count against a defined threshold
7. Generates an alert when the threshold is reached

The detection threshold was configured at:

```text
3 failed authentication attempts
```

---

## Alert Generated

After three failed authentication attempts were recorded, the detector generated the following alert:

```text
[ALERT] Possible SSH brute-force activity detected!
Source IP: 192.168.64.3
Failed Attempts: 3
Threshold: 3
Recommended Action: Investigate and consider blocking source.
```

Additional failed authentication attempts were then generated to validate the detector.

The detector subsequently reported:

```text
Failed Attempts: 6
Threshold: 3
```

This confirmed that the script was dynamically analyzing the authentication logs rather than displaying a hard-coded result.

---

## Impact Assessment

No unauthorized access occurred.

The attempted username was invalid, and the suspicious authentication attempts were unsuccessful.

Because the activity was performed in an isolated cybersecurity lab using systems under my control, no production systems or third-party systems were affected.

---

## MITRE ATT&CK Mapping

The simulated activity aligns with:

**T1110 — Brute Force**

This technique covers attempts to gain access to accounts through repeated credential guessing.

---

## Recommended Remediation

Recommended defensive measures include:

- Implement SSH key-based authentication
- Disable SSH password authentication where appropriate
- Restrict SSH access with firewall rules
- Implement Fail2ban or similar rate-limiting controls
- Disable unused accounts
- Apply least-privilege principles
- Continuously monitor authentication logs
- Establish alert thresholds for abnormal login behavior
- Investigate repeated authentication failures
- Block malicious source addresses when appropriate

---

## Conclusion

This investigation successfully demonstrated the detection and analysis of repeated SSH authentication failures.

Linux authentication logs were analyzed to identify the source and frequency of suspicious activity. A custom Bash detection script was then developed to automate event filtering, source IP extraction, aggregation, threshold comparison, and alert generation.

The detector successfully triggered after three failed authentication attempts and updated to six attempts after additional testing.

This lab demonstrates practical experience with Linux security monitoring, log analysis, detection engineering, Bash scripting, and incident investigation.

---

## Disclaimer

This project was conducted in an isolated virtual lab using systems that I own and control. All activity was performed strictly for cybersecurity education and authorized defensive security testing.
