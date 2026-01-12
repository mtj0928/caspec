/// Supported tools for CASpec generation.
public struct Tool: Hashable, Sendable, Codable {
    /// Tool name used for CASPEC block filtering (e.g. "codex").
    public let name: String

    /// Output spec file name (e.g. "AGENTS.md").
    public let outputFileName: String

    /// Destination directory for expanded skills.
    public let skillsDirectoryName: String?

    /// Destination directory for expanded subagents.
    public let subagentsDirectoryName: String?

    public init(
        name: String,
        outputFileName: String,
        skillsDirectoryName: String?,
        subagentsDirectoryName: String?
    ) {
        self.name = name
        self.outputFileName = outputFileName
        self.skillsDirectoryName = skillsDirectoryName
        self.subagentsDirectoryName = subagentsDirectoryName
    }
}

extension Tool {
    /// Codex tool output (`AGENTS.md` and `.codex/`).
    public static let codex = Tool(
        name: "codex",
        outputFileName: "AGENTS.md",
        skillsDirectoryName: ".codex/skills",
        subagentsDirectoryName: nil
    )

    /// Claude Code output (`CLAUDE.md` and `.claude/`).
    public static let claude = Tool(
        name: "claude",
        outputFileName: "CLAUDE.md",
        skillsDirectoryName: ".claude/skills",
        subagentsDirectoryName: ".claude/subagents"
    )

    /// Default tools supported by CASpec.
    public static let defaults: [Tool] = [
        .codex,
        .claude
    ]
}
