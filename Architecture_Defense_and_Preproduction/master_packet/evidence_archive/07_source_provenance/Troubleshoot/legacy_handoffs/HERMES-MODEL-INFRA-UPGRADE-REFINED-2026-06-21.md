# Hermes Model & Inference Infrastructure Upgrade

- Date: 2026-06-21
- Purpose: refine the June 19 proposal against the Hermes state that is actually verified today
- Source proposal: `L:\Agentic_OS\🧠 Model & Inference Infrastructure Upgrade Proposal.md`

## Executive Summary

The original proposal correctly identified that Hermes needed a cleaner model and inference foundation, but it was written against a stale broken state:

- Hermes desktop was pinned to stale local UI state
- Hermes config was mismatched against the wrong provider/base URL
- local inference was not yet freshly verified

Those stabilization issues are now resolved.

Current verified state:

- Primary model: `qwen3.6:latest`
- Primary provider lane: `custom`
- Primary endpoint: `http://127.0.0.1:11434/v1`
- Local Hermes inference: verified with `hermes -z "Reply with exactly LOCAL_OK"` -> `LOCAL_OK`
- Ollama local model inventory: verified
- Ollama loaded model on GPU during verification: verified
- Nous Portal auth: verified logged in
- Hermes fallback chain: `anthropic/claude-sonnet-4.6` via `nous`
- Hermes desktop stale `qwen3.6:35b-a3b` sticky state: removed by rotating stale desktop local storage and letting Hermes rebuild a clean store

This means the practical stabilization intent of Track A has already been achieved, even though not every proposed sub-step was executed verbatim.

## What Was Completed

### 1. Stabilized Hermes local primary lane

Completed:

- switched Hermes root config to local Ollama
- verified local Ollama responds directly
- verified Hermes CLI reaches local Ollama end to end

Verified config:

```yaml
model:
  base_url: http://127.0.0.1:11434/v1
  default: qwen3.6:latest
  provider: custom
```

### 2. Stabilized Hermes desktop state

Completed:

- confirmed roaming Hermes desktop local storage still contained stale `qwen3.6:35b-a3b`
- preserved backups
- rotated the stale `Local Storage` folder out of the way
- launched the packaged Hermes desktop app
- verified a fresh desktop local storage database was rebuilt
- verified the old `qwen3.6:35b-a3b` records no longer appeared in the rebuilt DB

### 3. Added cloud fallback without disturbing the local primary

Completed:

- authenticated Hermes with Nous Portal
- preserved local Ollama as the primary lane
- configured Hermes fallback chain to use Nous if the local primary fails

Verified fallback state:

```yaml
fallback_providers:
  - provider: nous
    model: anthropic/claude-sonnet-4.6
```

## What Track A Means Now

### Track A Status: Functionally achieved, but not fully benchmarked

The original Track A goal was:

- activate the existing local stack
- make Hermes use the local model reliably
- get immediate performance improvement with minimal architecture change

That goal is now satisfied in operational terms.

What is true now:

- local inference works
- Hermes reaches the local model correctly
- desktop no longer re-poisons the model selection
- a cloud fallback exists

What is not yet proven from the original Track A framing:

- exact token-per-second throughput
- whether any additional CUDA/runtime tuning is still needed
- whether WSL/GPU tuning would materially improve current performance

So Track A should now be treated as:

- `stabilization complete`
- `performance tuning still open`

## Original Proposal Items That Are Now Outdated

These assumptions should be removed or rewritten before architect review:

- Hermes is still pinned to `qwen3.6:35b-a3b`
- Hermes is still broken because of local routing alone
- Ollama CPU-only behavior is the confirmed root cause of the earlier failure
- the system is still in the same broken state described on June 19

Those were valid at the time they were written, but they no longer describe the machine after the June 21 cleanup.

## What Remains Unverified

These are the next legitimate technical questions:

### 1. Local performance characterization

We still need a benchmark pass to answer:

- warm prompt latency
- sustained token throughput
- VRAM usage under local Hermes calls
- whether multiple concurrent local requests are viable with the current stack

### 2. Whether extra CUDA/runtime changes are necessary

We proved local inference works and the model was observed on GPU during verification.

We have not yet proven:

- whether the current Ollama/CUDA setup is already optimal
- whether reinstalling or tuning CUDA-facing pieces would improve throughput
- whether WSL GPU memory tuning is needed at all

### 3. Whether Track B is justified

vLLM should only be considered after measurement shows that the current Ollama-based local lane is insufficient for:

- concurrency
- latency
- context handling
- agent swarm throughput

### 4. Whether Track C is justified

Track C is not a stabilization task. It is a platform expansion project.

It should only begin after:

- local baseline is benchmarked
- routing goals are written down
- control-plane ownership is specified
- failure semantics are defined

## Refined Decision Framework

The original proposal mixed together four different decisions. They should now be separated.

### Phase 1. Stabilization

Status: complete

Completed:

- fixed local primary lane
- fixed desktop sticky state
- added Nous fallback

### Phase 2. Performance Measurement

Status: next

Needed:

- benchmark Hermes local latency
- benchmark direct Ollama latency
- inspect whether the current local stack is GPU-efficient enough
- define whether the actual pain is first-token latency, total throughput, or concurrency

### Phase 3. Routing Policy

Status: not yet designed

Questions to answer:

- which tasks should stay local
- which tasks should go to Nous
- whether subagents should prefer local by default
- what fallback order should apply for swarm work
- whether desktop, CLI, dashboard, and gateway should share one authoritative runtime policy

### Phase 4. Infrastructure Expansion

Status: deferred

Candidates:

- Track B: vLLM
- Track C: multi-model local routing fabric

These are only justified after Phases 2 and 3.

## Recommended Path Forward

### Recommended immediate path

1. Keep the current working shape:
   - local Ollama primary
   - Nous fallback
2. Run a benchmark pass before changing infrastructure.
3. Decide whether the system needs:
   - faster single-model inference
   - concurrent local inference
   - hybrid local/cloud routing
   - full multi-model swarm routing
4. Only after that, revisit Track B or Track C.

### Recommendation on the original tracks

- Track A: keep as completed stabilization plus optional tuning follow-up
- Track B: hold until benchmark evidence shows Ollama is the bottleneck
- Track C: treat as a separate architecture proposal, not an upgrade footnote

## Proposed Next Work Package

The next work package should be:

### Work Package: Benchmark and Routing Baseline

Deliverables:

- measured local Hermes latency
- measured direct Ollama latency
- measured cloud fallback latency
- documented recommended lane split:
  - local primary use cases
  - cloud fallback use cases
  - future swarm-routing candidates

Success criteria:

- we can explain whether current Hermes is "fast enough"
- we know whether further CUDA/runtime work is worth the risk
- we know whether vLLM is a real need or just a speculative upgrade

## Architect Bottom Line

The machine is no longer in the broken state assumed by the June 19 proposal.

Today’s correct interpretation is:

- the stabilization portion of the proposal is already achieved
- the remaining work is no longer "repair Hermes"
- the remaining work is "measure performance, define routing policy, then decide whether to expand the local inference fabric"

That is the cleanest way to move from recovery into using Hermes to build Hermes.
