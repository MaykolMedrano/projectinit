# projectinit v2.0

**Professional Stata Project Initializer with LaTeX & GitHub Integration**

[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/MaykolMedrano/projectinit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stata](https://img.shields.io/badge/Stata-14%2B-blue)](https://www.stata.com/)

> **New in v2.0**: LaTeX integration, automated GitHub deployment, bilingual support (EN/ES), and optimized for Chilean & Peruvian microdata research.

---

## 🚀 What's New in v2.0

### Major Features

- **📝 LaTeX Integration**: Modular LaTeX writing environment with automatic macro generation
- **🔗 GitHub Automation**: One-command repository creation and deployment
- **🌐 Bilingual Support**: English and Spanish interfaces
- **📊 Microdata Ready**: Pre-configured for CASEN, ENAHO, and other Latin American surveys
- **🎓 University Templates**: PUC thesis format and standard academic templates
- **🔄 Dynamic Paths**: Fully portable projects using `c(pwd)`

---

## 📦 Installation

### Quick Install

```stata
* Download projectinit_v2.ado to your Stata ado directory
* Then verify:
which projectinit
```

### Manual Installation

1. Download `projectinit_v2.ado`
2. Copy to your Stata ado directory:
   - **Windows**: `C:\ado\plus\p\`
   - **Mac**: `~/Library/Application Support/Stata/ado/plus/p/`
   - **Linux**: `~/.stata/ado/plus/p/`

---

## 🎯 Usage

### Basic Syntax

```stata
projectinit "ProjectName", root("path") [options]
```

### Options

| Option | Values | Description |
|--------|--------|-------------|
| `lang()` | `en` \| `es` | Interface language (default: `en`) |
| `latex()` | `puc` \| `standard` | LaTeX template (default: none) |
| `github()` | `public` \| `private` | Create GitHub repo (default: none) |
| `author()` | `"name"` | Author name (default: "Maykol Medrano") |
| `replicate` | | Include replication package |
| `overwrite` | | Overwrite existing project |
| `verbose` | | Detailed output |

---

## 📚 Examples

### Example 1: Basic Project (English)

```stata
projectinit "MyResearch", root("C:/Projects")
```

Creates:
```
MyResearch/
├── main.do                  # Master script
├── data/
│   ├── raw/                 # Raw data (read-only)
│   └── processed/           # Cleaned data
├── scripts/
│   ├── 01_clean.do
│   ├── 02_analysis.do
│   ├── 03_tables.do
│   └── 04_figures.do
├── results/
│   ├── tables/
│   └── figures/
└── temp/
```

### Example 2: Spanish Project with LaTeX

```stata
projectinit "Tesis_Economia", ///
    root("C:/Investigacion") ///
    lang(es) ///
    latex(puc) ///
    author("Juan Pérez")
```

Adds LaTeX structure:
```
writing/
├── main.tex                 # Main document
├── preamble.tex             # Packages and settings
├── macros.tex               # Auto-generated from Stata
├── sections/
│   ├── intro.tex
│   ├── data.tex
│   ├── methods.tex
│   ├── results.tex
│   └── conclusion.tex
├── tables/                  # For Stata tables
├── figures/                 # For Stata figures
└── references.bib
```

### Example 3: Full Package with GitHub

```stata
projectinit "ImpactEvaluation", ///
    root("D:/Projects") ///
    lang(en) ///
    latex(standard) ///
    github(public) ///
    author("Maria Garcia") ///
    replicate
```

This will:
1. ✅ Create complete project structure
2. ✅ Generate LaTeX manuscript environment
3. ✅ Initialize git repository
4. ✅ Create GitHub repository
5. ✅ Push initial commit
6. ✅ Add replication package
7. ✅ Display repository URL

### Example 4: Chilean Microdata Research

```stata
projectinit "Pobreza_Chile_2023", ///
    root("C:/Research") ///
    lang(es) ///
    latex(standard) ///
    author("Investigador CASEN")
```

The generated `main.do` includes pre-configured packages:
```stata
* Chilean/Peruvian microdata packages
local packages `packages' "usecasen"
local packages `packages' "enahodata"
local packages `packages' "usebcrp"
local packages `packages' "fixencoding"
local packages `packages' "datadex"
```

---

## 🔧 Workflow

### Complete Research Workflow

```stata
* 1. Create project
projectinit "PolicyAnalysis", ///
    root("C:/Research") ///
    lang(en) ///
    latex(standard) ///
    github(public) ///
    author("Your Name")

* 2. Navigate to project
cd "C:/Research/PolicyAnalysis"

* 3. Add your data
copy "path/to/data.dta" "data/raw/survey.dta"

* 4. Run master script (installs packages, runs analysis)
do main.do

* 5. Edit LaTeX manuscript
* Open writing/main.tex in Overleaf or local LaTeX editor

* 6. View GitHub repository
shell gh repo view --web
```

---

## 📝 LaTeX Features

### Automatic Macro Generation

Generate values from Stata to use in LaTeX:

**In Stata (`03_tables.do`):**
```stata
* Calculate sample size
count
local N = r(N)

* Write to LaTeX macro file
file open macrofile using "$writing/macros.tex", write replace
file write macrofile "\newcommand{\samplesize}{`N'}" _n
file write macrofile "\newcommand{\meanage}{25.3}" _n
file close macrofile
```

**In LaTeX (`sections/results.tex`):**
```latex
Our sample consists of \samplesize observations
with a mean age of \meanage years.
```

### Template Options

#### Standard Template
- Article class (12pt, A4)
- APA-style citations
- Professional formatting
- Suitable for journal submissions

#### PUC Template
- Custom title page for Pontificia Universidad Católica de Chile
- Thesis formatting
- University branding
- Suitable for thesis submissions

---

## 🔗 GitHub Integration

### Requirements

1. Install GitHub CLI: https://cli.github.com/
2. Authenticate: `gh auth login`
3. Run projectinit with `github()` option

### What Happens

```stata
projectinit "MyProject", ///
    root("C:/Projects") ///
    github(public)
```

Automatically executes:
```bash
git init
gh repo create "MyProject" --public --source=. --remote=origin
git add .
git commit -m "Initial project structure by projectinit v2.0"
git push -u origin main
```

### .gitignore Configuration

The generated `.gitignore` automatically excludes:
- ✅ Raw data files (`.dta`, `.csv`, `.xlsx`)
- ✅ Stata logs (`.log`, `.smcl`)
- ✅ LaTeX auxiliary files (`.aux`, `.out`, `.bbl`)
- ✅ Temporary files
- ✅ OS-specific files

But **includes**:
- ✅ Final tables (`.tex`)
- ✅ Final figures (`.pdf`, `.png`)

---

## 📊 Microdata Features

### Pre-configured Packages

The `main.do` file includes references to specialized packages for Latin American microdata:

```stata
* Chilean household survey (CASEN)
* local packages `packages' "usecasen"

* Peruvian household survey (ENAHO)
* local packages `packages' "enahodata"

* Central Bank of Peru data
* local packages `packages' "usebcrp"

* Character encoding fixes (common in Latin American data)
* local packages `packages' "fixencoding"

* Data exploration tool
* local packages `packages' "datadex"
```

Just uncomment the packages you need!

### Example: Using CASEN Data

```stata
* In 01_clean.do
usecasen, year(2022) module(Ingresos)
save "$processed/casen2022.dta", replace
```

---

## 🌐 Bilingual Support

### English Interface

```stata
projectinit "MyProject", root("C:/") lang(en)
```

Generates:
- README in English
- Script comments in English
- LaTeX in English

### Spanish Interface

```stata
projectinit "MiProyecto", root("C:/") lang(es)
```

Genera:
- README en español
- Comentarios de scripts en español
- LaTeX en español

---

## 🎓 Academic Use Cases

### Use Case 1: Undergraduate Thesis

```stata
projectinit "Tesis_Pregrado", ///
    root("~/Documentos") ///
    lang(es) ///
    latex(puc) ///
    author("Estudiante UC")
```

### Use Case 2: PhD Dissertation

```stata
projectinit "PhD_Dissertation", ///
    root("~/Research") ///
    lang(en) ///
    latex(standard) ///
    github(private) ///
    author("PhD Candidate") ///
    replicate
```

### Use Case 3: Policy Report

```stata
projectinit "PolicyReport_Chile", ///
    root("C:/Projects") ///
    lang(es) ///
    latex(standard) ///
    author("Analista Público")
```

### Use Case 4: Journal Submission

```stata
projectinit "Paper_AER", ///
    root("~/Research") ///
    lang(en) ///
    latex(standard) ///
    github(public) ///
    replicate ///
    author("Maykol Medrano")
```

---

## 🔄 Migration from v1.0

### Key Changes

| Feature | v1.0 | v2.0 |
|---------|------|------|
| Folder structure | `01_data`, `02_code` | `data`, `scripts` |
| Master file | `master.do` | `main.do` |
| Paths | Manual `global ROOT` | Dynamic `c(pwd)` |
| LaTeX | Not available | Full integration |
| GitHub | Manual | Automated |
| Language | English only | English + Spanish |

### Migration Script

```stata
* Old v1.0 style
projectinit "Project", root("C:/") replicate

* New v2.0 style
projectinit "Project", root("C:/") replicate lang(en)
```

---

## 💡 Tips & Best Practices

### 1. Dynamic Paths

Always use the generated globals:
```stata
* Good
use "$raw/data.dta", clear

* Bad
use "C:/Users/John/data.dta", clear
```

### 2. Sequential Scripts

Name scripts with numbers:
```stata
scripts/
├── 01_clean.do
├── 02_merge.do
├── 03_analysis.do
└── 04_tables.do
```

### 3. LaTeX Workflow

```stata
* In Stata: Generate table
esttab using "$writing/tables/reg_table.tex", replace

* In LaTeX: Include table
\input{tables/reg_table.tex}
```

### 4. Version Control

```stata
* Make changes to code
* Commit regularly
shell git add .
shell git commit -m "Added robustness checks"
shell git push
```

---

## 📋 Complete Example: From Start to Finish

```stata
**********************************************
* COMPLETE RESEARCH PROJECT WORKFLOW
**********************************************

* 1. Initialize project
projectinit "MinimumWage_Chile", ///
    root("C:/Research") ///
    lang(es) ///
    latex(standard) ///
    github(private) ///
    author("Economista UC") ///
    replicate

* 2. Navigate to project
cd "C:/Research/MinimumWage_Chile"

* 3. Load CASEN data
use "C:/Data/CASEN/casen2022.dta", clear
save "data/raw/casen2022.dta", replace

* 4. Edit cleaning script
doedit scripts/01_clean.do

/* In 01_clean.do:
use "$raw/casen2022.dta", clear
keep if edad >= 18 & edad <= 65
gen log_ingreso = log(y_salarial)
save "$processed/casen_clean.dta", replace
*/

* 5. Edit analysis script
doedit scripts/02_analysis.do

/* In 02_analysis.do:
use "$processed/casen_clean.dta", clear
reghdfe log_ingreso salario_minimo, absorb(region year) cluster(comuna)
estimates store model1
esttab using "$tables/regression.tex", replace
*/

* 6. Run everything
do main.do

* 7. Edit LaTeX paper
* Open writing/main.tex in Overleaf

* 8. Commit to GitHub
shell git add .
shell git commit -m "Completed analysis"
shell git push

* 9. View results
dir results/tables
dir results/figures

* 10. Share repository
shell gh repo view --web
```

---

## 🆘 Troubleshooting

### GitHub Integration Issues

**Problem**: `gh: command not found`

**Solution**:
1. Install GitHub CLI from https://cli.github.com/
2. Authenticate: `gh auth login`
3. Retry projectinit

**Problem**: `fatal: not a git repository`

**Solution**: Navigate to project folder first
```stata
cd "C:/Projects/MyProject"
shell git status
```

### LaTeX Compilation Issues

**Problem**: Package not found

**Solution**: Use full TeX distribution (MikTeX or TeX Live)

**Problem**: Figures not showing

**Solution**: Use relative paths in LaTeX:
```latex
\includegraphics[width=0.8\textwidth]{figures/figure1.pdf}
```

### Path Issues

**Problem**: File not found

**Solution**: Check paths with:
```stata
do main.do
display "$raw"
display "$processed"
```

---

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md)

---

## 📄 License

MIT License - see [LICENSE](LICENSE)

---

## 📚 References

- [AEA Data and Code Availability Policy](https://www.aeaweb.org/journals/data/data-code-policy)
- [JPAL Research Resources](https://www.povertyactionlab.org/research-resources)
- [Gentzkow & Shapiro (2014) - Code and Data Guide](https://web.stanford.edu/~gentzkow/research/CodeAndData.pdf)

---

## ✨ Citation

```bibtex
@software{projectinit2025,
  author = {Maykol Medrano},
  title = {projectinit v2.0: Professional Stata Project Initializer},
  version = {2.0.0},
  year = {2025},
  url = {https://github.com/MaykolMedrano/projectinit}
}
```

---

## 📧 Contact

- **Issues**: [GitHub Issues](https://github.com/MaykolMedrano/projectinit/issues)
- **Discussions**: [GitHub Discussions](https://github.com/MaykolMedrano/projectinit/discussions)
- **Author**: Maykol Medrano
- **Email**: mmedrano2@uc.cl

---

**Made with ❤️ for reproducible research in Latin America**

*Optimized for Chilean and Peruvian microdata analysis*
