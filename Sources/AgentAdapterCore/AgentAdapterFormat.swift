/// Shared formatting helpers for AGENT_ADAPTER tool-specific blocks.
public enum AgentAdapterFormat {
    private static let blockStartPrefix = "<!-- AGENT_ADAPTER:"
    private static let blockStartSuffix = " -->"
    private static let blockEnd = "<!-- AGENT_ADAPTER -->"

    /// Returns the block start marker for the given tool name.
    public static func blockStart(toolName: String) -> String {
        "\(blockStartPrefix)\(toolName)\(blockStartSuffix)"
    }

    /// Extracts the tool name from a block start line, if present.
    public static func parseBlockStart(line: String) -> String? {
        let regex = #/^\s*<!--\s*AGENT_ADAPTER:(.*?)-->\s*$/#
        guard let match = line.firstMatch(of: regex) else { return nil }
        let name = match.1.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? nil : String(name)
    }

    /// Returns true when the line is an AGENT_ADAPTER block end marker.
    public static func isBlockEnd(line: String) -> Bool {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed == blockEnd
    }
}
