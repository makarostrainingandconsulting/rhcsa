# RHCSA RHEL 10: Architecture & Exam Prep - Lab Repository

This repository contains the necessary configuration files and scripts to set up the complete lab environment for the book **"RHCSA RHEL 10: Architecture & Exam Prep"** by William dos Santos.

The lab environment is designed to be a realistic simulation of the Red Hat Certified System Administrator (RHCSA) exam environment, featuring a multi-node setup for hands-on practice.

## 📚 About the Book

This repository is a companion to the book, which provides the full theoretical foundation, step-by-step lab instructions, troubleshooting guides, and a final exam simulation.

**To acquire the full, updated version of the book, please visit the official Amazon page:**

*   **Amazon Kindle/Paperback:** [Link to your Amazon Book Page]
*   **Official Website:** [Link to your Website/Consultancy]

## 🚀 Lab Environment Setup (Vagrant)

The lab uses **Vagrant** and **VirtualBox** (or another provider like Libvirt) to provision three RHEL 10 virtual machines: `master`, `client`, and `storage`.

### Prerequisites

1.  **Virtualization Software:** [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (Recommended) or [Libvirt/KVM](https://libvirt.org/).
2.  **Vagrant:** [Download and Install Vagrant](https://www.vagrantup.com/downloads).
3.  **Git:** Installed on your local machine.

### Quick Start

1.  **Clone the Repository:**
    ```bash
    git clone https://github.com/makarostrainingandconsulting/rhcsa.git
    cd rhcsa
    ```

2.  **Start the Lab Environment:**
    This command will download the RHEL 10 box, provision the three VMs, configure their network interfaces, and run the `scripts/provision.sh` script.
    ```bash
    vagrant up
    ```

3.  **Access the Nodes:**
    ```bash
    vagrant ssh master
    vagrant ssh client
    vagrant ssh storage
    ```

4.  **Stop/Destroy the Environment:**
    ```bash
    vagrant halt   # Gracefully shut down the VMs
    vagrant destroy -f # Completely remove the VMs and free up disk space
    ```

## 💻 Lab Architecture

| Node | Role | IP Address | Secondary Disk |
| :--- | :--- | :--- | :--- |
| **master** | Main Administration, Web Server, NFS Server | 192.168.56.10 | 5 GB (`/dev/sdb`) |
| **client** | Client Workstation, Container Host | 192.168.56.20 | - |
| **storage** | NFS Server, LVM Host | 192.168.56.30 | - |

## 📁 Repository Structure

| File/Directory | Description |
| :--- | :--- |
| `Vagrantfile` | Main configuration file for the 3 virtual machines. |
| `scripts/` | Contains the `provision.sh` script for initial VM setup. |
| `labs/` | Templates and solutions for the hands-on exercises in the book. |
| `modules/` | Supplementary files organized by book module. |
| `README.md` | This file. |
| `.gitignore` | Excludes Vagrant and VM files from the repository. |
