#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
RALPH_SCRIPT="${SCRIPT_DIR}/ralph-wiggum-bdd.sh"

MAX_ITERATIONS=5

usage() {
    echo "Usage: $0 [--example <path>]"
    echo ""
    echo "Options:"
    echo "  --example <path>    Run only the specified example (e.g., examples/python/example1)"
    echo ""
    echo "If no --example is specified, all examples are run."
    exit 1
}

find_all_examples() {
    find "${REPO_ROOT}/examples" -name "REQUIREMENTS.md" -exec dirname {} \; 2>/dev/null | sort
}

run_example() {
    local example_path="$1"

    echo ""
    echo "========================================"
    echo "Running example: ${example_path}"
    echo "========================================"

    local tmpdir
    tmpdir=$(mktemp -d "/tmp/ralph-wiggum-bdd.XXXXXX")
    trap "rm -rf '${tmpdir}'" EXIT

    cp -r "${example_path}/." "${tmpdir}/"
    cd "${tmpdir}"

    git init --quiet

    echo "Temp directory: ${tmpdir}"
    echo "Contents:"
    ls -la

    "${RALPH_SCRIPT}" --iterations "${MAX_ITERATIONS}"
    local exit_code=$?

    if [[ ${exit_code} -ne 0 ]]; then
        echo "FAIL: ralph-wiggum-bdd.sh exited with code ${exit_code}"
        return 1
    fi

    if [[ ! -d "features" ]]; then
        echo "FAIL: features/ directory not created"
        return 1
    fi

    local incomplete
    incomplete=$(grep -l -E '@status-todo|@status-active' features/*.feature 2>/dev/null || true)
    if [[ -n "${incomplete}" ]]; then
        echo "FAIL: Some features are not @status-done:"
        echo "${incomplete}"
        return 1
    fi

    echo "PASS: All features are @status-done"
    return 0
}

EXAMPLE_PATH=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        --example)
            if [[ $# -lt 2 ]]; then
                echo "Error: --example requires a path argument"
                usage
            fi
            EXAMPLE_PATH="$2"
            shift 2
            ;;
        --help|-h)
            usage
            ;;
        *)
            echo "Error: Unknown option: $1"
            usage
            ;;
    esac
done

if [[ -n "${EXAMPLE_PATH}" ]]; then
    full_path="${REPO_ROOT}/${EXAMPLE_PATH}"
    if [[ ! -d "${full_path}" ]]; then
        echo "Error: Example not found: ${full_path}"
        exit 1
    fi
    if [[ ! -f "${full_path}/REQUIREMENTS.md" ]]; then
        echo "Error: REQUIREMENTS.md not found in ${full_path}"
        exit 1
    fi
    run_example "${full_path}"
else
    examples=$(find_all_examples)
    if [[ -z "${examples}" ]]; then
        echo "Error: No examples found"
        exit 1
    fi

    failed=0
    for example in ${examples}; do
        if ! run_example "${example}"; then
            failed=$((failed + 1))
        fi
    done

    echo ""
    echo "========================================"
    if [[ ${failed} -eq 0 ]]; then
        echo "All examples passed"
        exit 0
    else
        echo "Failed examples: ${failed}"
        exit 1
    fi
fi
