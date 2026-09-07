# AI usage documentation

This document outlines the artificial intelligence (AI) tools, models, and workflows utilized by Group 10 to support code development, error troubleshooting, and conceptual learning for the TikTok data preparation project.

---

## AI tools and model specifications

| Team Member | AI Tool / Platform | Specific Model(s) Used | Key Purpose |
| :--- | :--- | :--- | :--- |
| **Mohamad** | Google Gemini | Gemini 3.6 / Flash | Code validation, cross-platform path debugging (Windows), and resolving git workflow conflicts. |
| **Jette** | Tilburg AI | GPT-4.1 | Concept clarification, understanding script logic, and troubleshooting script runtime issues. |
| **Iris** | Tilburg AI | GPT-4.1 | Command syntax lookup, script structure understanding, and error resolution. |
| **Danny** | Posit Assistant & Tilburg AI | Posit AI / Mistral | Resolving R package warnings/errors, analyzing alternative code implementations, and broad concept exploration. |

---

## Description of AI support and applications

AI tools were integrated throughout the first project lifecycle in three primary domains:

* **Code generation & structuring:** Assisted in establishing clean, reproducible pathing logic (`basename(getwd())`) for cross-platform compatibility and building the project structure.
* **Debugging & error resolution:** Provided solutions for Windows network download issues (e.g., URL string formatting, `mode = "wb"` requirements, and network protocols).
* **Git & version control management:** Helped guide team members through merge conflicts, staging errors, and `.gitignore` configurations.
* **Conceptual learning:** Used as a personalized tutor to explain R functions, Quarto document compilation, and data aggregation logic (`dplyr::summarize`).

---

## Output validation and quality assurance

To ensure academic integrity, security, and project accuracy, all AI-generated suggestions were subjected to strict human review:

1. **Independent verification & execution:** AI code suggestions were never committed directly without prior local execution and verification within Positron.
2. **Path & environment customization:** Standardized all AI-suggested hardcoded paths to relative paths (`../data/raw`) to ensure team-wide reproducibility.
3. **Peer review & Git tracking:** All script modifications were tested across team members' laptops before staging, committing, and closing GitHub issues.
4. **Data privacy:** Raw dataset files were handled locally and kept out of public AI prompts in compliance with data guidelines.