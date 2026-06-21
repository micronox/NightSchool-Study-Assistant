# Hermes-on-WSL Stack Analysis and Agentic OS Buildout Plan

## Executive Summary

The current Hermes stack runs a WSL2‑authoritative backend on Ubuntu 24.04 with local Ollama (Qwen 3.6) as the primary provider, OpenRouter as an auxiliary provider, and a Windows Hermes Desktop client attached remotely to a WSL‑hosted dashboard. This architecture is aligned with upstream guidance that prefers Linux/WSL for production Hermes runtimes while allowing native Windows or desktop clients as UX surfaces. Community materials and official release notes for Hermes Agent v0.16 confirm that remote‑gateway desktop connections are a first‑class feature, but they also show that local helper processes and Windows‑side state under `%APPDATA%`/`%LOCALAPPDATA%` are expected parts of the design.[^1][^2][^3][^4][^5][^6]

For the memory layer, Hermes exposes a pluggable external memory provider system with OpenViking as a first‑class backend, and this can be combined with a local markdown/graph vault such as Obsidian via MCP or HTTP tools. On top of this stack, multiple creators and educators describe "agentic OS" patterns built on Hermes: a mission‑control dashboard, Kanban task orchestration, persistent knowledge graphs, and scheduled jobs that let teams of agents operate continuously. These patterns are directly compatible with a WSL‑backed Hermes plus Windows desktop thin client, and can be specialized for a 3D/visualization‑heavy workflow such as MyKu.[^7][^8][^9][^10][^11][^12]

The rest of this report answers the unresolved Hermes questions in the spec, then lays out:

- Where to anchor Hermes Desktop and how to think about Windows vs WSL responsibilities.
- A concrete desktop‑oriented workflow model for future projects.
- A stepwise plan to build a self‑improving Hermes agentic loop that provisions tools, creates skills, and wires memory.
- How to plug in an OpenViking/Viking memory layer alongside an Obsidian/Open‑Brain vault.
- Practical guidance for using Hermes in Upwork/client repos.
- A staged roadmap for an agentic OS on top of Hermes.
- A curated starting set of GitHub/Youtube resources that align with your stack and goals.

***

## 1. Clarifying Hermes Desktop Behavior on Windows

### 1.1 Local helper processes in remote mode

Hermes v0.16 provides a native Electron desktop app that can connect to local or remote Hermes gateways over HTTP/WebSocket. Community desktop companions and early forks also use local Python helper processes to manage dashboard connections and streaming even when the logical backend is remote. In that context, Windows‑local `python.exe -m hermes_cli.main dashboard` processes are consistent with helper/bootstrap behavior rather than evidence that the main agent runtime has migrated to Windows.[^2][^4][^6]

Given the spec’s validated evidence (remote dashboard in WSL, `/api/status` from WSL gateway, WSL paths in tool output), stray Windows helper/dashboard processes are best interpreted as UI helpers rather than additional authoritative runtimes. They should be monitored, but they do not contradict the WSL‑first backend model as long as the configured remote URL continues to point to the WSL gateway.[^1][^2]

### 1.2 File browsing semantics in Desktop

Hermes Desktop surfaces file pickers and directory views rooted in the host OS where the Electron app runs, which on Windows typically means the user profile directory. Documentation and community tutorials emphasize that the desktop can connect to a remote gateway while still feeling "local" to the user, which implies that file browsing and tool execution contexts can diverge: file pickers show local files, whereas registered tools may operate on remote filesystem paths.[^6][^2]

In practice this leads to mixed semantics:

- File browsing in the desktop UI is Windows‑rooted (e.g., `C:\Users\<you>`), unless a plugin explicitly proxies into a remote path.[^2]
- Tool execution for core Hermes skills is bound to the gateway runtime, so file tools see the backend filesystem (`/home/larry/...` in WSL in your stack).[^6][^1]

This matches what was observed in the spec: Desktop showing Windows home while tool output clearly referenced `/home/larry/.hermes/...` paths.

### 1.3 Separation of file browsing vs tool execution

Hermes’ architecture draws a line between the desktop UI and the gateway runtime: the desktop app streams tool invocations and responses over HTTP/WebSocket, while tools themselves run on the gateway. Tutorials for remote deployments explicitly show that the desktop can connect to a VPS gateway while the user’s laptop has no local Hermes runtime, which confirms that tool execution context is purely backend‑side even when file pickers are local.[^13][^4][^14][^2]

Therefore:

- Desktop file browsing is largely cosmetic unless explicitly coupled to a sync or upload tool.
- Tool execution context and path resolution remain governed by the backend (WSL in your stack), which is the correct and desired behavior for Hermes tooling.

### 1.4 Location of `connection.json` and Windows‑side state

Various Hermes and companion tools follow the standard Electron/AppData pattern on Windows, storing configuration and connection state under `%APPDATA%` or `%LOCALAPPDATA%`. For Hermes itself, installer documentation shows the native Windows CLI and data under `%LOCALAPPDATA%\hermes` with `.env` and config files in that location, while desktop configuration such as connection profiles typically lives in separate app‑specific folders under `%APPDATA%`.[^3][^5][^15][^16]

Your spec’s observation of `%APPDATA%\Hermes\connection.json` is fully consistent with that pattern: it is an expected persistence file for saving the chosen connection mode (local/remote) and remote URL, not a sign of conflicting backend authority.[^3][^1]

### 1.5 Support status of remote Desktop mode in v0.16

Official v0.16 "Surface Release" notes highlight the native desktop app and explicitly call out remote gateway connection as a headline feature, positioning Hermes Desktop as a thin client for local or remote runtimes. Independent tutorials and long‑form guides treat remote attachment (VPS, home server, WSL) as a primary deployment scenario, not a hidden or experimental feature.[^4][^14][^17][^13][^2]

Given this, the remote Desktop architecture in v0.16 should be regarded as production‑intended but still fast‑moving, with some caveats:

- It is officially supported and actively developed.[^2]
- Edge cases such as helper process behavior and file‑semantic clarity are still being refined, especially on Windows.

Your "supported with caveats" label for Segment F is therefore accurate: the pattern is valid, but the ergonomics and observability on Windows are still maturing.

### 1.6 Provider base URL and Windows host bridging

Hermes provider documentation shows local and remote providers being configured purely at the gateway level, with local self‑hosted endpoints like Ollama or vLLM addressed over loopback (e.g., `http://127.0.0.1:11434/v1`) inside the environment where Hermes runs. Desktop remote mode simply connects to the Hermes gateway’s HTTP/WebSocket API and does not directly talk to providers like Ollama.[^18]

In your architecture, `CUSTOM_BASE_URL=http://127.0.0.1:11434/v1` is evaluated inside WSL, where Ollama is already listening on port 11434; desktop remote mode never needs a Windows‑side bridge to that Ollama instance. The Windows host IP workaround seen in some tutorials applies only when a Windows‑hosted client needs to call WSL services directly, which is not the case when Hermes Desktop is talking to the gateway rather than to Ollama.[^18][^1]

### 1.7 Windows directories used by Hermes Desktop

Across Hermes docs and third‑party guides, the following Windows locations appear consistently for Hermes and related tools:[^5][^15][^16][^3]

- `%LOCALAPPDATA%\hermes` — native Windows CLI/runtime install root (`hermes-agent`, bundled Git, `.env`, provider config).
- `%APPDATA%\Hermes` or similar — desktop app configuration (connection profiles, UI settings).
- Per‑app cache directories under `%LOCALAPPDATA%` — Electron cache, logs, download caches.

Some third‑party dashboards (Hermes Studio, Script‑hosted Web UI) explicitly state that they "bundle" the Web UI runtime and reuse the native Hermes data location `%LOCALAPPDATA%\hermes` on Windows. This suggests the following breakdown for Desktop in your environment:[^16]

- Settings & connection state: `%APPDATA%\Hermes` (e.g., `connection.json`).
- Cache: `%LOCALAPPDATA%\Hermes\Cache` and typical Electron subfolders.
- Logs: application‑specific log files either under `%LOCALAPPDATA%\Hermes\logs` or OS‑managed logs (Event Viewer entries).
- Sessions: primarily stored by the WSL gateway (`~/.hermes`), with some UI metadata mirrored in Windows app‑data.

### 1.8 Relocating Hermes Desktop app‑data/state

Neither official docs nor community install guides recommend relocating Hermes app‑data folders; instead they assume the standard `%APPDATA%` and `%LOCALAPPDATA%` locations. Where relocation is discussed (for other Electron apps or Obsidian/Claude configs), the pattern is typically to:[^5][^16][^3]

- Use symlinks/junctions (e.g., `mklink /J`) to point the default path at another drive.
- Or set application‑specific environment variables if documented.

In Hermes’ case, there is explicit support for configuring the runtime home (`~/.hermes` vs `%LOCALAPPDATA%\hermes`), but no official mechanism for changing where the desktop app keeps its UI state. Relocating `%APPDATA%\Hermes` is therefore possible via NTFS junctions but should be treated as advanced/unsupported: it may reset Desktop UI state, and all critical backend state should remain in `~/.hermes` on WSL as your spec already emphasizes.[^19][^3]

***

## 2. Best Location and Role for Hermes Desktop in a WSL‑First Stack

### 2.1 Architectural placement

Upstream guidance still recommends WSL2 or Linux as the primary production runtime for Hermes Agent, with native Windows installs labeled as less broadly road‑tested in earlier releases and then improved over time. The v0.16 Surface Release adds a desktop thin client that can attach to remote gateways, matching the model you already use: WSL as compute, Windows as UX.[^4][^3][^5][^2]

In this context the "best" location for Hermes Desktop is:

- Installed on Windows for local UX and easy multi‑monitor usage.
- Configured in remote mode, pointing to the WSL gateway (`http://localhost:9119` in your validated setup).
- Treated as stateless relative to WSL: resettable without losing core state.

### 2.2 Responsibilities by lane

A clear division of responsibilities keeps the system predictable:

- **WSL**
  - Owns `~/.hermes` for config, skills, memory, sessions, jobs, and logs.[^1]
  - Hosts Ollama and other providers (Qwen, Gemma) as local services.[^18][^1]
  - Runs the Hermes gateway/dashboard (`hermes dashboard --host 0.0.0.0 --port 9119`).[^1]
- **Windows Desktop**
  - Hosts Hermes Desktop app and any visualization tools (VSCode, browser, 3D viewers).
  - Stores connection metadata and basic preferences under `%APPDATA%\Hermes`.
  - Acts as a pure client to the WSL gateway, sending prompts and receiving results.

This aligns with the design goal from your spec: "use Windows for UX, WSL for compute, tools, state, and provider authority."[^1]

### 2.3 Persistence and backups

Because the authoritative state is in `~/.hermes` and in your host‑backed `L:\AI_Vault` for models and artifacts, backups should focus on:

- `~/.hermes` in WSL (config, memory, skills, sessions).
- `L:\AI_Vault\Ollama_Models` and `L:\AI_Vault\HuggingFace_Hub` on Windows.[^1]

Windows Desktop app‑data can be left out of backups or backed up only as a convenience layer; it is reproducible from Hermes gateway state.

***

## 3. Desktop‑Centric Workflow for Future Projects

### 3.1 Project workspace model

Community Hermes OS guides emphasize a "mission control" metaphor: a unified place where workflows, agents, and memory are organized, often backed by a canonical file tree and Kanban board. In your stack, that can map to:[^10][^11][^12]

- A WSL project root such as `~/projects/hermes-os` containing:
  - `/skills` — custom skills and MCP definitions.
  - `/projects/myku` — manifests for 3D/visual pipelines.
  - `/projects/clients` — manifests and skills per client.
- A corresponding Windows view via VSCode Remote or terminal integrations for editing.

Hermes sessions for each project can be tagged and pinned in the dashboard, while a Kanban‑style board (either in an external tool or a dashboard plugin) holds high‑level missions for agents.

### 3.2 Day‑to‑day desktop flow

Typical daily workflow on Windows becomes:

1. Start WSL (ensuring the Ubuntu distribution and Docker/Ollama are running).[^3][^1]
2. Launch the Hermes gateway in WSL (`hermes dashboard --host 0.0.0.0 --port 9119`).[^1]
3. Open Hermes Desktop on Windows and connect in remote mode to `http://localhost:9119` with basic auth.
4. Pin key sessions: `MyKu-Core`, `Hermes-OS-Build`, `Client-<name>-Work`.
5. Drive coding and research from a mix of:
   - Hermes Desktop chat sessions.
   - VSCode (WSL Remote) for editing repos.
   - Browser (Perplexity, docs) for auxiliary research.

Agent OS materials emphasize starting from a simple to‑do list and adding one automation per week, which maps well to your multi‑project environment.[^11][^12]

### 3.3 Multi‑project management

Agent OS tutorials recommend using either a Kanban board or a task list as the top‑level abstraction for projects, where each card/task maps to a Hermes workflow or mission. For your usage:[^10][^11]

- Each MyKu feature (e.g., "SceneCanvas glTF orchestrator", "Film‑language shot schema integration") becomes a Kanban card.
- Each Upwork/client engagement gets its own swimlane.
- Hermes skills and jobs (crons) are associated with these tasks; Hermes sessions reference the card IDs to keep context aligned.

This keeps the Hermes Desktop workspace from turning into an unstructured chat log.

***

## 4. Building a Hermes Agentic Loop to Grow Its Own Environment

### 4.1 Concept: self‑improving loop

Hermes billboards itself as "the agent that grows with you," and official and community materials illustrate feedback loops where Hermes observes its own history, updates skills, and refactors workflows over time. The loop typically involves:[^20][^14][^17]

- System prompts or skills describing how to extend the environment.
- Scheduled jobs to periodically review logs and sessions.
- Memory providers that keep track of decisions, preferences, and architecture.

In your WSL‑first stack, the loop can focus on provisioning tools, scaffolding skills, and maintaining manifests for projects like MyKu and AI Docs.

### 4.2 Step 1: Tool introspection and inventory

Using Hermes’ built‑in skills and file tools, the first job is to map what exists:

- A `tool_inventory` skill that:
  - Scans `~/projects` and `~/.hermes/skills` for existing tools and scripts.
  - Reads `config.yaml`, `.env`, and provider configs to understand capabilities.[^18][^1]
  - Writes a structured inventory document (`skills_inventory.md`).

This can be implemented as a custom skill script in Python or shell that Hermes calls with a standard interface, then refined based on agent feedback.

### 4.3 Step 2: Environment growth skill

Next, create a `grow_environment` skill that:

- Accepts a goal description such as "add a WebGPU analyser skill for MyKu shaders".
- Reads the inventory and project manifests.
- Proposes concrete filesystem changes (new skill files, utility modules, config updates).
- Applies changes via file tools after confirmation.

Agent OS tutorials show similar patterns where agents generate, update, and test workflows inside Hermes, using the dashboard and skills to coordinate tasks.[^12][^17][^10]

### 4.4 Step 3: Automatic skill improvement loop

To make it self‑improving:

- Schedule a cron job in Hermes that runs nightly:
  - Reads logs and recent sessions related to `grow_environment` and other skills.
  - Identifies failures, slow paths, or repeated corrections.
  - Proposes updates to skills or documentation, writing to `skills_improvement_plan.md`.

- A second job applies safe edits to skills (e.g., improving prompt templates, updating tool paths) and leaves riskier changes for manual approval.

This pattern matches the "self‑improving autonomous agent" demos where Hermes plus memory providers like Honcho or OpenViking iteratively refine workflows.[^8][^21]

### 4.5 Step 4: Project‑specific loops (MyKu, AI Docs)

For MyKu and AI Docs, define project‑scoped skills and loops:

- `myku_scene_scaffold` skill: given a feature spec, scaffold React Three Fiber components and shader stubs in a WSL repo.
- `ai_docs_pipeline` skill: manage local Ollama/Perplexity workflows, doc generation, and Git commits.

Each project gets its own nightly review job that:

- Reviews merged PRs and session logs.
- Summarizes progress and open questions.
- Suggests next tasks, updating the Kanban board and Hermes sessions.

***

## 5. Plugging in Memory: Open‑Brain/Obsidian Vault and Viking Memory

### 5.1 Hermes memory provider model

Hermes Agent supports pluggable external memory providers via a `memory.provider` configuration, with backends including Honcho, OpenViking, Mem0, Hindsight, and others. Only one external provider can be active at a time, but this is additive to the built‑in `MEMORY.md` and `USER.md`, which remain in effect.[^9][^21][^8]

The memory flow is:

1. Inject provider context into system prompts.
2. Prefetch relevant memories on each turn.
3. Sync conversation state after responses.
4. Extract and store long‑term knowledge at session end.[^9]

### 5.2 OpenViking/Viking as Hermes memory

OpenViking (often referred to as "Viking" in community contexts) is an open‑source context database that Hermes can use as a first‑class memory provider. Official OpenViking docs explicitly document a Hermes Agent integration where:[^7][^8]

- Hermes is pointed at an OpenViking server.
- Memory provider is set to `openviking`.
- Hermes automatically uses `viking_remember`, `viking_recall`, and other tools for long‑term memory.[^22][^7]

Configuration is typically one of:

- `hermes memory setup` and choosing OpenViking interactively.
- Directly editing `config.yaml` to set `memory.provider: openviking` and adding OpenViking connection parameters.[^8][^9]

### 5.3 Obsidian/Open‑Brain vault integration

Agent OS tutorials showcase using an Obsidian vault as the human‑facing knowledge graph, syncing it with Hermes via MCP or HTTP tools so that notes serve as both context and output destination. A practical pattern for your stack:[^11][^12][^10]

- Treat the Obsidian/Open‑Brain vault as the "source of narrative truth" for projects and film‑language schemas.
- Use Hermes tools to:
  - Read key vault files (e.g., MyKu film language ontology, team READMEs).
  - Write session summaries back into the vault as markdown.

Behind the scenes, OpenViking can store embeddings and structured memory extracted from both Hermes sessions and vault content, giving agents a unified long‑term memory layer while Obsidian remains your manual editing surface.[^7][^8][^9]

### 5.4 Combined memory architecture

Putting it together for your stack:

- WSL Hermes backend:
  - `memory.provider: openviking` with connection to an OpenViking server.
  - `MEMORY.md` and `USER.md` configured for core context.
- External memory:
  - OpenViking stores semantic memories and structured facts.
- Human‑curated layer:
  - Obsidian/Open‑Brain vault mirrored between Windows and WSL (e.g., via `L:\Vaults\MyKu` mounted into WSL).

Hermes then:

- Reads from OpenViking on each turn.
- Reads/writes key notes in the vault via file tools.
- Uses skills to reconcile differences between memory and vault content (e.g., nightly sync jobs).

***

## 6. Using Hermes for Upwork and Client GitHub Work

### 6.1 General model: Hermes as a background engineer

Hermes is positioned as a self‑hosted agent that can run 24/7, execute tools, and manage multi‑step workflows, which makes it well suited as a background assistant for freelance work. The key is to keep client data isolated and traceable while leveraging Hermes for repetitive tasks.[^14][^17][^12]

### 6.2 Repository and environment isolation

Recommended pattern:

- Create a `~/clients/lient-name>` tree in WSL.
- For each client repo:
  - Clone into a dedicated subfolder.
  - Set up a `hermes_client_config.yaml` describing languages, frameworks, and coding standards.
- Configure Hermes sessions per client, referencing the relevant directories in system prompts and skills.

This keeps client code separate while still leveraging the same Hermes runtime and provider stack.

### 6.3 Workflow with GitHub

A typical Hermes‑assisted GitHub workflow for client work:

1. Use Hermes tools to clone and update repos in WSL.
2. Ask Hermes to:
   - Generate high‑level codebase maps and dependency graphs.
   - Propose refactors or feature implementations.
3. Implement changes in VSCode (WSL Remote) with Hermes assistance.
4. Use Hermes to draft PR descriptions, commit messages, and review notes.

Agent OS and Hermes course content emphasize using Hermes to manage long‑running tasks, draft artifacts, and maintain project memory, while you retain direct control over Git history and approvals.[^17][^12][^10]

### 6.4 Data and confidentiality considerations

Because your stack uses local Ollama and OpenRouter only as needed, you can:

- Keep sensitive client code confined to WSL and local models.
- Use OpenRouter only for non‑sensitive tasks or anonymized snippets, controlled via provider selection in Hermes.[^18][^1]

This can be an explicit selling point in Upwork profiles: a local, privacy‑respecting agent stack rather than a pure cloud workflow.

***

## 7. Steps to Build an Agentic OS on Top of Hermes

### 7.1 OS concept and components

Agent OS videos describe Hermes‑based systems as mission‑control centers where agents, workflows, and memory are orchestrated through dashboards, Kanban boards, and scheduled jobs. The core components are:[^12][^10][^11]

- A canonical workspace and file tree.
- A set of named agents/skills for common roles.
- A memory layer (Obsidian + OpenViking).
- A task/mission board (Kanban) and scheduler.
- A desktop or web UI as the main cockpit.

### 7.2 Staged roadmap tailored to your stack

Based on both community guidance and your existing spec, a practical roadmap:

1. **Foundation (already done)**
   - WSL Hermes backend with local Ollama and OpenRouter.[^18][^1]
   - Qwen 3.6 configured at 64K context.[^1]

2. **Workspace and manifests**
   - Define `~/projects/hermes-os` and project manifests (`myku.yaml`, `ai_docs.yaml`, `client_<name>.yaml`).
   - Implement a `project_manifest` skill to read and update these manifests.

3. **Memory layer**
   - Deploy OpenViking and configure `memory.provider: openviking` in Hermes.[^8][^7]
   - Sync Obsidian/Open‑Brain vault with Hermes via file tools and MCP.

4. **Kanban and orchestration**
   - Integrate a Kanban tool (could be internal to Hermes dashboard or external like a markdown Kanban board in the vault).
   - Implement an `orchestra_agent` skill that:
     - Reads tasks from the board.
     - Breaks big tasks into subtasks.[^10][^12]
     - Assigns them to child agents/skills.

5. **Automation and crons**
   - Use Hermes scheduled jobs to:
     - Run nightly project reviews.
     - Sync memory and vault content.
     - Rebuild indexes and code maps.

6. **Visualization and 3D integration (MyKu)**
   - Add skills that:
     - Generate Three.js/React Three Fiber scaffolds.
     - Launch or control a MyKu 3D viewer via CLI from WSL.
   - Use Hermes to maintain a catalog of 3D assets and their relationships.

7. **External channels**
   - Connect Telegram/Discord/Slack channels for notifications and lightweight control, as shown in Hermes OS guides.[^12]

### 7.3 Guardrails and complexity management

Agent OS materials repeatedly warn against building too much at once, recommending a "one automation per week" cadence. For your environment, this means:[^11][^12]

- Start with Hermes OS for your own projects (MyKu, AI Docs).
- Add Upwork/client integrations once the core loop is stable.
- Only then add more exotic capabilities (multi‑node setups, advanced dashboards).

***

## 8. GitHub and YouTube Customization Routes for This Tech Stack

### 8.1 GitHub repos aligned with Hermes OS and memory

Relevant repositories and documentation for customization:

- `NousResearch/hermes-agent` — official repo and docs for Hermes Agent, including installation, provider setup, skills, and memory providers.[^20][^5][^18]
- OpenViking Hermes integration docs — details of the Hermes memory provider, including configuration and tools like `viking_remember` and `viking_recall`.[^22][^7]
- Community desktop companion repos (e.g., Hermes Desktop forks, Hermes Studio Desktop) — show how to bundle Web UI runtimes, manage config under `%LOCALAPPDATA%\hermes`, and customize dashboards.[^23][^16][^6]
- Memory provider comparison guides — explain tradeoffs between Honcho, OpenViking, Mem0, and others in Hermes environments.[^9][^8]

These repos are good starting points for:

- Customizing skills and toolchains.
- Experimenting with different memory providers.
- Studying how others structure Hermes‑based dashboards.

### 8.2 YouTube channels and series focused on Hermes Agent OS

Several creators have built significant Hermes content in 2026:

- Hermes Agent OS/Agentic OS walkthroughs by Julian Goldie and similar channels — focus on mission‑control dashboards, Kanban, Obsidian memory layers, and VPS deployments.[^10][^11][^12]
- Full setup guides and courses (e.g., TechWithTim‑style channels) — step‑through Hermes install, skills, crons, and remote hosting.[^17]
- v0.16 release breakdowns — deep dives into the Surface Release, desktop app, remote gateway connection, and web dashboard.[^24][^4]

For your purposes, these are most valuable as patterns to adapt rather than templates to copy. They offer:

- Examples of how others organize Hermes workspaces and dashboards.
- Concrete prompts and skills for task orchestration and memory usage.
- Design ideas for your own MyKu‑centric Hermes OS UI (e.g., embedding 3D previews in the dashboard).

### 8.3 Customization themes compatible with your stack

Customization routes that align well with your tech stack and goals:

- **Memory‑centric OS** — combine Obsidian/Open‑Brain, OpenViking, and Hermes memory providers into a cohesive system.
- **Dev‑centric OS** — lean into GitHub/WSL tooling: project manifests, code maps, automated PR drafting and review.
- **Visualization‑centric OS (MyKu)** — integrate 3D scene viewers and shader tools into the Hermes dashboard or external apps, orchestrated by Hermes skills.
- **Freelancer OS** — layer in Upwork/client workflows, billing summaries, and portfolio generation, driven by Hermes sessions and vault notes.

Across all these routes, the WSL‑authoritative, Windows‑desktop client pattern you have is a strong foundation.

***

## 9. Key Takeaways

- Your existing stack aligns closely with how Hermes v0.16 is designed to be used: WSL or remote Linux as the authoritative backend, with Hermes Desktop as a thin client.[^4][^2][^1]
- Local Windows helper processes and Windows‑rooted file browsing in Desktop are expected behaviors in remote mode, as long as the gateway URL and tool output point to the WSL runtime.[^6][^2][^1]
- OpenViking (Viking) is a first‑class Hermes memory provider that can be combined with an Obsidian/Open‑Brain vault for a powerful hybrid human/agent memory layer.[^7][^8][^9]
- An agentic OS on top of Hermes for your use case should be built in staged layers: workspace and manifests, memory, Kanban/orchestration, automation, and then specialized visualization/Upwork workflows.[^11][^12][^10]
- GitHub and YouTube already host a rich ecosystem of Hermes OS configurations; these should be mined for patterns (Kanban, memory layers, workflows) rather than copied wholesale, then adapted to your 3D and research‑heavy environment.[^24][^20][^10]

---

## References

1. [hermes_perplexity_research.md](https://ppl-ai-file-upload.s3.amazonaws.com/web/direct-files/attachments/55809861/2db2b223-857f-40bc-b830-f72036631052/hermes_perplexity_research.md?AWSAccessKeyId=ASIA2F3EMEYEX4KVQF55&Signature=Sf2K8LCeyNshJsldGnI15PzfLhQ%3D&x-amz-security-token=IQoJb3JpZ2luX2VjEOL%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCXVzLWVhc3QtMSJIMEYCIQDzVm%2FfqVRDew%2B6nGgnKQuYZBhNbHVZ88SBknS%2BC4ogTwIhALW8QhkXIWOp30L7%2B5eJB0CD1BdS2MGVzVg5rXGxkj3RKvwECKr%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEQARoMNjk5NzUzMzA5NzA1Igxr%2BwaFUZMf5c1Z900q0ATT4arq0e64POj5mo6pLUkqqSa%2Bv1waWjK38MZxLPUu8SLYWfmK7FlJdMWCEChS1JxVKpFsVLPm8apqIvkVkSS7jnho2P64HJZuUj2h6ykKlfPHNV0bB1Pq5DHeYhEu7uveZVpsgZIW70lP1E6xWsSVfS1xuuVBacsCCSzmx6PmXU17ls3jSIhxbbNX8iigON175maZH%2BS%2FAbSCl7IDdf7MzoQr30BGVBPl7qRSSuOjAqQeRLDDDZxyVE5h0FvNDUnqrS16Hh0hKW4ZLKVq009aMQ7yuB2rpfctI37iCkZCgQUjzdS%2Fom%2B8%2BaIDIMdRLW3rBcZROEkenilVWmZUvyP9b%2BduxttGgBCjiLcIgFsnOTyHuyN1P6nQ6KYchb52Bv269D%2BXzGX4lxtVsRIHdXf7NEGAQpFZVSg69KdMlfvw0NitFYBNI9F%2FPHTEvqLHOOaZA%2BblHfFt0Kh4Csi86oxM9B08exunSbvhfNWkNTNDNSXrNnSFoNOcAkm%2B%2BYGUkJ6ExPzt0ugM8%2BwpxkMPUiF8l9aZN%2BbWmJ2hDfciBoCjEVF5GDPf%2FfMUdh8%2BgbFfLLAn0mvWJyXojs5aJRblKNud6I2DB08HiZGe2sXvF%2FF1e2ZDoif49YuNzk3oX%2BnpLCMUWPT80Lc3Irk3n6v61JFwMio0KyzYooJ0GttqV29uqofSt4nhLDdvLNRcr0gNUO88tV1JU4YXN6%2F0NBhe5nUWqRrZ%2By%2FZSkmYqbOu3RVICG0QKUHj9rOp36MgQK1%2BIwD48AuNe5HcMK%2FDC86CLAj8MJXK0NEGOpcB%2BIBqB3c8TfEP%2FLiHBSTDPBlnGApxcK6GnuflJTUIMtq0o0o2N7x7BxZWbVAAjuerYM2mrOcOsq4eGxY29dzQFw2FzPhkdiKpXr01LBfgSV4v0fmtXz58L4dPkS%2FvmxSivmezKPJ4xPTgY03E7CBEDMYTT695ABz%2FutSaapXyWJBclvdFCCMGtJtL%2B6x5cgf%2FHi4ApnfAag%3D%3D&Expires=1781805800) - # Hermes AI Stack Technical Spec

Date context: June 18, 2026
Source basis: `L:\WSL\hermes-specs`...

2. [Release Notes — Hermes Agent v0.16.0 (v2026.6.5) - Agent Wikis](https://agentwikis.com/wiki/hermes/wiki/summaries/release-v0.16.0.md) - Tagline: "The Surface Release" — 874 commits · 542 merged PRs · 1,962 files changed · 205,216 insert...

3. [How to Install Hermes Agent (2026 Setup Guide)](https://hermesatlas.com/guide/install/) - Install Hermes Agent v0.10.0 in 2 minutes — macOS, Linux, Windows WSL2 — with the full troubleshooti...

4. [Hermes Agent v0.16 Surface Release: Desktop, Dashboard, Web UI ...](https://hermes-agent.ai/blog/hermes-agent-v0-16-surface-release) - The release adds a native desktop app, a much broader web dashboard/admin panel, remote backend conn...

5. [hermes-agent/website/docs/getting-started/installation.md ...](https://github.com/NousResearch/hermes-agent/blob/main/website/docs/getting-started/installation.md) - The agent that grows with you. Contribute to NousResearch/hermes-agent development by creating an ac...

6. [fathah/hermes-desktop: Desktop Companion for Hermes Agent](https://github.com/fathah/hermes-desktop) - Local or remote backend — run Hermes locally on 127.0.0.1:8642 , or connect the desktop app to a rem...

7. [Hermes Agent - OpenViking](https://docs.openviking.ai/en/agent-integrations/05-hermes) - Open-source context database for AI Agents

8. [Agent Memory Providers Compared — Honcho, Mem0, Hindsight ...](https://www.glukhov.org/ai-systems/memory/agent-memory-providers/) - This guide compares eight backends that ship as Hermes Agent external memory plugins — Honcho, OpenV...

9. [Memory Providers - Hermes Agent](https://hermes.ai.vn/docs/user-guide/features/memory-providers/) - Các plugin cung cấp bộ nhớ ngoài — Honcho, OpenViking, Mem0, Hindsight, Holographic, RetainDB, ByteR...

10. [NEW Hermes Agent OS is INSANE 🤯 (FREE!)](https://www.youtube.com/watch?v=dMEuVbSr7AQ) - Get the Hermes Agent OS 👉 https://www.skool.com/ai-profit-lab-7462/about

Want to make money and sav...

11. [NEW Hermes Agentic Operating System is INSANE! - YouTube](https://www.youtube.com/watch?v=b2cqPUyVjgg) - Get the Hermes Agent OS https://www.skool.com/ai-profit-lab-7462/about Want to make money and save t...

12. [Hermes Agent OS: Build Your Own AI Workforce](https://www.youtube.com/watch?v=-dNFLdFhDQQ) - Get the Hermes Agent OS Masterclass 👉 https://www.skool.com/ai-profit-lab-7462/about

Want to make m...

13. [Hermes Desktop remote backend setup on a VPS - LumaDock](https://lumadock.com/tutorials/hermes-desktop-remote-backend-vps) - Set up Hermes Desktop in remote mode against a VPS-hosted Hermes Agent. SSH tunnel, dashboard auth, ...

14. [Hermes Agent — Open-Source AI Agent with Persistent Memory](https://hermes-agent.org) - Self-hosted AI agent that remembers your projects, builds skills automatically, and reaches you on T...

15. [Hermes Desktop with APIMaster.ai](https://apimaster.ai/docs/en/agents/hermes) - Verify what's actually behind your AI API. Detect model substitution for Claude, GPT, DeepSeek — no ...

16. [Self-Hosted Dashboard (Desktop App) for Hermes Agent](https://www.scriptbyai.com/hermes-web-ui-desktop/) - Use Hermes Web UI to manage Hermes Agent chats, providers, jobs, files, profiles, analytics, and pla...

17. [Hermes Agent - Full Course & Setup Guide - YouTube](https://www.youtube.com/watch?v=mTYxpIRK7xA) - Deploy Hermes Agent with Hostinger here: https://www.hostg.xyz/SHJWj Use code "techwithtim" for 10% ...

18. [hermes-agent/website/docs/integrations/providers.md at main - GitHub](https://github.com/NousResearch/hermes-agent/blob/main/website/docs/integrations/providers.md) - This page covers setting up inference providers for Hermes Agent — from cloud APIs like OpenRouter a...

19. [env_loader.load_hermes_dotenv resolves ~/.hermes/.env via ...](https://github.com/NousResearch/hermes-agent/issues/31144) - What's happening On a Windows install where the Hermes installer set HERMES_HOME at User scope to C:...

20. [NousResearch/hermes-agent: The agent that grows with you - GitHub](https://github.com/nousresearch/hermes-agent) - The self-improving AI agent built by Nous Research. Native Windows runs Hermes without WSL — CLI, ga...

21. [Hermes + Honcho Self Improving Autonomous AI Agent! - LinkedIn](https://www.linkedin.com/posts/juliangoldieseo_hermes-honcho-self-improving-autonomous-activity-7446589751039635456-Igtj) - Hermes + Honcho Self Improving Autonomous AI Agent!

22. [Hermes Agent | OpenViking](https://docs.openviking.ai/zh/agent-integrations/05-hermes) - 面向 AI Agent 的开源上下文数据库

23. [Changelog](https://github.com/RedWoodOG/Hermes-Desktop/blob/main/readme.md) - Hermes_Desktop. Contribute to RedWoodOG/Hermes-Desktop development by creating an account on GitHub.

24. [Hermes Agent Just Stopped Being a CLI Tool (v0.16)](https://www.youtube.com/watch?v=KC1bnvu2e74) - Hermes Agent v0.16 just shipped a native desktop app, a remote gateway architecture, and a full admi...

