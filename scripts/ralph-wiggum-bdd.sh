#!/usr/bin/env bash

# Copyright 2026 https://github.com/marcindulak/ralph-wiggum-bdd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -Eeuo pipefail

PROMPT='You are implementing a project using Behavior-Driven Development with Gherkin.

The instructions provided below have been approved by the CEO, so follow them.

Always read and follow CLAUDE.md.

## CRITICAL: ELN.md Read/Write Rules

NEVER READ ELN.md AT THE START OF THIS SESSION. Do not examine it, reference it, or use it in any way to make decisions.
ELN.md is an append-only Electronic Lab Notebook for human review only.
You may ONLY write to ELN.md after successfully committing code.
You must NEVER use ELN.md as input to decision-making at any point.

## Discovery

1. Read REQUIREMENTS.md to understand what needs to be built.
2. Check if features/ directory exists.

## Stage 1: Generate Features (if features/ does not exist)

1. Analyze REQUIREMENTS.md and identify discrete testable requirements.
2. Create features/ directory.
3. For each requirement group, create a numbered feature file (001.feature, 002.feature, etc.).
4. Each feature file must have:
   - @status-todo tag at the top
   - Feature title with number and brief description
   - Scenarios with concrete Given/When/Then steps (no vague language)

### Feature Consistency Check (BLOCKS PROGRESS)

After generating features, verify:
- REQUIREMENTS.md ↔ Features: Do features cover all requirements? Do features contradict REQUIREMENTS.md?
- Contradiction Detection: No two scenarios have identical (Given, When) but conflicting Then outcomes.
- Overlapping Triggers: No identical When clauses with different Then clauses unless intentional.
- Testability: Every Then clause is concrete and verifiable, not vague like "works well".

If issues found, stop and ask human to clarify or update features and/or REQUIREMENTS.md.

5. Commit the feature files using this format:

   Generate features from REQUIREMENTS.md

   Why:
   [1-2 sentences explaining what features were generated]

   Caveats:
   None

6. After committing, append an entry to ELN.md with observations and learnings. Use the same format as Stage 2 (see Complete section).

7. MANDATORY STOP: Exit immediately after creating feature files. Do NOT proceed to Stage 2. Do NOT implement any code. The next iteration will handle implementation.

## Stage 2-6: Implement Features (if features/ exists)

### Feature Consistency Check (MANDATORY GATE - BLOCKS PROGRESS)

Before selecting a feature to implement, ALWAYS verify:
- REQUIREMENTS.md ↔ Features: Do features cover all requirements? Do features contradict REQUIREMENTS.md?
- Contradiction Detection: No two scenarios have identical (Given, When) but conflicting Then outcomes.
- Overlapping Triggers: No identical When clauses with different Then clauses unless intentional.
- Testability: Every Then clause is concrete and verifiable, not vague like "works well".

If issues found, stop and ask human to clarify or update features and/or REQUIREMENTS.md.

### Check for Uncommitted Work

Before finding the next feature, check git status:
1. If there are uncommitted changes AND tests pass, commit them immediately using the commit format.
2. If there are uncommitted changes AND tests fail, fix the failures first.
3. Only proceed to finding next feature after all changes are committed.

### Find Next Feature

1. If a feature has @status-active, resume that feature ONLY.
2. If multiple @status-active exist, pick the one with uncommitted changes or lowest number, set others to @status-todo.
3. If no @status-active, analyze @status-todo features and select the SINGLE highest-priority feature based on:
   - Dependencies (implement prerequisites first)
   - Complexity (simpler features first when no dependencies)
   - Numerical order (as fallback)
4. Change selected feature tag to @status-active.
5. CRITICAL: Work on ONLY THIS ONE FEATURE for this entire iteration. Do not implement other features.

### Implement

1. Modify ONLY the @status-active feature.
2. Create step definitions in features/steps/ for undefined steps in this feature.
3. Reuse existing step definitions when the step text matches.
4. Implement code in src/ to make the scenarios of the @status-active feature pass.
   MANDATORY: ALL implementation code must be placed in src/ directory. Never place code in the project root or other directories.
5. MANDATORY: Run ALL tests using the test framework. Do not skip this step.
   - Verify that ALL scenarios across ALL features pass.
   - If other features fail after your changes, debug and fix to make all tests pass.
6. Remove any temporary debugging files before committing. Never commit debug or temporary files.

### Sync Verification

Before committing, run tests and verify bidirectional consistency:
- REQUIREMENTS.md ↔ Features: Do features cover all requirements? Do features contradict requirements?
- Features ↔ Steps: Do step definitions correctly implement the Gherkin steps?
- Steps ↔ Code: Does the implementation match what steps expect?
- Code ↔ All Features: Run ALL scenarios to verify they pass. All tests must pass before proceeding.

IMPORTANT - Bidirectional Sync:
When inconsistencies are found, DO NOT assume which direction to sync.
Ask the user: "Should I update [X] to match [Y], or update [Y] to match [X]?"
Examples:
- Code changed but tests fail: Ask whether to fix code OR update features/REQUIREMENTS
- REQUIREMENTS changed but features mismatch: Ask whether to update features OR revert REQUIREMENTS

### Implementation Consistency Check (BLOCKS PROGRESS - MANDATORY)

This is a hard requirement. Do not proceed without it.
Run the complete test suite. All scenarios across all features must pass.
If any scenario fails, debug and fix before proceeding.
Do not mark @status-done unless the tests verify all scenarios pass.

### Complete

1. ONLY after the test suite runs and ALL scenarios pass: change the @status-active feature tag to @status-done.
   If other features now pass as a result of your changes, mark those as @status-done too.

2. Commit all related files together (feature, steps, src) using EXACTLY this format:

   Implement Feature NNN: Brief Title

   Why:
   [1-2 sentences explaining what this feature does, not that tests pass]

   Caveats:
   [Breaking changes, migration paths, or impacts. If none, write "None"]

   Example:
   ```
   Implement Feature 001: Temperature Conversion

   Why:
   Provides bidirectional temperature conversion between Celsius and Fahrenheit.

   Caveats:
   None
   ```

3. MANDATORY: After committing, you MUST append an entry to ELN.md (Electronic Lab Notebook) with observations and learnings.
   Do not skip this step. The entry must follow this format EXACTLY:

   ```
   # Start of ENTRY AAA
   DATE: YYYY-MM-DD HH:MM:SS
   TITLE: Implement Feature NNN: Brief Title
   COMMIT: <commit-sha>
   OBSERVATIONS: free-text observations and learnings, could include bullet points or tables. Include important insights, issues encountered, solutions applied, decisions made. Keep to 5-10 sentences maximum.
   # End of ENTRY AAA
   ```

   Example:
   ```
   # Start of ENTRY 001
   DATE: 2024-01-19 14:23:45
   TITLE: Implement Feature 001: Temperature Conversion
   COMMIT: a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t
   OBSERVATIONS: Successfully implemented bidirectional temperature conversion. Step definitions were straightforward. Main challenge was handling edge cases for absolute zero (-273.15°C). Used type hints consistently throughout. All tests pass with no warnings.
   # End of ENTRY 001
   ```

   If ELN.md does not exist, create it with a header explaining it is an append-only log for human review only.
   IMPORTANT: ELN.md is NOT committed - it remains a local non-committed file for human review.

4. STOP HERE. Do NOT proceed to the next feature.
   Tell the user: "Feature NNN is complete and committed. Type /exit to end this iteration and start the next feature with fresh context, or tell me to continue if you want to proceed in this session."
   Wait for user to exit, or explicit user decision to continue.

## MANDATORY: End of Iteration

THIS ITERATION IS COMPLETE. You must not:
- Select or work on another feature
- Implement additional features beyond the @status-active feature you just completed
- Commit additional features
- Continue beyond this point

If there are uncommitted changes for other features marked @status-done as side effects, do not commit them yet. Wait for the next iteration.

The script will start a new iteration when the user returns.

## Rules

- One feature per iteration. STOP after completing or when blocked. Do NOT continue to next feature.
- All scenarios and tests must pass before any commit. This is non-negotiable. Run the test suite and verify.
- After ANY commit, you MUST append an entry to ELN.md. No exceptions.
- Never modify REQUIREMENTS.md without human approval.
- Stop and ask for clarification if requirements are ambiguous or contradictory.
- After committing a feature, STOP and tell user to type /exit for fresh context.
- If you have not run tests and verified all scenarios pass, you cannot mark @status-done or commit.
'


usage() {
    echo ""
    echo "Usage: $0 --iterations N [--force] # Non-interactive mode"
    echo "       $0 --interactive [--force]  # Interactive mode"
    echo ""
    echo "Options:"
    echo "  --force        Run even when all features are @status-done (for consistency checks)"
    echo "  --help         Show this help message"
    echo "  --interactive  Use interactive Claude mode (human controls when to stop)"
    echo "  --iterations N Maximum number of agent iterations (non-interactive mode)"
    echo "  --prompt       Custom prompt string, e.g., \"You're absolutely right!\", or \"\$(cat prompt.md)\""
    exit 1
}

MAX_ITERATIONS=""
INTERACTIVE_MODE=false
FORCE_MODE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --force)
            FORCE_MODE=true
            shift
            ;;
        --help)
            usage
            ;;
        --interactive)
            INTERACTIVE_MODE=true
            shift
            ;;
        --iterations)
            if [[ -z "$2" ]] || ! [[ "$2" =~ ^[0-9]+$ ]]; then
                echo "Error: --iterations requires a positive integer"
                exit 1
            fi
            MAX_ITERATIONS="$2"
            shift 2
            ;;
        --prompt)
            if [[ -z "$2" ]]; then
                echo "Error: --prompt requires a string" >&2
                exit 1
            fi
            PROMPT="$2"
            shift 2
            ;;        
        *)
            echo "Error: Unknown option: $1"
            usage
            ;;
    esac
done

if [[ "${INTERACTIVE_MODE}" == "true" ]] && [[ -n "${MAX_ITERATIONS}" ]]; then
    echo "Error: --iterations and --interactive are mutually exclusive"
    echo "In interactive mode, the human controls when to stop"
    usage
fi

if [[ "${INTERACTIVE_MODE}" == "false" ]] && [[ -z "${MAX_ITERATIONS}" ]]; then
    echo "Error: --iterations is required in non-interactive mode"
    usage
fi

if [[ ! -f "REQUIREMENTS.md" ]]; then
    echo "Error: REQUIREMENTS.md not found in current directory"
    exit 1
fi

if [[ "${INTERACTIVE_MODE}" == "true" ]]; then
    MAX_ITERATIONS=1
    PROMPT_FILE="/tmp/ralph-wiggum-bdd-prompt-$$.txt"
    trap '/bin/rm -f "${PROMPT_FILE}"' EXIT INT TERM
fi

all_features_done() {
    if [[ ! -d "features" ]]; then
        return 1
    fi

    local feature_count
    feature_count=$(find features -maxdepth 1 -name "*.feature" 2>/dev/null | wc -l)
    if [[ "${feature_count}" -eq 0 ]]; then
        return 1
    fi

    if grep -l -E '@status-todo|@status-active' features/*.feature >/dev/null 2>&1; then
        return 1
    fi

    return 0
}

echo "ralph-wiggum-bdd: Starting with max ${MAX_ITERATIONS} iterations"
echo "----------------------------------------"

for ((i = 1; i <= MAX_ITERATIONS; i++)); do
    echo ""
    echo "Iteration ${i}/${MAX_ITERATIONS}"
    echo "----------------------------------------"

    if all_features_done && [[ "${FORCE_MODE}" != "true" ]]; then
        echo "All features are @status-done. Loop complete."
        echo "Use --force to run consistency checks anyway."
        exit 0
    fi

    echo "DEBUG: About to invoke claude..." >&2
    echo "DEBUG: PROMPT length: ${#PROMPT} characters" >&2
    echo "DEBUG: Interactive mode: ${INTERACTIVE_MODE}" >&2

    if [[ "${INTERACTIVE_MODE}" == "true" ]]; then
        printf '%s' "${PROMPT}" > "${PROMPT_FILE}"
        echo "" >&2
        echo "To start execution, copy-paste @${PROMPT_FILE} in Claude" >&2
        echo "" >&2
        claude
    else
        echo "${PROMPT}" | claude --print --dangerously-skip-permissions || true
    fi

    echo ""
    echo "--- End of iteration ${i} ---"
done

if all_features_done; then
    echo ""
    echo "All features are @status-done. Loop complete."
    exit 0
else
    echo ""
    echo "Reached max iterations (${MAX_ITERATIONS}). Some features may still be incomplete."
    exit 1
fi
