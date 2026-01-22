# Changelog

All notable changes to `projectinit` will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.1.0] - 2026-01-22

### Added
- **LaTeX Integration**: Added `latex()` option with two templates:
  - `latex(standard)`: Standard academic article template
  - `latex(puc)`: Pontificia Universidad Católica de Chile thesis template with institutional formatting (9pt, a4paper)
  - LaTeX environment includes: main.tex, preamble.tex, macros.tex, references.bib, and section files
- **GitHub Integration**: Added `github()` option for automated repository creation:
  - `github(public)`: Create public GitHub repository
  - `github(private)`: Create private GitHub repository
  - Requires Git and GitHub CLI (gh) installed and authenticated
  - Creates initial commit and pushes to remote
  - Graceful fallback if GitHub CLI unavailable (creates local Git repo only)
- **AEA Replication Package**: Added `replicate` option:
  - Creates `06_Replication/` folder
  - Generates AEA Data Editor-compliant README_REPLICATION.md
  - Includes data availability statement, computational requirements, and replication instructions
- **Bilingual Support**: Added `language()` option:
  - `language(en)`: English templates (default)
  - `language(es)`: Spanish templates
  - Affects script comments, README, and section headings
- **Author Metadata**: Added `author()` and `email()` options for customization
- **Verbose Mode**: Added `verbose` option for detailed progress information
- **Overwrite Protection**: Projects now protected by default, with `overwrite` flag for recreation
- **Stored Results**: Command now returns detailed information in `r()`:
  - `r(project_name)`: Project name
  - `r(project_path)`: Full path to project
  - `r(language)`: Language used
  - `r(latex_template)`: LaTeX template (if any)
  - `r(github_status)`: GitHub integration status
  - `r(N_folders)`: Number of folders created
  - `r(N_files)`: Number of files created

### Changed
- **Folder Structure**: Updated to J-PAL/DIME/AEA standards:
  - `01_Data/` (Raw/, External/, Intermediate/, Final/)
  - `02_Scripts/` (01_Cleaning/, 02_Analysis/, 03_Figures/, 04_Tables/)
  - `03_Outputs/` (Figures/, Tables/, Logs/)
  - `04_Writing/` (optional, with LaTeX)
  - `05_Admin/` (meetings, correspondence, protocols)
  - `06_Replication/` (optional, AEA-compliant)
- **Master Scripts**: Enhanced `run.do` and `00_setup.do`:
  - Better environment isolation with project-specific adopath
  - Dynamic path management using `c(pwd)` for portability
  - Comprehensive package management
  - Improved error handling
- **README.md**: Enhanced template with:
  - Reproducibility instructions
  - Directory structure documentation
  - Citation guidelines
  - Data availability statements
- **.gitignore**: Upgraded to "elite" version:
  - Comprehensive exclusions for Stata temporary files
  - Data protection (excludes raw data, includes do-files)
  - OS-specific ignores (Windows, Mac, Linux)
  - IDE-specific patterns

### Fixed
- **Quote Escaping**: Fixed all `file write` statements to use compound quotes (`` `"..."' ``) instead of escaped quotes (`\"...\"`)
  - Resolves `invalid syntax r(198)` errors during file generation
  - Applied consistently across run.do, setup files, and README generation
- **SMCL Formatting**: Fixed display formatting in success messages
  - Removed SMCL tags from paths to prevent syntax errors
  - Improved output readability
- **GitHub Error Handling**: Enhanced to handle cases where GitHub CLI is not in PATH
  - Creates local Git repository even if gh unavailable
  - Provides clear manual setup instructions
  - Only shows success if truly successful

### Documentation
- Added formal `.sthlp` help file with:
  - Complete syntax documentation
  - Detailed option descriptions
  - Multiple examples
  - References to academic standards
- Added certification script (`certification/certify_projectinit.do`) with 14 comprehensive tests
- Added comprehensive examples file (`examples/projectinit_examples_v2.1.do`) with 12 real-world scenarios
- Updated package files for SSC compliance (`.pkg`, `stata.toc`)

## [2.0.0] - 2025-12-11

### Added
- Professional folder structure following international best practices
- Master execution scripts (master.do, run_all.do)
- Configuration management (_config.do)
- Setup scripts (00_setup.do)
- Template analysis scripts (cleaning, analysis, figures, tables)
- README.md generation
- .gitignore generation
- Command-line interface with options parsing

### Changed
- Complete rewrite from v1.x
- Modular architecture for maintainability
- Enhanced error handling and validation
- Improved path management for cross-platform compatibility

## [1.0.0] - 2025-11-15

### Added
- Initial release
- Basic project structure creation
- Simple folder generation
- Minimal configuration

---

## Upgrade Guide

### From 2.0.x to 2.1.0

**New Features Available**:
- Use `latex(standard)` or `latex(puc)` to add LaTeX writing environment
- Use `github(public)` or `github(private)` for automated Git/GitHub setup
- Use `replicate` to add AEA-compliant replication package
- Use `language(es)` for Spanish templates
- Use `verbose` to see detailed progress
- Use `author("Name")` and `email("email@domain")` for metadata

**Backward Compatibility**:
- All v2.0.x syntax remains valid
- Default behavior unchanged (basic project creation)
- Existing projects not affected

**Example Migration**:
```stata
* Old v2.0.x syntax (still works):
projectinit "MyProject", root("C:/Research")

* New v2.1.0 with features:
projectinit "MyProject", ///
    root("C:/Research") ///
    latex(standard) ///
    github(private) ///
    replicate ///
    verbose
```

### From 1.x to 2.x

**Breaking Changes**:
- Folder structure completely redesigned
- New numbered folder convention (01_Data, 02_Scripts, etc.)
- Different script templates
- Enhanced configuration system

**Recommendation**: Start fresh projects with v2.x syntax. Do not upgrade existing v1.x projects in place.

---

## Future Roadmap

### Planned for v2.2.0
- Conda/Python virtual environment integration
- R integration (renv, targets)
- Pre-commit hooks configuration
- Docker containerization option
- Cloud storage integration (Dropbox, OneDrive, Google Drive)

### Planned for v2.3.0
- Notebook integration (Jupyter, Quarto)
- Data validation templates
- Pre-analysis plan templates
- Survey instrument management
- Codebook generation

### Under Consideration
- Interactive setup wizard
- GUI for project configuration
- Template marketplace
- Institutional template customization
- Multi-language support (Portuguese, French)

---

## Acknowledgments

This package implements best practices from:
- J-PAL (MIT) - Research Resources
- DIME Analytics (World Bank) - Data Handbook
- AEA Data Editor - Guidance for Data and Code Preparation
- NBER - Working Paper Guidelines
- BITSS - Transparent and Reproducible Social Science Research
- Gentzkow & Shapiro - Code and Data for the Social Sciences

## License

MIT License - See LICENSE file for details.

## Contact

**Author**: Maykol Medrano
**Email**: mmedrano2@uc.cl
**Institution**: Instituto de Economía, Pontificia Universidad Católica de Chile
**GitHub**: https://github.com/MaykolMedrano/projectinit

For bug reports and feature requests, please open an issue on GitHub.
