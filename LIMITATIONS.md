# Product Limitations: Certificate Management

This cookbook provides generic management of X.509 certificates, private keys, and CA bundles from various Chef Data Bag formats.

## Supported Platforms

The following platforms are confirmed as supported for standard certificate management paths (`/etc/ssl` or `/etc/pki/tls`):

| Platform | Architecture | Vendor Support | Package Manager |
| :--- | :--- | :--- | :--- |
| **Ubuntu** | x86_64, aarch64 | [Canonical](https://ubuntu.com) | `apt` |
| **Debian** | x86_64, aarch64 | [Debian](https://debian.org) | `apt` |
| **AlmaLinux** | x86_64, aarch64 | [AlmaLinux](https://almalinux.org) | `dnf` |
| **Rocky Linux** | x86_64, aarch64 | [Rocky Linux](https://rockylinux.org) | `dnf` |
| **Amazon Linux** | x86_64, aarch64 | [AWS](https://aws.amazon.com/linux/amazon-linux-2023/) | `dnf` / `yum` |
| **FreeBSD** | x86_64, aarch64 | [FreeBSD](https://freebsd.org) | `pkg` |

## Installation Requirements

* **Chef Infra Client**: >= 15.3 (Required for `unified_mode`)
