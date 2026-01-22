# projectinit

**Professional Stata Project Structure Initializer**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Stata](https://img.shields.io/badge/Stata-14%2B-blue)](https://www.stata.com/)

A Stata package that creates standardized, reproducible research project structures following **AEA** (American Economic Association), **JPAL** (Abdul Latif Jameel Poverty Action Lab), and **MIT** best practices.

---

## 🎯 Features

- **One-command setup**: Create complete project structure instantly
- **AEA/JPAL/MIT standards**: Follows journal reproducibility requirements
- **Automated configuration**: Generates all necessary config files and templates
- **Replication-ready**: Optional replication package generation
- **Cross-platform**: Works on Windows, macOS, and Linux
- **Well-documented**: Comprehensive help files and README templates

---

## 📦 Installation

### Option 1: Direct Installation (Recommended)

```stata
* Install from GitHub (once published)
net install projectinit, from("https://raw.githubusercontent.com/MaykolMedrano/projectinit/main/")
```

### Option 2: Manual Installation

1. Download the repository files
2. Copy `projectinit.ado` and `projectinit.sthlp` to your Stata ado directory:
   - **Windows**: `C:\ado\plus\p\`
   - **Mac**: `~/Library/Application Support/Stata/ado/plus/p/`
   - **Linux**: `~/.stata/ado/plus/p/`

3. Verify installation:
```stata
which projectinit
help projectinit
```

### Option 3: Local Installation

```stata
* From the projectinit directory
cd "C:/path/to/projectinit"
do projectinit_install.do
```

---

## 🚀 Quick Start

### Basic Usage

```stata
projectinit "MyProject", root("C:/Research")
```

This creates:
```
C:/Research/MyProject/
├── _config.do
├── master.do
├── run_all.do
├── README.md
├── .gitignore
├── 00_docs/
├── 01_data/
│   ├── raw/
│   ├── external/
│   ├── intermediate/
│   └── final/
├── 02_code/
│   ├── 00_setup/
│   ├── 01_cleaning/
│   ├── 02_analysis/
│   ├── 03_figures/
│   └── 04_tables/
├── 03_output/
│   ├── figures/
│   ├── tables/
│   └── logs/
├── temp/
└── data_backup/
```

### With Replication Package

```stata
projectinit "MyProject", root("C:/Research") replicate
```

Adds:
```
04_replication/
├── code/
├── data/
├── output/
├── replication.do
└── README_REPLICATION.md
```

---

## 📚 Usage Examples

### Example 1: Standard Research Project

```stata
* Create project
projectinit "ImpactEvaluation", root("D:/Projects")

* Navigate and start working
cd "D:/Projects/ImpactEvaluation"

* Edit configuration
doedit _config.do

* Run project
do master.do
```

### Example 2: Project with Replication Package

```stata
* Create project with replication structure
projectinit "ClimatePolicy", root("C:/Research") replicate verbose

* Check what was created
cd "C:/Research/ClimatePolicy"
dir
```

### Example 3: Overwrite Existing Project

```stata
* Recreate project structure
projectinit "OldProject", root("C:/Research") overwrite
```

### Example 4: Linux/Mac Usage

```stata
projectinit "RCT_Analysis", root("/home/user/research")
```

---

## 📖 Project Structure Explained

### Main Directories

| Directory | Purpose |
|-----------|---------|
| `00_docs/` | Documentation, papers, presentations |
| `01_data/` | All data files (organized by processing stage) |
| `02_code/` | All analysis code (organized by stage) |
| `03_output/` | Generated figures, tables, and logs |
| `04_replication/` | Self-contained replication package (optional) |
| `temp/` | Temporary files (not tracked by git) |
| `data_backup/` | Backup location for important data |

### Data Workflow

```
raw/ → cleaning → intermediate/ → analysis → final/
```

- **raw/**: Original, immutable data files
- **external/**: Data from external sources
- **intermediate/**: Cleaned and processed data
- **final/**: Final datasets used in analysis

### Code Workflow

```
00_setup → 01_cleaning → 02_analysis → 03_figures → 04_tables
```

Each stage has its own folder with template do-files.

### Key Files

| File | Purpose |
|------|---------|
| `_config.do` | Global paths configuration (edit this first!) |
| `master.do` | Main execution file with manual control |
| `run_all.do` | Automated execution of all scripts |
| `00_setup.do` | Environment setup and package installation |

---

## 🔧 Configuration

### 1. Update Paths

After creating a project, edit `_config.do`:

```stata
* Update this line to your local path
global ROOT "C:/Research/MyProject"
```

All other paths are automatically configured relative to `ROOT`.

### 2. Add Required Packages

Edit `02_code/00_setup/00_setup.do`:

```stata
* Add required packages
local packages "estout reghdfe ftools ivreg2"
```

Packages are automatically installed when you run the project.

### 3. Set Random Seed

For reproducibility, update in `00_setup.do`:

```stata
set seed 123456789  * Use your preferred seed
```

---

## 🎯 Workflow

### Typical Research Workflow

1. **Initialize project**
   ```stata
   projectinit "MyProject", root("C:/Research")
   cd "C:/Research/MyProject"
   ```

2. **Configure**
   ```stata
   doedit _config.do  * Update ROOT path
   doedit 02_code/00_setup/00_setup.do  * Add packages
   ```

3. **Add data**
   - Place raw data in `01_data/raw/`

4. **Write code**
   ```stata
   doedit 02_code/01_cleaning/00_clean.do
   doedit 02_code/02_analysis/00_analysis.do
   doedit 02_code/03_figures/00_figures.do
   doedit 02_code/04_tables/00_tables.do
   ```

5. **Execute**
   ```stata
   do master.do  * Manual execution
   * OR
   do run_all.do  * Automated execution
   ```

6. **Check outputs**
   - Figures: `03_output/figures/`
   - Tables: `03_output/tables/`
   - Logs: `03_output/logs/`

---

## 📋 Best Practices

### For Reproducibility

- ✅ **Never modify raw data** - Keep `01_data/raw/` unchanged
- ✅ **Use relative paths** - Always use globals from `_config.do`
- ✅ **Set random seeds** - Ensures reproducible results
- ✅ **Document dependencies** - List all packages in `00_setup.do`
- ✅ **Save execution logs** - Scripts automatically create logs
- ✅ **Version control** - Use git to track code changes
- ✅ **Linear workflow** - Code executes sequentially (00 → 04)

### For Collaboration

- 📝 Keep README.md updated
- 💬 Comment your code thoroughly
- 🔄 Use consistent naming conventions
- 📊 Document all data sources
- 🧪 Test replication package before submission

### For AEA Compliance

When preparing for journal submission:

1. **Complete replication package**
   ```stata
   projectinit "Paper", root("C:/Submission") replicate
   ```

2. **Update replication README**
   - Edit `04_replication/README_REPLICATION.md`
   - Document all data sources
   - List system requirements
   - Provide expected runtime

3. **Test replication**
   ```stata
   cd "C:/Submission/Paper/04_replication"
   do replication.do
   ```

4. **Verify outputs match paper**

---

## 🔍 Command Reference

### Syntax

```stata
projectinit projectname, root(string) [options]
```

### Required Arguments

- `projectname` - Name of the project (will be folder name)
- `root(string)` - Parent directory where project will be created

### Options

| Option | Description |
|--------|-------------|
| `overwrite` | Overwrite existing project folder |
| `replicate` | Create replication package structure |
| `verbose` | Display detailed output during creation |
| `template(string)` | Use custom template (future feature) |

### Stored Results

```stata
r(projname)   * Project name
r(mainpath)   * Full path to project
r(created)    * Status: "success"
```

---

## 🧪 Testing

### Test Installation

```stata
* Check command is available
which projectinit

* View help file
help projectinit

* Test with example project
projectinit "TestProject", root("C:/Temp") verbose
```

### Verify Project Creation

```stata
* Navigate to project
cd "C:/Temp/TestProject"

* Check structure
dir

* Test configuration
do _config.do

* Run setup
do 02_code/00_setup/00_setup.do
```

---

## 📝 Examples

### Complete Research Project Example

```stata
* 1. Create project with replication package
projectinit "MinimumWage_RDD", root("C:/Research") replicate

* 2. Navigate to project
cd "C:/Research/MinimumWage_RDD"

* 3. Configure paths
doedit _config.do
* Update: global ROOT "C:/Research/MinimumWage_RDD"

* 4. Add required packages to setup
doedit 02_code/00_setup/00_setup.do
* Add: local packages "estout reghdfe ftools rdrobust rddensity"

* 5. Place raw data
copy "C:/RawData/wages.dta" "01_data/raw/wages.dta"

* 6. Write cleaning code
doedit 02_code/01_cleaning/00_clean.do

* 7. Write analysis code
doedit 02_code/02_analysis/00_analysis.do

* 8. Generate figures and tables
doedit 02_code/03_figures/00_figures.do
doedit 02_code/04_tables/00_tables.do

* 9. Run entire project
do run_all.do

* 10. Check outputs
dir 03_output/figures
dir 03_output/tables
```

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines.

---

## 📄 License

This project is licensed under the MIT License - see [LICENSE](LICENSE) file for details.

---

## 📚 References

This package implements standards from:

- [AEA Data and Code Availability Policy](https://www.aeaweb.org/journals/data/data-code-policy)
- [JPAL Research Resources](https://www.povertyactionlab.org/research-resources)
- Gentzkow, M., & Shapiro, J. M. (2014). *Code and Data for the Social Sciences: A Practitioner's Guide*. [Link](https://web.stanford.edu/~gentzkow/research/CodeAndData.pdf)

---

## 🙋 FAQ

### Q: What version of Stata do I need?
**A:** Stata 14.0 or higher. The package has been tested on Stata 14-18.

### Q: Can I customize the folder structure?
**A:** The current version uses a fixed structure. Custom templates are planned for future releases.

### Q: What if I already have a project?
**A:** Use the `overwrite` option carefully, or manually adopt elements you need.

### Q: How do I share my project with collaborators?
**A:** Use git for code. Share data separately. Collaborators only need to update the `ROOT` path in `_config.do`.

### Q: Does this work with Stata projects in other languages?
**A:** Yes! All documentation and comments can be edited. The structure is language-agnostic.

### Q: How do I prepare for AEA submission?
**A:** Use the `replicate` option, complete all documentation in `04_replication/README_REPLICATION.md`, and test that `replication.do` runs successfully on a clean machine.

---

## 📧 Contact

- **Author**: Maykol Medrano
- **Email**: mmedrano2@uc.cl
- **GitHub**: https://github.com/MaykolMedrano

---

## 🐛 Bug Reports

Please report bugs by opening an issue on GitHub with:
- Your Stata version
- Operating system
- Full command you ran
- Error message
- Expected vs actual behavior

---

## 📧 Contact

- **Issues**: [GitHub Issues](https://github.com/MaykolMedrano/projectinit/issues)
- **Discussions**: [GitHub Discussions](https://github.com/MaykolMedrano/projectinit/discussions)

---

## 🌟 Citation

If you use **projectinit** in your research, please cite:

```
@software{projectinit2025,
  author = {Maykol Medrano},
  title = {projectinit: Professional Stata Project Structure Initializer},
  year = {2025},
  url = {https://github.com/MaykolMedrano/projectinit}
}
```

---

## ✨ Acknowledgments

Developed following best practices from:
- American Economic Association
- Abdul Latif Jameel Poverty Action Lab (JPAL)
- MIT Department of Economics
- Code and Data for the Social Sciences (Gentzkow & Shapiro)

---

**Made with ❤️ for reproducible research**
