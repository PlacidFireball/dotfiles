export const server = async () => {
    return {
        "experimental.chat.system.transform": async (input, output) => {
            output.system.push("CRITICAL: You are STRICTLY FORBIDDEN from using the `bash` tool with commands like `cat`, `head`, `tail`, `sed`, `awk`, `vi`, or `nano` to read or edit files. You must ALWAYS use the dedicated `read`, `edit`, `write`, and `grep` tools for these operations.");
        },
        "tool.execute.before": async (input, output) => {
            if (input.tool === "bash") {
                const cmd = output.args?.command || "";
                const forbiddenCommands = /(?:^|\||&&|;)\s*(cat|sed|awk|vi|vim|nano|head|tail)\b/i;
                if (forbiddenCommands.test(cmd)) {
                    throw new Error(`Execution of '${cmd}' blocked. Do NOT use bash for file reading/editing. Please use the native 'read', 'edit', 'write', or 'grep' tools instead.`);
                }
            }
        }
    };
};
