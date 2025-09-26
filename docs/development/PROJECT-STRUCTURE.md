# VPNCTL: Project Structure

## Proposed Directory Layout
vpnctl/
├── bin/
│   ├── vpnctl          # Main CLI script
│   └── vpnctl-tui      # Optional TUI wrapper
├── config/             # Default configs (copied to XDG locations)
│   ├── config.ini      # Default settings
│   └── profiles/       # Example VPN profiles
├── lib/                # Shared Bash/Python libraries
│   └── helpers.sh      # Reusable functions (logging, DNS, etc.)
├── install.sh          # Installation script (user/system)
├── uninstall.sh        # Uninstall script
├── docs/
│   ├── PROJECT-STRUCTURE.md
│   ├── ARCHITECTURE.md
│   ├── PLAN.md         # Combined roadmap, checklist, and planning
│   └── README.md       # User-facing documentation
└── tests/              # Test scripts (e.g., BATS for Bash

