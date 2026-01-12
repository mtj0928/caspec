/// Supported tools for CASpec generation.
public struct Tool: Hashable, Sendable, Codable {
    /// Tool name used for CASPEC block filtering (e.g. "codex").
    public let name: String

    /// Instructions file name (e.g. "AGENTS.md").
    public let instructionsFile: String

    /// Destination directory for expanded skills.
    public let skillsDirectory: String?

    /// Destination directory for expanded subagents.
    public let subagentsDirectory: String?

    public init(
        name: String,
        instructionsFile: String,
        skillsDirectory: String?,
        subagentsDirectory: String?
    ) {
        self.name = name
        self.instructionsFile = instructionsFile
        self.skillsDirectory = skillsDirectory
        self.subagentsDirectory = subagentsDirectory
    }
}

extension Tool {
    private enum CodingKeys: String, CodingKey {
        case name
        case instructionsFile
        case skillsDirectory
        case skillsDirectoryName
        case subagentsDirectory
        case subagentsDirectoryName
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.instructionsFile = try container.decode(String.self, forKey: .instructionsFile)
        self.skillsDirectory = try container.decodeIfPresent(String.self, forKey: .skillsDirectory)
            ?? container.decodeIfPresent(String.self, forKey: .skillsDirectoryName)
        self.subagentsDirectory = try container.decodeIfPresent(String.self, forKey: .subagentsDirectory)
            ?? container.decodeIfPresent(String.self, forKey: .subagentsDirectoryName)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(instructionsFile, forKey: .instructionsFile)
        try container.encodeIfPresent(skillsDirectory, forKey: .skillsDirectory)
        try container.encodeIfPresent(subagentsDirectory, forKey: .subagentsDirectory)
    }
}

extension Tool {
    /// Codex tool output (`AGENTS.md` and `.codex/`).
    public static let codex = Tool(
        name: "codex",
        instructionsFile: "AGENTS.md",
        skillsDirectory: ".codex/skills",
        subagentsDirectory: nil
    )

    /// Claude Code output (`CLAUDE.md` and `.claude/`).
    public static let claude = Tool(
        name: "claude",
        instructionsFile: "CLAUDE.md",
        skillsDirectory: ".claude/skills",
        subagentsDirectory: ".claude/subagents"
    )

    /// Default tools supported by CASpec.
    public static let defaults: [Tool] = [
        .codex,
        .claude
    ]
}
