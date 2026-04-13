# Product Limitations: Certificate Management

This cookbook manages X.509 certificates, private keys, and CA bundles by writing
files into the platform's standard TLS directories. It does not install or manage
the operating system certificate toolchain itself.

## Supported Platforms

The cookbook currently tests the following platform families in Kitchen and CI. The
resource only relies on standard filesystem paths, so support is constrained by
those path conventions rather than package availability.

| Platform          | Tested Versions | Architecture    | Path Root      | Lifecycle Notes                                                 |
|:------------------|:----------------|:----------------|:---------------|:----------------------------------------------------------------|
| **AlmaLinux**     | 8, 9, 10        | x86_64, aarch64 | `/etc/pki/tls` | AlmaLinux 8, 9, and 10 remain in supported lifecycle windows.   |
| **Amazon Linux**  | 2023            | x86_64, aarch64 | `/etc/pki/tls` | Amazon Linux 2023 has five years of support from AWS.           |
| **CentOS Stream** | 9               | x86_64, aarch64 | `/etc/pki/tls` | CentOS Stream 9 remains supported through May 31, 2027.         |
| **Debian**        | 12, 13          | x86_64, aarch64 | `/etc/ssl`     | Debian 12 and 13 remain supported.                              |
| **Rocky Linux**   | 8, 9, 10        | x86_64, aarch64 | `/etc/pki/tls` | Rocky Linux 8, 9, and 10 remain in supported lifecycle windows. |
| **Ubuntu**        | 22.04, 24.04    | x86_64, aarch64 | `/etc/ssl`     | Ubuntu 22.04 LTS and 24.04 LTS remain supported.                |

## Unsupported or Unverified Platforms

- FreeBSD remains unverified in the current Kitchen matrix and is not declared in `metadata.rb`.
- Fedora, openSUSE, SUSE, Arch, Scientific Linux, and generic Red Hat claims were removed because this cookbook no longer tests them in CI.
- CentOS Linux 8 is end-of-life and should not be reintroduced; CentOS Stream 9 is the tested CentOS-family target.

## Installation Requirements

- `Chef Infra Client >= 15.3` is required for `unified_mode`.
