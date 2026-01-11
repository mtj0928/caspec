/// Supported tools for CASpec generation.
public enum Tool: String, CaseIterable, Sendable {
    /// Codex tool output (`AGENTS.md` and `.codex/`).
    case codex
    /// Claude Code output (`CLAUDE.md` and `.claude/`).
    case claude
}

extension Tool {
    var outputFileName: String {
        switch self {
        case .codex: "AGENTS.md"
        case .claude: "CLAUDE.md"
        }
    }

    var skillsFolderName: String? {
        switch self {
        case .codex: ".codex/skills"
        case .claude: ".claude/skills"
        }
    }

    var subagentsFolderName: String? {
        switch self {
        case .codex: nil
        case .claude: ".claude/subagents"
        }
    }

    var caspecBlockStart: String {
        "<!-- CASPEC:\(rawValue) -->"
    }
}
