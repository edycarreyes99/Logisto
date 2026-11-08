#!/usr/bin/env python3
"""
Modular Architecture Status Dashboard & Decomposition Migration Audit Tool.

Zero external dependencies: runs with standard Python 3.8+.
Provides two operational modes:
1. Standalone Modular Mode (Default): Audits the active inventory and health of
   modular assets in .agents/ (skills/, agents/, rules/) with zero monolithic ties.
2. Blueprint Decomposition Mode: Tracks the progressive decomposition of a legacy
   monolithic architectural blueprint (e.g., AGENTS.md) into discrete .agents/ assets
   using a configurable decomposition matrix.
"""

import sys
import os
import pathlib
import argparse
from typing import Dict, List, Tuple, Optional


def find_agents_root(explicit_root: Optional[str] = None) -> pathlib.Path:
    """Dynamically discover the .agents root directory without hardcoded absolute paths."""
    if explicit_root:
        return pathlib.Path(explicit_root).resolve()

    cwd = pathlib.Path.cwd().resolve()
    if cwd.name == ".agents" and (cwd / "skills").exists():
        return cwd
    if (cwd / ".agents").exists():
        return (cwd / ".agents").resolve()

    script_dir = pathlib.Path(__file__).resolve().parent
    for parent in [script_dir] + list(script_dir.parents):
        if parent.name == ".agents" and (parent / "skills").exists():
            return parent
        if (parent / ".agents").exists():
            return (parent / ".agents").resolve()

    for parent in list(cwd.parents):
        if (parent / ".agents").exists():
            return (parent / ".agents").resolve()

    return (cwd / ".agents").resolve()


def find_source_blueprint(workspace_root: pathlib.Path, explicit_blueprint: Optional[str] = None) -> Tuple[Optional[pathlib.Path], Optional[str]]:
    """Discover a source monolithic blueprint file if one exists or was specified."""
    if explicit_blueprint:
        candidate = pathlib.Path(explicit_blueprint).resolve()
        if candidate.exists():
            return candidate, None
        ws_candidate = (workspace_root / explicit_blueprint).resolve()
        if ws_candidate.exists():
            return ws_candidate, None
        cwd_candidate = (pathlib.Path.cwd() / explicit_blueprint).resolve()
        if cwd_candidate.exists():
            return cwd_candidate, None
        return None, f"Specified source blueprint not found: '{explicit_blueprint}'"

    # Check standard root-level candidate locations only (do not auto-bind to subproject folders)
    candidates = [
        workspace_root / "AGENTS.md",
        pathlib.Path.cwd() / "AGENTS.md",
    ]
    for c in candidates:
        if c.exists() and c.is_file():
            return c, None

    return None, None


def find_decomposition_matrix(workspace_root: pathlib.Path, agents_root: pathlib.Path, explicit_matrix: Optional[str] = None) -> Tuple[Optional[pathlib.Path], Optional[str]]:
    """Discover a decomposition matrix file if one exists or was specified."""
    if explicit_matrix:
        candidate = pathlib.Path(explicit_matrix).resolve()
        if candidate.exists():
            return candidate, None
        ws_candidate = (workspace_root / explicit_matrix).resolve()
        if ws_candidate.exists():
            return ws_candidate, None
        agents_candidate = (agents_root / explicit_matrix).resolve()
        if agents_candidate.exists():
            return agents_candidate, None
        return None, f"Specified decomposition matrix not found: '{explicit_matrix}'"

    # Search in .agents/skills/*/references/*decomposition-matrix*.md
    matches = sorted(agents_root.rglob("*decomposition-matrix*.md"))
    if matches:
        return matches[0], None

    # Search workspace root
    ws_matches = sorted(workspace_root.glob("*decomposition-matrix*.md"))
    if ws_matches:
        return ws_matches[0], None

    return None, None


def parse_decomposition_matrix(matrix_path: pathlib.Path) -> Tuple[List[Tuple[str, str, str]], List[Tuple[str, str, str]], List[Tuple[str, str, str]]]:
    """
    Parse a Markdown decomposition matrix table into structured target inventories.
    Expected Markdown columns:
    | Section | Topic | Target Type | Target Path | Target Identifier | Key Invariant / Capability |
    """
    rules: List[Tuple[str, str, str]] = []
    skills: List[Tuple[str, str, str]] = []
    agents: List[Tuple[str, str, str]] = []

    content = matrix_path.read_text(encoding='utf-8')
    for line in content.split('\n'):
        line = line.strip()
        if not line.startswith('|') or not line.endswith('|'):
            continue
        cols = [c.strip() for c in line.split('|')[1:-1]]
        if len(cols) < 5:
            continue
        # Skip header and divider rows
        if cols[0].startswith('---') or cols[0].startswith(':') or cols[0] == 'Blueprint Section Reference':
            continue

        target_type = cols[2].strip().lower()
        target_path = cols[3].strip(' `')
        target_id = cols[4].strip(' `')
        topic = cols[1].strip()

        if target_type == 'rule':
            rules.append((target_id, target_path, topic))
        elif target_type == 'skill':
            skills.append((target_id, target_path, topic))
        elif target_type == 'agent':
            agents.append((target_id, target_path, topic))

    return rules, skills, agents


def get_active_assets(agents_root: pathlib.Path) -> Tuple[List[str], List[str], List[str]]:
    """Scan .agents/ directory and return active rules, skills, and agents."""
    skills: List[str] = []
    rules: List[str] = []
    agents: List[str] = []

    skills_dir = agents_root / "skills"
    if skills_dir.exists():
        for item in sorted(skills_dir.iterdir()):
            if item.is_dir() and not item.name.startswith('.'):
                if (item / "SKILL.md").exists():
                    skills.append(item.name)

    rules_dir = agents_root / "rules"
    if rules_dir.exists():
        for item in sorted(rules_dir.glob("*.md")):
            if item.is_file() and item.stat().st_size > 0:
                rules.append(item.name)

    agents_dir = agents_root / "agents"
    if agents_dir.exists():
        for item in sorted(agents_dir.glob("*.md")):
            if item.is_file() and item.stat().st_size > 0:
                agents.append(item.name)

    return rules, skills, agents


def main() -> int:
    parser = argparse.ArgumentParser(description="Audit .agents modular status or blueprint decomposition migration progress.")
    parser.add_argument("--root", default=None,
                        help="Path to .agents directory (dynamically discovered if omitted).")
    parser.add_argument("--source-blueprint", "--blueprint", default=None, dest="blueprint",
                        help="Path to source monolithic blueprint file to track decomposition for (e.g. AGENTS.md).")
    parser.add_argument("--matrix", default=None,
                        help="Path to decomposition matrix markdown file (dynamically discovered if omitted).")
    args = parser.parse_args()

    agents_root = find_agents_root(args.root)
    if not agents_root.exists():
        print(f"ERROR: .agents directory not found at: {agents_root}")
        return 1

    workspace_root = agents_root.parent
    blueprint_path, bp_err = find_source_blueprint(workspace_root, args.blueprint)
    if bp_err:
        print(f"ERROR: {bp_err}")
        return 1

    matrix_path, matrix_err = find_decomposition_matrix(workspace_root, agents_root, args.matrix)
    if matrix_err:
        print(f"ERROR: {matrix_err}")
        return 1

    active_rules, active_skills, active_agents = get_active_assets(agents_root)

    # Determine execution mode: Standalone Modular Mode vs Blueprint Decomposition Mode
    if not blueprint_path and not args.matrix:
        # MODE 1: Standalone Modular Architecture Mode
        print("================================================================================")
        print("         Modular Architecture Status Dashboard (.agents Subsystem)")
        print(f"         Agents Root: {agents_root}")
        print("         Mode:        Standalone Modular Architecture (Zero Monolithic Locks)")
        print("================================================================================\n")

        print("[INFO] Operating in standalone modular mode.")
        print("       No monolithic blueprint (e.g. AGENTS.md) is bound or pending decomposition.")
        print("       All assets in .agents/ operate autonomously and universally across any project.\n")

        print("--- 1. ACTIVE ARCHITECTURAL RULES (.agents/rules/) ----------------------------")
        if active_rules:
            for r in active_rules:
                print(f"  [ACTIVE]  {r}")
        else:
            print("  (No active rules currently defined. Scaffold via: scripts/scaffold_asset.py --type rule)")

        print("\n--- 2. ACTIVE PROCEDURAL SKILLS (.agents/skills/) ------------------------------")
        if active_skills:
            for s in active_skills:
                print(f"  [ACTIVE]  {s:<32} (skills/{s}/SKILL.md)")
        else:
            print("  (No active skills currently defined. Scaffold via: scripts/scaffold_asset.py --type skill)")

        print("\n--- 3. ACTIVE SPECIALIZED SUBAGENTS (.agents/agents/) --------------------------")
        if active_agents:
            for a in active_agents:
                print(f"  [ACTIVE]  {a:<32} (agents/{a})")
        else:
            print("  (No active agents currently defined. Scaffold via: scripts/scaffold_asset.py --type agent)")

        total_assets = len(active_rules) + len(active_skills) + len(active_agents)
        print("\n================================================================================")
        print(f"   SYSTEM STATUS: {total_assets} modular asset(s) active across .agents/.")
        print("   Enterprise standards compliant. Modular architecture ready for execution.")
        print("================================================================================")
        return 0

    # MODE 2: Blueprint Decomposition Migration Mode
    rel_bp = os.path.relpath(blueprint_path, start=workspace_root) if blueprint_path else "Unspecified"
    rel_matrix = os.path.relpath(matrix_path, start=workspace_root) if matrix_path else "None detected"

    print("================================================================================")
    print("      Modular Architecture Decomposition Migration Status Dashboard")
    print(f"      Agents Subsystem:     {agents_root}")
    print(f"      Source Blueprint:     {rel_bp}")
    print(f"      Decomposition Matrix: {rel_matrix}")
    print("================================================================================\n")

    if not matrix_path:
        print("[INFO] Monolithic blueprint detected, but no decomposition matrix provided.")
        print("       To track structured module decomposition against a formal matrix,")
        print("       provide --matrix <path> or add a decomposition matrix markdown table.\n")
        print(f"Active Modular Assets: {len(active_rules)} rules, {len(active_skills)} skills, {len(active_agents)} agents.")
        return 0

    target_rules, target_skills, target_agents = parse_decomposition_matrix(matrix_path)
    total_items = len(target_rules) + len(target_skills) + len(target_agents)

    if total_items == 0:
        print(f"[WARN] No structured decomposition targets found in matrix: {matrix_path}")
        return 0

    completed_items = 0
    next_target = None

    # 1. Rules
    print("--- 1. ARCHITECTURAL RULES (.agents/rules/) -----------------------------------")
    rules_dir = agents_root / "rules"
    for rule_id, target_path, desc in target_rules:
        # Check both direct path and inside rules/ directory
        path = agents_root / target_path if not target_path.startswith("rules/") else agents_root / target_path
        alt_path = rules_dir / pathlib.Path(target_path).name
        target_file = path if path.exists() else alt_path

        if target_file.exists() and target_file.stat().st_size > 0:
            completed_items += 1
            print(f"  [DONE]    {rule_id:<14} {pathlib.Path(target_path).name:<40} {desc}")
        else:
            print(f"  [PENDING] {rule_id:<14} {pathlib.Path(target_path).name:<40} {desc}")
            if next_target is None:
                next_target = f"Rule: {rule_id} ({pathlib.Path(target_path).name})"

    # 2. Skills
    print("\n--- 2. ACTIONABLE SKILLS (.agents/skills/) -------------------------------------")
    for skill_name, target_path, desc in target_skills:
        path = agents_root / target_path
        if path.exists() and path.stat().st_size > 0:
            completed_items += 1
            print(f"  [DONE]    {skill_name:<30} {target_path:<40} {desc}")
        else:
            print(f"  [PENDING] {skill_name:<30} {target_path:<40} {desc}")
            if next_target is None:
                next_target = f"Skill: {skill_name} ({target_path})"

    # 3. Agents
    print("\n--- 3. SPECIALIZED SUBAGENTS (.agents/agents/) ---------------------------------")
    for agent_name, target_path, desc in target_agents:
        path = agents_root / target_path
        if path.exists() and path.stat().st_size > 0:
            completed_items += 1
            print(f"  [DONE]    {agent_name:<30} {target_path:<40} {desc}")
        else:
            print(f"  [PENDING] {agent_name:<30} {target_path:<40} {desc}")
            if next_target is None:
                next_target = f"Agent: {agent_name} ({target_path})"

    pct = (completed_items / total_items) * 100.0 if total_items > 0 else 100.0
    print("\n================================================================================")
    print(f"   MIGRATION PROGRESS: {completed_items}/{total_items} modules ({pct:.1f}%)")
    if next_target:
        print(f"   NEXT RECOMMENDED TARGET: {next_target}")
    else:
        print("   ALL TARGET MODULES HAVE BEEN SUCCESSFULLY DECOMPOSED!")
        if blueprint_path:
            print(f"   The monolithic blueprint at '{rel_bp}' can now be safely retired")
            print("   as all architectural rules, skills, and agents are modularized in .agents/.")
    print("================================================================================")

    return 0


if __name__ == "__main__":
    sys.exit(main())
