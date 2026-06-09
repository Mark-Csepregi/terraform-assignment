# Exercise 3: Local Kubernetes Developer Pipeline

This directory contains a fully automated local development pipeline designed to abstract away complex Kubernetes orchestration. By utilizing native automation scripts, developers can spin up a local multi-resource environment with a single command.

---

## Architectural & Cost Optimizations

* **Zero-Cost Local Registry Strategy:** Instead of forcing developers to provision an external container registry or run a heavy local registry container, this pipeline uses `minikube image build`. This injects the container image directly into Minikube's internal container cache—saving time, network bandwidth, and infrastructure overhead.
* **Cross-Platform Automation:** Includes standalone orchestrators for both PowerShell and Bash environments, ensuring total workspace flexibility regardless of the engineer's operating system.
* **Automated Port Forwarding:** Automatically hooks into the local networking stack to proxy the container application directly to `localhost:8080`.

---

## Prerequisites

Before executing the initialization pipeline, ensure your local development system has the following core command-line utilities installed and accessible via your system PATH:

* **Minikube** (Local Kubernetes engine)
* **Kubectl** (Kubernetes cluster orchestrator)
* **Hypervisor/Runtime** (Docker Desktop or VirtualBox)

---

## Quick Start Pipeline

Select the terminal execution track below that matches your local operating system.

### Option A: Windows (PowerShell)

1. Launch a standard or elevated **PowerShell** window.
2. Navigate to this exercise directory and execute the orchestrator script:

```powershell
cd C:\Users\mark0\terraform-assignment\exercise-3
powershell -ExecutionPolicy Bypass -File .\deploy.ps1
Option B: Linux & macOS (Bash Terminal)
Open your standard shell terminal.

Navigate to this exercise folder, grant executable permissions to the script, and run it:

Bash
cd /path/to/terraform-assignment/exercise-3
chmod +x ./deploy.sh
./deploy.sh

Validation & Verification

Once the pipeline finishes executing, it will automatically establish a secure network bridge. You can verify the application is actively serving traffic by opening your browser or running a curl command against the designated endpoint:

Endpoint: http://localhost:8080/hello-world

Expected Output: {"message": "Hello, World!"}