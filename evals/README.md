# Evals

Eval-driven tests for the `html` skill, following
<https://agentskills.io/skill-creation/evaluating-skills>.

- `evals.json` — test cases (prompt, expected output, assertions).
- `files/` — input files referenced by test cases.

## Running

Each case runs twice in a clean-context subagent — **with** the skill (the agent
is told to read `SKILL.md` first) and **without** it (baseline). Results go in a
sibling workspace (`../html-workspace/iteration-N/`), not committed: per-run
`outputs/`, `grading.json`, `timing.json`, and an aggregate `benchmark.json`.

## Iteration 1 (3 cases × with/without)

| Config | Pass rate | Time | Tokens |
| :----- | :-------- | :--- | :----- |
| with skill | 1.00 | 80.7s | 27.5k |
| without skill | 0.92 | 91.1s | 29.2k |
| **delta** | **+0.08** | **−10.4s** | **−1.7k** |

**Key finding:** baseline agents discovered ht-ml.app unaided (via its `llms.txt`
and `/v1/help`, which self-document the whole API including the password cookie),
so they matched the skill on most assertions. The skill's measurable edge: it
**guarantees** use of the 20 curated templates (the only differentiating
assertion — eval 3), while being faster and cheaper.

Most assertions pass in *both* configs, so they under-measure the skill's true
value. Next iterations should add discriminating checks for: template/design
quality (blind A/B), discovery reliability on weaker models and vaguer prompts,
and triggering (untestable when the run is told to read `SKILL.md`).

**Applied from iteration 1:** made the `description` pushier and template-aware to
combat undertriggering — the one dimension these evals can't measure but that
most affects real-world value.
