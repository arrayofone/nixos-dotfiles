---
title: Task Runner
tags: [go-task, workflow, cli]
---

# Task Runner

> [!tip] Quick Reference
> Run `task --list` to see all available commands.
> Run `task <name>` to execute. Pass args with `task <name> -- <args>`.

## Overview

The [[Taskfile.yml]] uses [go-task](https://taskfile.dev) to orchestrate all system
operations. It replaces ad-hoc shell scripts with a declarative, composable task graph.

## Task Categories

### System Operations
Build, switch, test, and deploy system configurations:
- `task build:darwin` / `task build:nixos` — Build without activating
- `task switch:darwin` / `task switch:nixos` — Build and activate
- `task deploy:darwin` / `task deploy:nixos` — Full workflow (check + build + switch + home)

### Home Manager
- `task home:darwin` / `task home:nixos` — Switch home-manager configuration
- `task home:build:darwin` / `task home:build:nixos` — Build without switching

### Secrets
See [[secrets]] for detailed documentation.
- `task secrets:init` — Bootstrap keys and encrypted files
- `task secrets:edit:system` / `task secrets:edit:user` — Edit encrypted files
- `task secrets:encrypt:*` / `task secrets:decrypt:*` — Re-encrypt or decrypt in-place

### Flake Management
- `task update` — Update all flake inputs
- `task update:input -- <name>` — Update a single input
- `task check` — Run `nix flake check`

### Maintenance
- `task gc` — Full garbage collection + store optimization
- `task gc:old -- 14d` — Remove generations older than N days
- `task maintenance` — Weekly routine (update + gc + optimize)

### MicroVM Operations
Remote management of Firecracker VMs on helms-deep:
- `task vm:list` — List running microVMs
- `task vm:start -- <name>` / `task vm:stop -- <name>` — Start/stop a VM
- `task deploy:microvm-host` — Deploy helms-deep configuration

## Variables

| Variable | Value | Purpose |
|----------|-------|---------|
| `FLAKE_DIR` | Working directory | Flake root for all nix commands |
| `NIXOS_HOST` | `baradur` | Default NixOS target |
| `DARWIN_HOST` | `digibook` | Default Darwin target |
| `MICROVM_HOST` | `helms-deep` | MicroVM host target |
