# Changelog

All notable changes to **projectinit** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2025-12-11

### Added

#### Core Functionality
- Initial release of projectinit
- Complete project structure creation following AEA/JPAL/MIT standards
- Automated folder structure with 15+ directories
- Configuration file (`_config.do`) with global path definitions
- Master execution file (`master.do`)
- Automated execution script (`run_all.do`)

#### Template Files
- Setup script (`00_setup.do`) with package installation
- Data cleaning template (`01_cleaning/00_clean.do`)
- Analysis template (`02_analysis/00_analysis.do`)
- Figure generation template (`03_figures/00_figures.do`)
- Table generation template (`04_tables/00_tables.do`)

#### Replication Support
- Optional replication package structure (`--replicate` flag)
- Replication master script (`replication.do`)
- Replication README with AEA compliance checklist
- Separate replication code, data, and output folders

#### Documentation
- Comprehensive README.md with usage examples
- Stata help file (`.sthlp`) with full documentation
- Quick start guide (QUICKSTART.md)
- Testing guide (TESTING_GUIDE.md) for Windows/Mac/Linux
- Examples guide (EXAMPLES.md) with 6 complete scenarios
- Contributing guidelines (CONTRIBUTING.md)

#### Developer Tools
- Installation script (`projectinit_install.do`)
- Package files for Stata distribution (`.pkg`, `.toc`)
- Git configuration (`.gitignore`)
- MIT License
- Comprehensive test suite

#### Features
- Cross-platform support (Windows, macOS, Linux)
- Verbose mode for detailed output
- Overwrite option for existing projects
- Automatic path validation
- Return values for programmatic use
- Timestamped log files
- Error handling with informative messages

### Technical Details

#### Compatibility
- Stata version: 14.0 or higher
- Tested on: Windows 10/11, macOS 12+, Ubuntu 20.04+
- Works in both Stata GUI and console mode

#### Folder Structure Created
```
ProjectName/
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
├── 04_replication/ (optional)
├── temp/
└── data_backup/
```

### Standards Compliance
- AEA Data and Code Availability Policy
- JPAL Research Resources guidelines
- Code and Data for the Social Sciences (Gentzkow & Shapiro)

---

## [Unreleased]

### Planned Features

#### For Version 1.1.0
- [ ] Custom template support
- [ ] Template library (RCT, RDD, DiD, Panel, IV)
- [ ] Interactive mode for project creation
- [ ] Automatic git initialization option
- [ ] Pre-commit hooks for data protection

#### For Version 1.2.0
- [ ] Integration with OSF (Open Science Framework)
- [ ] Automatic README generation from project metadata
- [ ] Data documentation templates (codebooks)
- [ ] Pre-analysis plan template
- [ ] IRB/ethics documentation structure

#### For Version 2.0.0
- [ ] Multi-language support (R, Python integration)
- [ ] Cloud storage integration (Dropbox, OneDrive, GDrive)
- [ ] Collaboration features (multiple researchers)
- [ ] Automated testing framework
- [ ] CI/CD integration for reproducibility checks

### Under Consideration
- Web-based project generator
- VS Code extension
- Stata 18+ features integration
- Docker container support
- Automated literature review folder
- Grant writing templates

---

## Release Notes

### Version 1.0.0 - Initial Release

This is the first stable release of **projectinit**. The package has been thoroughly tested across multiple platforms and Stata versions.

**Key Highlights:**
- Production-ready project initialization
- Complete AEA/JPAL compliance
- Extensive documentation and examples
- Cross-platform compatibility
- Professional templates following best practices

**Installation:**
```stata
* Manual installation
do projectinit_install.do

* Or copy files to personal ado directory
```

**Basic Usage:**
```stata
projectinit "MyProject", root("C:/Research")
```

**Known Limitations:**
- Template customization not yet available
- No GUI interface
- Manual git initialization required
- Single researcher focus (collaboration features planned)

**Bug Reports:**
Please report any issues on GitHub: https://github.com/MaykolMedrano/projectinit/issues

**Citation:**
```
@software{projectinit2025,
  author = {Maykol Medrano},
  title = {projectinit: Professional Stata Project Structure Initializer},
  version = {1.0.0},
  year = {2025},
  url = {https://github.com/MaykolMedrano/projectinit}
}
```

---

## Maintenance

This changelog is maintained by the projectinit development team. We follow semantic versioning:

- **MAJOR** version: Incompatible API changes
- **MINOR** version: New features (backward compatible)
- **PATCH** version: Bug fixes (backward compatible)

---

## Links

- **Repository**: https://github.com/MaykolMedrano/projectinit
- **Issues**: https://github.com/MaykolMedrano/projectinit/issues
- **Discussions**: https://github.com/MaykolMedrano/projectinit/discussions
- **Documentation**: See README.md

---

**Last Updated**: 2025-12-11
