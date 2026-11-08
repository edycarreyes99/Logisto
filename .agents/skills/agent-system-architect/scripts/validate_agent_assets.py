#!/usr/bin/env python3
"""
Automated Validation Gate for .agents Subsystem.
Validates Skills, Subagents, and Rules against enterprise standards:
- Zero emojis across all files.
- YAML frontmatter presence, syntax, and schema conformance.
- Mandatory markdown section presence and structure.
- Naming conventions (kebab-case, uppercase rule IDs).
- Dead link detection (file:// and local relative links).

Zero external dependencies: runs with standard Python 3.8+.
"""

import sys
import re
import os
import json
import pathlib
import argparse
from typing import Dict, Any, List, Tuple, Optional

# Emoji Unicode regex covering all standard emoji blocks
EMOJI_PATTERN = re.compile(
    r'[\U0001F600-\U0001F64F]'  # Emoticons
    r'|[\U0001F300-\U0001F5FF]'  # Misc Symbols and Pictographs
    r'|[\U0001F680-\U0001F6FF]'  # Transport and Map
    r'|[\U0001F1E6-\U0001F1FF]'  # Regional Indicator Symbols / Flags
    r'|[\U00002700-\U000027BF]'  # Dingbats
    r'|[\U0001F900-\U0001F9FF]'  # Supplemental Symbols and Pictographs
    r'|[\U0001FA70-\U0001FAFF]'  # Symbols and Pictographs Extended-A
    r'|[\U00002600-\U000026FF]'  # Miscellaneous Symbols
    r'|[\U0001F200-\U0001F251]',  # Enclosed Ideographic Supplement
    flags=re.UNICODE
)

KEBAB_CASE_PATTERN = re.compile(r'^[a-z0-9]+(-[a-z0-9]+)*$')
RULE_ID_PATTERN = re.compile(r'^RULE-[A-Z0-9]+-[0-9]{3}$')

SKILL_REQUIRED_SECTIONS = [
    r'Executive Summary',
    r'Trigger Conditions',
    r'Pre-Flight',
    r'(Canonical|Standards|Contracts)',
    r'Step-by-Step',
    r'Edge Cases',
    r'Verification'
]

AGENT_REQUIRED_SECTIONS = [
    r'Role Definition',
    r'Invariants',
    r'Communication Protocol',
    r'Execution Workflow'
]

RULE_REQUIRED_SECTIONS = [
    r'Architectural Invariant',
    r'Rationale',
    r'(Compliant|DO)',
    r'(Prohibited|DON\'T)',
    r'(Automated Validation|Audit)'
]

ALLOWED_SKILL_CATEGORIES = {
    "architecture", "data", "presentation", "localization", "theme", "devops", "meta", "testing"
}

ALLOWED_AGENT_MODES = {
    "subagent", "worker", "reviewer", "orchestrator"
}

ALLOWED_RULE_CATEGORIES = {
    "architecture", "presentation", "data", "domain", "theme", "l10n", "lint", "quality", "testing"
}

ALLOWED_RULE_SEVERITIES = {
    "blocking", "critical", "warning"
}


def parse_simple_yaml(yaml_str: str) -> Dict[str, Any]:
    """Lightweight zero-dependency YAML frontmatter parser."""
    data: Dict[str, Any] = {}
    lines = yaml_str.split('\n')
    current_key: Optional[str] = None
    multiline_key: Optional[str] = None
    multiline_lines: List[str] = []
    nested_map_key: Optional[str] = None

    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        # Handle multiline string reading
        if multiline_key is not None:
            if stripped == '' or line.startswith('  ') or line.startswith('\t'):
                multiline_lines.append(stripped)
                i += 1
                continue
            else:
                data[multiline_key] = '\n'.join(multiline_lines).strip()
                multiline_key = None
                multiline_lines = []

        if not stripped or stripped.startswith('#'):
            i += 1
            continue

        # Top-level key: value
        top_match = re.match(r'^([a-zA-Z0-9_-]+):\s*(.*)$', line)
        if top_match and not line.startswith(' '):
            nested_map_key = None
            key = top_match.group(1)
            val = top_match.group(2).strip()

            if val in ('|', '>'):
                multiline_key = key
                multiline_lines = []
            elif val == '':
                # Could be a map or a list
                current_key = key
                # Check next line indentation
                if i + 1 < len(lines):
                    next_line = lines[i + 1]
                    next_stripped = next_line.strip()
                    if next_stripped.startswith('-'):
                        data[key] = []
                    else:
                        data[key] = {}
                        nested_map_key = key
            else:
                # Scalar value
                data[key] = clean_scalar(val)
                current_key = key
            i += 1
            continue

        # Nested map property (indent 2 spaces)
        nested_match = re.match(r'^\s{2,4}([a-zA-Z0-9_-]+):\s*(.*)$', line)
        if nested_match and nested_map_key:
            sub_key = nested_match.group(1)
            sub_val = nested_match.group(2).strip()
            if sub_val == '':
                # Sub-nested map or list
                if i + 1 < len(lines) and lines[i + 1].strip().startswith('-'):
                    data[nested_map_key][sub_key] = []
                else:
                    data[nested_map_key][sub_key] = {}
            else:
                data[nested_map_key][sub_key] = clean_scalar(sub_val)
            i += 1
            continue

        # List item
        list_match = re.match(r'^\s*-\s+(.*)$', line)
        if list_match and current_key:
            item_val = clean_scalar(list_match.group(1).strip())
            target = data.get(current_key)
            if nested_map_key and isinstance(data.get(nested_map_key), dict):
                # Check if there is a subkey with list
                sub_dict = data[nested_map_key]
                last_sub_key = list(sub_dict.keys())[-1] if sub_dict else None
                if last_sub_key and isinstance(sub_dict[last_sub_key], list):
                    sub_dict[last_sub_key].append(item_val)
            elif isinstance(target, list):
                target.append(item_val)
            i += 1
            continue

        i += 1

    if multiline_key is not None:
        data[multiline_key] = '\n'.join(multiline_lines).strip()

    return data


def clean_scalar(val: str) -> Any:
    """Strip quotes and coerce simple types."""
    if val.startswith('"') and val.endswith('"'):
        return val[1:-1]
    if val.startswith("'") and val.endswith("'"):
        return val[1:-1]
    if val.lower() == 'true':
        return True
    if val.lower() == 'false':
        return False
    if val.isdigit():
        return int(val)
    return val


def extract_frontmatter(content: str) -> Tuple[Optional[str], str]:
    """Extract YAML frontmatter and markdown body."""
    match = re.match(r'^---\r?\n([\s\S]*?)\r?\n---\r?\n([\s\S]*)$', content)
    if match:
        return match.group(1), match.group(2)
    return None, content


def validate_file_emojis(path: pathlib.Path, content: str) -> List[str]:
    """Check for any Unicode emoji characters."""
    errors = []
    lines = content.split('\n')
    for line_num, line in enumerate(lines, 1):
        matches = EMOJI_PATTERN.findall(line)
        if matches:
            errors.append(f"Emoji detected at line {line_num}: {matches}")
    return errors


def is_prohibited_absolute_path(target: str) -> bool:
    """Detect if a path or URI is an absolute machine path or forbidden URI scheme."""
    t = target.strip().replace('\\', '/')
    if t.lower().startswith('file:'):
        return True
    if re.match(r'^[a-zA-Z]:/', t):
        return True
    if t.startswith(('/', '~', '$')):
        return True
    return False


def validate_markdown_links(path: pathlib.Path, content: str, workspace_root: pathlib.Path) -> List[str]:
    """Validate markdown links: enforce strict relative links and prohibit absolute paths."""
    errors = []
    # Match all markdown links: [label](target)
    markdown_links = re.findall(r'\[(?:[^\]]*)\]\(([^)]+)\)', content)

    for raw_target in markdown_links:
        target = raw_target.strip()
        # Clean title suffix if present (e.g. `path/to/file "Title"`)
        target = target.split()[0].strip('<>')

        # Skip empty links, anchor-only links, mailto, and web protocols
        if not target or target.startswith('#') or target.startswith(('http://', 'https://', 'mailto:', 'tel:')):
            continue

        # Skip placeholder tokens used in template definitions
        if '[' in target or ']' in target:
            continue

        # Prohibit absolute file URIs or machine paths
        if is_prohibited_absolute_path(target):
            errors.append(f"Absolute link prohibited: '{raw_target.strip()}'. Use clean relative paths instead.")
            continue

        # Strip anchor if present for existence check
        clean_target = target.split('#')[0]
        if not clean_target:
            continue

        target_path = (path.parent / clean_target).resolve()
        if not target_path.exists():
            errors.append(f"Dead relative link: '{target}' (resolved: {target_path})")

    return errors


def validate_sections(body: str, required_section_patterns: List[str], asset_type: str) -> List[str]:
    """Check that mandatory markdown sections exist."""
    errors = []
    for pattern in required_section_patterns:
        if not re.search(r'#+\s+.*' + pattern, body, re.IGNORECASE):
            errors.append(f"Missing mandatory section matching pattern: '{pattern}'")
    return errors


def validate_skill(skill_dir: pathlib.Path, workspace_root: pathlib.Path) -> List[str]:
    """Validate a skill folder and its SKILL.md."""
    errors = []
    skill_name = skill_dir.name

    if not KEBAB_CASE_PATTERN.match(skill_name):
        errors.append(f"Skill folder name '{skill_name}' must be lowercase kebab-case.")

    entry_file = skill_dir / "SKILL.md"
    if not entry_file.exists():
        errors.append(f"Missing canonical entry point: {entry_file}")
        return errors

    content = entry_file.read_text(encoding='utf-8')

    # Emoji gate
    errors.extend(validate_file_emojis(entry_file, content))

    # Dead links gate
    errors.extend(validate_markdown_links(entry_file, content, workspace_root))

    # Frontmatter gate
    raw_fm, body = extract_frontmatter(content)
    if not raw_fm:
        errors.append("SKILL.md must start with valid YAML frontmatter between '---' delimiters.")
        return errors

    try:
        fm = parse_simple_yaml(raw_fm)
    except Exception as e:
        errors.append(f"Failed to parse YAML frontmatter: {e}")
        return errors

    # Check required fields
    if "name" not in fm:
        errors.append("Frontmatter missing required field: 'name'.")
    elif fm["name"] != skill_name:
        errors.append(f"Frontmatter 'name' ('{fm['name']}') must match parent folder name ('{skill_name}').")

    if "description" not in fm:
        errors.append("Frontmatter missing required field: 'description'.")
    else:
        desc = str(fm["description"])
        if len(desc) < 30:
            errors.append(f"Description too short ({len(desc)} chars). Minimum is 30.")

    # Check metadata category if present
    if "metadata" in fm and isinstance(fm["metadata"], dict):
        cat = fm["metadata"].get("category")
        if cat and cat not in ALLOWED_SKILL_CATEGORIES:
            errors.append(f"Invalid skill metadata category: '{cat}'. Allowed: {sorted(ALLOWED_SKILL_CATEGORIES)}")

    # Sections gate
    errors.extend(validate_sections(body, SKILL_REQUIRED_SECTIONS, "Skill"))

    return errors


def validate_agent(agent_file: pathlib.Path, workspace_root: pathlib.Path) -> List[str]:
    """Validate a subagent markdown file."""
    errors = []
    agent_stem = agent_file.stem

    if not KEBAB_CASE_PATTERN.match(agent_stem):
        errors.append(f"Agent filename '{agent_file.name}' must be lowercase kebab-case (excluding .md).")

    content = agent_file.read_text(encoding='utf-8')

    errors.extend(validate_file_emojis(agent_file, content))
    errors.extend(validate_markdown_links(agent_file, content, workspace_root))

    raw_fm, body = extract_frontmatter(content)
    if not raw_fm:
        errors.append(f"Agent file {agent_file.name} must start with YAML frontmatter between '---' delimiters.")
        return errors

    try:
        fm = parse_simple_yaml(raw_fm)
    except Exception as e:
        errors.append(f"Failed to parse YAML frontmatter: {e}")
        return errors

    for req in ["name", "role", "description", "mode"]:
        if req not in fm:
            errors.append(f"Agent frontmatter missing required field: '{req}'.")

    if "name" in fm and fm["name"] != agent_stem:
        errors.append(f"Agent frontmatter 'name' ('{fm['name']}') must match file stem ('{agent_stem}').")

    if "mode" in fm and fm["mode"] not in ALLOWED_AGENT_MODES:
        errors.append(f"Invalid agent mode: '{fm['mode']}'. Allowed: {sorted(ALLOWED_AGENT_MODES)}")

    if "allowed_tools" in fm:
        if not isinstance(fm["allowed_tools"], list) or len(fm["allowed_tools"]) == 0:
            errors.append("Agent frontmatter 'allowed_tools' must be a non-empty array of strings.")

    errors.extend(validate_sections(body, AGENT_REQUIRED_SECTIONS, "Agent"))

    return errors


def validate_rule(rule_file: pathlib.Path, workspace_root: pathlib.Path) -> List[str]:
    """Validate an architectural rule markdown file."""
    errors = []
    rule_stem = rule_file.stem

    if not KEBAB_CASE_PATTERN.match(rule_stem):
        errors.append(f"Rule filename '{rule_file.name}' must be lowercase kebab-case (excluding .md).")

    content = rule_file.read_text(encoding='utf-8')

    errors.extend(validate_file_emojis(rule_file, content))
    errors.extend(validate_markdown_links(rule_file, content, workspace_root))

    raw_fm, body = extract_frontmatter(content)
    if not raw_fm:
        errors.append(f"Rule file {rule_file.name} must start with YAML frontmatter between '---' delimiters.")
        return errors

    try:
        fm = parse_simple_yaml(raw_fm)
    except Exception as e:
        errors.append(f"Failed to parse YAML frontmatter: {e}")
        return errors

    for req in ["id", "title", "category", "severity", "scope"]:
        if req not in fm:
            errors.append(f"Rule frontmatter missing required field: '{req}'.")

    if "id" in fm and not RULE_ID_PATTERN.match(str(fm["id"])):
        errors.append(f"Rule ID '{fm['id']}' does not match pattern RULE-[A-Z0-9]+-[0-9]{{3}}.")

    if "category" in fm and fm["category"] not in ALLOWED_RULE_CATEGORIES:
        errors.append(f"Invalid rule category '{fm['category']}'. Allowed: {sorted(ALLOWED_RULE_CATEGORIES)}")

    if "severity" in fm and fm["severity"] not in ALLOWED_RULE_SEVERITIES:
        errors.append(f"Invalid rule severity '{fm['severity']}'. Allowed: {sorted(ALLOWED_RULE_SEVERITIES)}")

    if "scope" in fm:
        if not isinstance(fm["scope"], dict) or "include" not in fm["scope"]:
            errors.append("Rule 'scope' must be a map containing an 'include' list of glob patterns.")

    errors.extend(validate_sections(body, RULE_REQUIRED_SECTIONS, "Rule"))

    return errors


def find_agents_root(explicit_root: Optional[str] = None) -> pathlib.Path:
    """Dynamically discover the .agents root directory without hardcoded absolute paths."""
    if explicit_root:
        return pathlib.Path(explicit_root).resolve()

    # 1. Check current working directory
    cwd = pathlib.Path.cwd().resolve()
    if cwd.name == ".agents" and (cwd / "skills").exists():
        return cwd
    if (cwd / ".agents").exists():
        return (cwd / ".agents").resolve()

    # 2. Traverse upwards from this script's directory
    script_dir = pathlib.Path(__file__).resolve().parent
    for parent in [script_dir] + list(script_dir.parents):
        if parent.name == ".agents" and (parent / "skills").exists():
            return parent
        if (parent / ".agents").exists():
            return (parent / ".agents").resolve()

    # 3. Traverse upwards from current working directory
    for parent in list(cwd.parents):
        if (parent / ".agents").exists():
            return (parent / ".agents").resolve()

    # 4. Fallback to standard relative .agents
    return (cwd / ".agents").resolve()


def main() -> int:
    parser = argparse.ArgumentParser(description="Validate .agents assets against enterprise standards.")
    parser.add_argument("--root", default=None,
                        help="Path to .agents root directory (dynamically resolved if omitted).")
    parser.add_argument("-v", "--verbose", action="store_true", help="Enable verbose logging.")
    args = parser.parse_args()

    agents_root = find_agents_root(args.root)
    workspace_root = agents_root.parent

    if not agents_root.exists():
        print(f"ERROR: .agents directory '{agents_root}' does not exist.")
        return 1

    total_checked = 0
    total_failures = 0

    print("=================================================================")
    print("   .agents Subsystem Automated Quality Validation Gate")
    print(f"   Root: {agents_root}")
    print("=================================================================\n")

    # 1. Check Skills
    skills_dir = agents_root / "skills"
    if skills_dir.exists():
        for skill_dir in sorted(skills_dir.iterdir()):
            if skill_dir.is_dir() and not skill_dir.name.startswith('.'):
                total_checked += 1
                errs = validate_skill(skill_dir, workspace_root)
                if errs:
                    total_failures += 1
                    print(f"[FAIL] Skill: {skill_dir.name}")
                    for err in errs:
                        print(f"       - {err}")
                elif args.verbose:
                    print(f"[PASS] Skill: {skill_dir.name}")

    # 2. Check Agents
    agents_dir = agents_root / "agents"
    if agents_dir.exists():
        for agent_file in sorted(agents_dir.glob("*.md")):
            total_checked += 1
            errs = validate_agent(agent_file, workspace_root)
            if errs:
                total_failures += 1
                print(f"[FAIL] Agent: {agent_file.name}")
                for err in errs:
                    print(f"       - {err}")
            elif args.verbose:
                print(f"[PASS] Agent: {agent_file.name}")

    # 3. Check Rules
    rules_dir = agents_root / "rules"
    if rules_dir.exists():
        for rule_file in sorted(rules_dir.glob("*.md")):
            total_checked += 1
            errs = validate_rule(rule_file, workspace_root)
            if errs:
                total_failures += 1
                print(f"[FAIL] Rule: {rule_file.name}")
                for err in errs:
                    print(f"       - {err}")
            elif args.verbose:
                print(f"[PASS] Rule: {rule_file.name}")

    # 4. Check all supporting and reference Markdown files across .agents/
    # (templates, references, documentation) for emojis and dead/absolute links
    checked_primary_files = set()
    if skills_dir.exists():
        for skill_dir in skills_dir.iterdir():
            if skill_dir.is_dir():
                checked_primary_files.add((skill_dir / "SKILL.md").resolve())
    if agents_dir.exists():
        for f in agents_dir.glob("*.md"):
            checked_primary_files.add(f.resolve())
    if rules_dir.exists():
        for f in rules_dir.glob("*.md"):
            checked_primary_files.add(f.resolve())

    for md_file in sorted(agents_root.rglob("*.md")):
        if md_file.resolve() not in checked_primary_files:
            total_checked += 1
            file_errs = []
            try:
                content = md_file.read_text(encoding='utf-8')
                file_errs.extend(validate_file_emojis(md_file, content))
                file_errs.extend(validate_markdown_links(md_file, content, workspace_root))
            except Exception as e:
                file_errs.append(f"Failed to read file: {e}")

            if file_errs:
                total_failures += 1
                print(f"[FAIL] Reference/Template: {md_file.relative_to(agents_root)}")
                for err in file_errs:
                    print(f"       - {err}")
            elif args.verbose:
                print(f"[PASS] Reference/Template: {md_file.relative_to(agents_root)}")

    # 5. Global emoji scan on all non-markdown auxiliary files (.json, .py, .sh, etc.)
    for aux_file in sorted(agents_root.rglob("*")):
        if aux_file.is_file() and aux_file.suffix not in ('.md', '.gitkeep'):
            try:
                content = aux_file.read_text(encoding='utf-8')
                emoji_errs = validate_file_emojis(aux_file, content)
                if emoji_errs:
                    total_failures += 1
                    print(f"[FAIL] File: {aux_file.relative_to(agents_root)}")
                    for err in emoji_errs:
                        print(f"       - {err}")
            except Exception as e:
                if args.verbose:
                    print(f"Skipping binary/unreadable file: {aux_file}")

    print("\n-----------------------------------------------------------------")
    print(f"Validation Summary: {total_checked} assets checked, {total_failures} failures.")
    print("-----------------------------------------------------------------")

    if total_failures == 0:
        print("ALL QUALITY GATES PASSED (Zero emojis, valid frontmatter, strict sections).")
        return 0
    else:
        print(f"FAILED: {total_failures} asset(s) violated quality standards.")
        return 1


if __name__ == "__main__":
    sys.exit(main())
