<div align="center">
  
# projectinit
  
**Professional Stata Project Structure Initializer. One-click reproducible research infrastructure following J-PAL, DIME (World Bank), and AEA Data Editor standards.**

[![Version](https://img.shields.io/badge/version-2.1.0-blue.svg?style=flat-square)](https://github.com/MaykolMedrano/projectinit)
[![Stata](https://img.shields.io/badge/Stata-14%2B-blue?style=flat-square)](https://www.stata.com/)
[![Tests passing](https://img.shields.io/github/actions/workflow/status/MaykolMedrano/projectinit/main.yml?branch=master&style=flat-square)](https://github.com/MaykolMedrano/projectinit/actions)
[![Stars](https://img.shields.io/github/stars/MaykolMedrano/projectinit?style=flat-square&color=blue)](https://github.com/MaykolMedrano/projectinit/stargazers)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
</div>

---

## Features

- **J-PAL/DIME/AEA Standards**: Numbered folders (01_Data, 02_Scripts, 03_Outputs)
- **LaTeX Integration**: PUC thesis and standard templates with automatic macro generation
- **GitHub Automation**: One-command repository creation and deployment
- **Bilingual Support**: English/Spanish interfaces
- **Cross-Platform**: Windows, macOS, Linux compatible

---

## Installation

### Net Install (Recommended)

```stata
net install projectinit, from("https://raw.githubusercontent.com/MaykolMedrano/projectinit/master/installation")
```

### Manual Installation

1. Download `projectinit.ado` and `projectinit.sthlp` from `installation/`
2. Copy to your Stata ado directory:
   - **Windows**: `C:\ado\plus\p\`
   - **Mac**: `~/Library/Application Support/Stata/ado/plus/p/`
   - **Linux**: `~/.stata/ado/plus/p/`

---

## Quick Start

```stata
* Basic project
projectinit "MyResearch", root("C:/Research")

* Full setup with LaTeX, GitHub, and replication package
projectinit "PhD_Dissertation", ///
    root("C:/Research") ///
    lang(en) ///
    latex(puc) ///
    github(private) ///
    replicate ///
    verbose
```

---

## Project Structure

```
YourProject/
├── run.do                    # Master execution script
├── README.md                 # Project documentation
├── .gitignore
├── 01_Data/
│   ├── Raw/                 # Original, immutable data
│   ├── De-identified/       # Anonymized data
│   ├── Intermediate/        # Processed data
│   └── Final/               # Analysis-ready datasets
├── 02_Scripts/
│   ├── Ados/                # Custom programs
│   ├── Data_Preparation/    # Cleaning scripts
│   ├── Analysis/            # Main analysis
│   └── Validation/          # Robustness checks
├── 03_Outputs/
│   ├── Tables/              # LaTeX/CSV tables
│   ├── Figures/             # PDF/PNG figures
│   └── Logs/                # Execution logs
├── 04_Writing/              # LaTeX manuscript (if latex() used)
├── 05_Doc/                  # Documentation, codebooks, IRB
└── 06_Replication/          # AEA-compliant package (if replicate used)
```

---

## Command Reference

### Syntax

```stata
projectinit projectname, root(string) [options]
```

### Options

| Option | Values | Default | Description |
|--------|--------|---------|-------------|
| `root()` | path | *required* | Parent directory for project |
| `lang()` | `en` \| `es` | `en` | Interface language |
| `latex()` | `puc` \| `standard` | none | LaTeX template |
| `github()` | `public` \| `private` | none | Create GitHub repository |
| `author()` | `"name"` | username | Author name |
| `email()` | `"email"` | — | Contact email |
| `replicate` | — | — | Include AEA replication package |
| `overwrite` | — | — | Overwrite existing project |
| `verbose` | — | — | Display detailed output |

---

## Best Practices

- **Never modify raw data** — Keep `01_Data/Raw/` untouched
- **Use dynamic paths** — Always use globals from `run.do`
- **Set random seeds** — Ensures reproducible results
- **Document dependencies** — List all packages in `run.do`
- **Version control** — Use git to track changes

For detailed workflow and AEA compliance guidelines, run `help projectinit` in Stata.

---

## Citation

```bibtex
@software{projectinit2026,
  author = {Maykol Medrano},
  title = {projectinit: Professional Stata Project Structure Initializer},
  version = {2.1.0},
  year = {2026},
  url = {https://github.com/MaykolMedrano/projectinit}
}
```

---

## Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/NewFeature`
3. Commit changes: `git commit -m 'Add NewFeature'`
4. Push: `git push origin feature/NewFeature`
5. Open Pull Request

---

## Acknowledgments

Built following best practices from:

- **J-PAL (MIT)** — Abdul Latif Jameel Poverty Action Lab
- **DIME (World Bank)** — Development Impact Evaluation
- **AEA Data Editor** — American Economic Association
- Gentzkow & Shapiro (2014) — "Code and Data for the Social Sciences"

---

## License

MIT License — See [LICENSE](LICENSE) for details.

---

**Version**: 2.1.0 | **Stata**: 14+ | **Changelog**: [CHANGELOG.md](CHANGELOG.md)
