# projectinit v2.1 Enterprise

**Professional Stata Project Structure Initializer**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stata](https://img.shields.io/badge/Stata-14%2B-blue)](https://www.stata.com/)
[![Version](https://img.shields.io/badge/version-2.1.0-blue.svg)](https://github.com/MaykolMedrano/projectinit)

> One-click reproducible research infrastructure following **J-PAL (MIT)**, **DIME (World Bank)**, and **AEA Data Editor** standards. Includes LaTeX integration, GitHub automation, and bilingual support optimized for Chilean/Peruvian microdata research.

**Author**: Maykol Medrano | **Email**: mmedrano2@uc.cl | **GitHub**: [@MaykolMedrano](https://github.com/MaykolMedrano)

---

## 📋 Table of Contents

- [Features](#-features)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Usage Examples](#-usage-examples)
- [Project Structure](#-project-structure)
- [Command Reference](#-command-reference)
- [Testing](#-testing)
- [Workflow Guide](#-workflow-guide)
- [Best Practices](#-best-practices)
- [Version History](#-version-history)
- [Contributing](#-contributing)
- [Citation](#-citation)
- [Support](#-support)

---

## 🌟 Features

### v2.1 Enterprise Highlights

- ✅ **J-PAL/DIME/AEA Standards**: Numbered folders (01_Data, 02_Scripts, 03_Outputs)
- ✅ **LaTeX Integration**: PUC thesis and standard templates with automatic macro generation
- ✅ **GitHub Automation**: One-command repository creation and deployment
- ✅ **Bilingual Support**: Full English/Spanish interfaces
- ✅ **Microdata Ready**: Pre-configured for CASEN, ENAHO, BCRP data
- ✅ **Dynamic Paths**: Portable projects using `c(pwd)`
- ✅ **Professional UX**: SMCL-formatted output with progress indicators
- ✅ **Security**: Input validation and path traversal protection
- ✅ **Cross-Platform**: Windows, macOS, Linux compatible

### What Gets Created

```
YourProject/
├── run.do                    # Master execution script
├── README.md                 # Project documentation
├── .gitignore               # Git configuration
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
│   ├── Logs/                # Execution logs
│   └── Raw_Outputs/         # Unformatted results
├── 04_Writing/              # LaTeX manuscript (if latex() used)
│   ├── main.tex
│   ├── preamble.tex
│   ├── macros.tex           # Auto-generated from Stata
│   └── sections/
├── 05_Doc/                  # Documentation
│   ├── Codebooks/
│   ├── Questionnaires/
│   └── IRB/
└── 06_Replication/          # AEA-compliant package (if replicate used)
```

---

## 📦 Installation

### Option 1: Net Install (Recommended)

Once published on GitHub:

```stata
net install projectinit, from("https://raw.githubusercontent.com/MaykolMedrano/projectinit/main/")
```

### Option 2: Direct from Repository

```stata
* Clone or download repository
adopath + "C:/path/to/projectinit"

* Verify installation
which projectinit
help projectinit
```

### Option 3: Manual Installation

1. Download `projectinit.ado` and `projectinit.sthlp`
2. Copy to your Stata ado directory:
   - **Windows**: `C:\ado\plus\p\`
   - **Mac**: `~/Library/Application Support/Stata/ado/plus/p/`
   - **Linux**: `~/.stata/ado/plus/p/`

---

## 🚀 Quick Start

### Basic Project

```stata
projectinit "MyResearch", root("C:/Research")
```

### With LaTeX and Replication

```stata
projectinit "PhD_Dissertation", ///
    root("C:/Research") ///
    lang(en) ///
    latex(puc) ///
    author("Maykol Medrano") ///
    replicate ///
    verbose
```

### Spanish Interface with GitHub

```stata
projectinit "Tesis_Economia", ///
    root("C:/Investigacion") ///
    lang(es) ///
    latex(standard) ///
    github(private) ///
    author("Maykol Medrano") ///
    email("mmedrano2@uc.cl")
```

---

## 📚 Usage Examples

### Example 1: Impact Evaluation Project

```stata
* Create project with full features
projectinit "ImpactEval_RCT", ///
    root("D:/Projects") ///
    lang(en) ///
    latex(standard) ///
    github(public) ///
    author("Maykol Medrano") ///
    replicate ///
    verbose

* Navigate and start working
cd "D:/Projects/ImpactEval_RCT"

* Place raw data
copy "C:/RawData/survey.dta" "01_Data/Raw/"

* Run master script (installs packages, executes all)
do run.do
```

### Example 2: Chilean Microdata Analysis

```stata
* Project optimized for CASEN data
projectinit "Pobreza_Chile_2024", ///
    root("C:/Investigacion") ///
    lang(es) ///
    latex(standard) ///
    author("Maykol Medrano")

* The generated run.do includes pre-configured CASEN packages:
* - usecasen
* - fixencoding
* - datadex
```

### Example 3: Quick Test

```stata
* Test installation
projectinit "QuickTest", root("C:/Temp") verbose

* Verify structure
cd "C:/Temp/QuickTest"
dir
```

---

## 🏗️ Project Structure

### Data Workflow

```
Raw → De-identified → Intermediate → Final
```

- **Raw/**: Original data (never modified)
- **De-identified/**: Anonymized datasets
- **Intermediate/**: Cleaned, processed data
- **Final/**: Analysis-ready datasets

### Code Workflow

```
Data_Preparation → Analysis → Validation
```

### LaTeX Integration (if `latex()` used)

**Generate macros in Stata:**
```stata
* In your analysis script
count
local N = r(N)

* Write to LaTeX
file open macros using "04_Writing/macros.tex", write replace
file write macros "\newcommand{\samplesize}{`N'}" _n
file close macros
```

**Use in LaTeX:**
```latex
Our sample contains \samplesize observations.
```

### GitHub Integration (if `github()` used)

Automatically executes:
```bash
git init
gh repo create --public/private --source=.
git add .
git commit -m "Initial project structure"
git push -u origin main
```

**Requirements**: GitHub CLI (`gh`) installed and authenticated

---

## 🔧 Command Reference

### Syntax

```stata
projectinit projectname, root(string) [options]
```

### Required Arguments

| Argument | Description |
|----------|-------------|
| `projectname` | Name of project (will be folder name) |
| `root(string)` | Parent directory where project will be created |

### Options

| Option | Values | Default | Description |
|--------|--------|---------|-------------|
| `lang()` | `en` \| `es` | `en` | Interface language |
| `latex()` | `puc` \| `standard` | none | LaTeX template |
| `github()` | `public` \| `private` | none | Create GitHub repo |
| `author()` | `"name"` | "Maykol Medrano" | Author name |
| `email()` | `"email"` | "mmedrano2@uc.cl" | Contact email |
| `replicate` | | | Include AEA replication package |
| `overwrite` | | | Overwrite existing project |
| `verbose` | | | Display detailed output |

### Returned Values

```stata
r(projname)   * Project name
r(mainpath)   * Full path to project
r(created)    * "success" if completed
```

---

## 🧪 Testing

### Quick Test (30 seconds)

```stata
* Test installation
projectinit "TestProject", root("C:/Temp") verbose

* Verify
cd "C:/Temp/TestProject"
dir
do run.do
```

### Automated Test Suite

```stata
* From project directory
cd "C:/Users/User/OneDrive - Universidad Católica de Chile/Proyectos_GitHub/projectinit"
do PRUEBA_RAPIDA.do
```

This script tests:
- ✅ Package installation
- ✅ Basic project creation
- ✅ Replication package option
- ✅ Overwrite functionality
- ✅ Error handling

**Expected output:**
```
✓ TODAS LAS PRUEBAS COMPLETADAS
```

---

## 📖 Workflow Guide

### Complete Research Workflow

**1. Initialize Project**

```stata
projectinit "MyResearch", ///
    root("C:/Research") ///
    lang(en) ///
    latex(standard) ///
    github(private) ///
    author("Maykol Medrano") ///
    replicate
```

**2. Setup Environment**

```stata
cd "C:/Research/MyResearch"

* Edit run.do to add required packages
doedit run.do

* Add packages like:
* local packages "estout reghdfe ftools"
```

**3. Add Data**

```stata
* Place raw data (never modify originals)
copy "C:/Data/survey.dta" "01_Data/Raw/"
```

**4. Write Analysis Scripts**

```stata
* Data preparation
doedit 02_Scripts/Data_Preparation/01_clean.do

* Main analysis
doedit 02_Scripts/Analysis/01_regressions.do

* Generate figures
doedit 02_Scripts/Analysis/02_figures.do
```

**5. Execute**

```stata
* Run entire project
do run.do

* Or run specific scripts
do 02_Scripts/Data_Preparation/01_clean.do
```

**6. Write Manuscript (if LaTeX)**

```stata
* Export tables
esttab using "04_Writing/tables/main_results.tex", replace

* Export figures
graph export "04_Writing/figures/trends.pdf", replace

* Edit main.tex in Overleaf or local LaTeX editor
```

**7. Version Control (if GitHub)**

```stata
* Make changes, then commit
shell git add .
shell git commit -m "Updated analysis with robustness checks"
shell git push
```

**8. Prepare Replication (if replicate)**

```stata
cd "06_Replication"

* Copy final data
copy "../01_Data/Final/analysis.dta" "data/"

* Copy scripts
copy "../02_Scripts/Analysis/*.do" "code/"

* Test replication
do replication.do
```

---

## ✨ Best Practices

### For Reproducibility

- ✅ **Never modify raw data** - Keep `01_Data/Raw/` untouched
- ✅ **Use dynamic paths** - Always use globals from `run.do`
- ✅ **Set random seeds** - Ensures reproducible results
- ✅ **Document dependencies** - List all packages in `run.do`
- ✅ **Version control** - Use git to track changes
- ✅ **Linear workflow** - Scripts execute in numbered order

### For Collaboration

- 📝 Keep README.md updated
- 💬 Comment code thoroughly
- 🔄 Use consistent naming conventions
- 📊 Document data sources
- 🧪 Test replication package before submission

### For AEA Compliance

When preparing journal submission:

1. **Complete replication README**
   - Edit `06_Replication/README_REPLICATION.md`
   - Document all data sources and access restrictions
   - Provide system requirements and expected runtime

2. **Test on clean machine**
   ```stata
   cd "06_Replication"
   do replication.do
   ```

3. **Verify outputs match paper exactly**

---

## 📊 Version History

### v2.1.0 Enterprise (Current - January 2026)

**Major Features:**
- J-PAL/DIME/AEA Data Editor compliance
- Numbered folder structure (01_Data, 02_Scripts, etc.)
- Enhanced LaTeX integration
- Professional SMCL interface
- Robust security validation

**Technical:**
- 1,096 lines of code
- Input sanitization
- Path traversal protection
- Multi-OS compatibility verified

### v2.0.0 (December 2025)

- LaTeX integration (PUC and standard templates)
- GitHub automation
- Bilingual support (EN/ES)
- Microdata optimization (CASEN/ENAHO)

### v1.0.0 (December 2025)

- Initial release
- Basic AEA/JPAL/MIT structure
- Replication package support

**View previous versions**: See `versions/` folder

---

## 🤝 Contributing

Contributions are welcome! To contribute:

1. Fork the repository
2. Create feature branch: `git checkout -b feature/AmazingFeature`
3. Make changes and test thoroughly
4. Commit: `git commit -m 'Add AmazingFeature'`
5. Push: `git push origin feature/AmazingFeature`
6. Open Pull Request

**Code Standards:**
- Follow Stata best practices
- Add comments for complex logic
- Test on Windows, Mac, and Linux if possible
- Update documentation

---

## 📖 Citation

If you use **projectinit** in your research, please cite:

```bibtex
@software{projectinit2026,
  author = {Maykol Medrano},
  title = {projectinit v2.1: Professional Stata Project Structure Initializer},
  version = {2.1.0},
  year = {2026},
  url = {https://github.com/MaykolMedrano/projectinit}
}
```

---

## 📞 Support

### Getting Help

- 📖 **Documentation**: This README
- 🔧 **In Stata**: `help projectinit`
- 💬 **Discussions**: [GitHub Discussions](https://github.com/MaykolMedrano/projectinit/discussions)
- 🐛 **Issues**: [GitHub Issues](https://github.com/MaykolMedrano/projectinit/issues)
- 📧 **Email**: mmedrano2@uc.cl

### Reporting Bugs

Please include:
- Stata version (`about`)
- Operating system
- Full command executed
- Error message
- Expected vs actual behavior

### Feature Requests

Open an issue describing:
- Use case
- Expected behavior
- Why it would be useful

---

## 🙏 Acknowledgments

Built following best practices from:
- **J-PAL (MIT)** - Abdul Latif Jameel Poverty Action Lab
- **DIME (World Bank)** - Development Impact Evaluation
- **AEA Data Editor** - American Economic Association
- **NBER** - National Bureau of Economic Research
- Gentzkow & Shapiro (2014) - "Code and Data for the Social Sciences"

### Related Tools

- [iefolder](https://github.com/worldbank/iefolder) - World Bank DIME tool
- [ietoolkit](https://github.com/worldbank/ietoolkit) - Impact evaluation toolkit
- [datacheck](https://ideas.repec.org/c/boc/bocode/s458060.html) - Data quality verification

---

## 📄 License

This project is licensed under the MIT License.

**What this means:**
- ✅ Free for academic and commercial use
- ✅ Modify and distribute freely
- ✅ No warranty provided
- ✅ Attribution appreciated

---

## 🔗 Links

- **GitHub**: https://github.com/MaykolMedrano/projectinit
- **Issues**: https://github.com/MaykolMedrano/projectinit/issues
- **Author**: [@MaykolMedrano](https://github.com/MaykolMedrano)

---

## 📈 Stats

- **Lines of Code**: ~1,100 (v2.1)
- **Documentation**: Comprehensive inline comments
- **Tested On**: Stata 14-18, Windows/Mac/Linux
- **Standards**: J-PAL, DIME, AEA, NBER compliant
- **Language Support**: English, Spanish

---

**Made with ❤️ for reproducible research**

*Optimized for Chilean and Peruvian microdata analysis*

**Version**: 2.1.0 Enterprise
**Released**: January 2026
**Author**: Maykol Medrano (mmedrano2@uc.cl)
