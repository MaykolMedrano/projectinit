# projectinit - Documentation Index

**Quick navigation guide to all projectinit documentation**

---

## 🚀 New User? Start Here!

1. **[QUICKSTART.md](QUICKSTART.md)** - Get running in 5 minutes
2. **[README.md](README.md)** - Complete user guide
3. Run `help projectinit` in Stata

---

## 📚 Documentation Files

### Core Documentation

| File | Purpose | When to Read |
|------|---------|--------------|
| **[README.md](README.md)** | Complete user guide and reference | First install |
| **[QUICKSTART.md](QUICKSTART.md)** | 5-minute tutorial | First install |
| **[EXAMPLES.md](EXAMPLES.md)** | Real-world usage examples | Starting a project |
| **projectinit.sthlp** | Stata help file | Anytime (via `help projectinit`) |

### Technical Documentation

| File | Purpose | When to Read |
|------|---------|--------------|
| **[TESTING_GUIDE.md](TESTING_GUIDE.md)** | Testing procedures | Before contributing |
| **[CONTRIBUTING.md](CONTRIBUTING.md)** | Contribution guidelines | Before contributing |
| **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** | Complete package overview | For maintainers |
| **[CHANGELOG.md](CHANGELOG.md)** | Version history | Checking updates |

### Installation

| File | Purpose | When to Use |
|------|---------|-------------|
| **projectinit_install.do** | Automated installation | First install |
| **projectinit.pkg** | Package metadata | Net install |
| **stata.toc** | Repository TOC | Net install |

### Testing

| File | Purpose | When to Use |
|------|---------|-------------|
| **test_projectinit.do** | Automated test suite | Testing installation |

### Legal

| File | Purpose |
|------|---------|
| **LICENSE** | MIT License terms |
| **.gitignore** | Git configuration |

---

## 🎯 Find What You Need

### "I want to..."

#### Install projectinit
→ See **[QUICKSTART.md](QUICKSTART.md)** - Installation section
→ Or run `projectinit_install.do`

#### Create my first project
→ See **[QUICKSTART.md](QUICKSTART.md)** - Complete tutorial
→ Or **[README.md](README.md)** - Quick Start section

#### See examples
→ **[EXAMPLES.md](EXAMPLES.md)** has 6 complete scenarios:
- Impact Evaluation (DiD)
- RCT Analysis
- Regression Discontinuity
- Panel Data
- Replication Package
- Multi-Project Portfolio

#### Prepare for AEA submission
→ **[README.md](README.md)** - For AEA Compliance section
→ **[EXAMPLES.md](EXAMPLES.md)** - Example 5: Replication Package

#### Test if it's working
→ **[TESTING_GUIDE.md](TESTING_GUIDE.md)** - Quick Test section
→ Or run `test_projectinit.do`

#### Contribute
→ **[CONTRIBUTING.md](CONTRIBUTING.md)** - Complete guide
→ **[TESTING_GUIDE.md](TESTING_GUIDE.md)** - For testing changes

#### Understand the structure
→ **[README.md](README.md)** - Project Structure section
→ **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Technical specs

#### Fix a problem
→ **[TESTING_GUIDE.md](TESTING_GUIDE.md)** - Troubleshooting section
→ **[README.md](README.md)** - FAQ section

---

## 📖 Reading Order by Role

### For Students/New Researchers

1. [QUICKSTART.md](QUICKSTART.md) - Complete tutorial
2. [README.md](README.md) - Best Practices section
3. [EXAMPLES.md](EXAMPLES.md) - Example 1 or 2
4. Start your project!

### For Experienced Researchers

1. [README.md](README.md) - Quick Start
2. [EXAMPLES.md](EXAMPLES.md) - Relevant example
3. `help projectinit` in Stata
4. [README.md](README.md) - For AEA Compliance (when needed)

### For Instructors

1. [QUICKSTART.md](QUICKSTART.md) - To demonstrate
2. [EXAMPLES.md](EXAMPLES.md) - All examples
3. [README.md](README.md) - Best Practices (to teach)
4. [TESTING_GUIDE.md](TESTING_GUIDE.md) - For student troubleshooting

### For Developers

1. [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Overview
2. [CONTRIBUTING.md](CONTRIBUTING.md) - Guidelines
3. [TESTING_GUIDE.md](TESTING_GUIDE.md) - Test procedures
4. Source code: `projectinit.ado`

### For Package Maintainers

1. [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Complete overview
2. [CHANGELOG.md](CHANGELOG.md) - Version history
3. All other files for updates

---

## 🔍 Quick Reference

### Command Syntax

```stata
projectinit "ProjectName", root("path") [replicate verbose overwrite]
```

### File Locations After Installation

- **Windows**: `C:\ado\plus\p\projectinit.ado`
- **Mac**: `~/Library/Application Support/Stata/ado/plus/p/projectinit.ado`
- **Linux**: `~/.stata/ado/plus/p/projectinit.ado`

### Getting Help

1. **In Stata**: `help projectinit`
2. **Quick start**: [QUICKSTART.md](QUICKSTART.md)
3. **Full guide**: [README.md](README.md)
4. **Examples**: [EXAMPLES.md](EXAMPLES.md)
5. **GitHub Issues**: https://github.com/MaykolMedrano/projectinit/issues

---

## 📊 Documentation Statistics

| Category | Files | Total Size |
|----------|-------|------------|
| Core program | 2 | ~23 KB |
| Installation | 3 | ~5 KB |
| User docs | 4 | ~65 KB |
| Technical docs | 4 | ~50 KB |
| Supporting | 3 | ~3 KB |
| **Total** | **16** | **~146 KB** |

---

## 🗂️ Complete File List

### Essential Files
- `projectinit.ado` - Main program
- `projectinit.sthlp` - Help file

### Documentation
- `README.md` - Main documentation
- `QUICKSTART.md` - Quick start guide
- `EXAMPLES.md` - Usage examples
- `TESTING_GUIDE.md` - Testing procedures
- `CONTRIBUTING.md` - Contribution guide
- `CHANGELOG.md` - Version history
- `PROJECT_SUMMARY.md` - Package overview
- `INDEX.md` - This file

### Installation
- `projectinit_install.do` - Installation script
- `projectinit.pkg` - Package metadata
- `stata.toc` - Repository TOC

### Testing
- `test_projectinit.do` - Test suite

### Supporting
- `LICENSE` - MIT License
- `.gitignore` - Git configuration

---

## 🎓 Learning Path

### Beginner Path (1 hour)

1. **Read** [QUICKSTART.md](QUICKSTART.md) (10 min)
2. **Install** Run `projectinit_install.do` (5 min)
3. **Test** Create first project (10 min)
4. **Tutorial** Complete tutorial in QUICKSTART.md (20 min)
5. **Explore** Browse generated files (15 min)

### Intermediate Path (2 hours)

1. Complete Beginner Path
2. **Read** [README.md](README.md) - Best Practices (15 min)
3. **Study** [EXAMPLES.md](EXAMPLES.md) - Relevant example (30 min)
4. **Apply** Start your own project (45 min)

### Advanced Path (4 hours)

1. Complete Intermediate Path
2. **Study** All examples in [EXAMPLES.md](EXAMPLES.md) (1 hour)
3. **Prepare** Replication package (1 hour)
4. **Test** Full workflow on your data (1 hour)

---

## 💡 Tips for Using This Documentation

### Search Tips

- **Looking for syntax?** → Check README.md or `help projectinit`
- **Need an example?** → Check EXAMPLES.md
- **Error messages?** → Check TESTING_GUIDE.md Troubleshooting
- **Want to contribute?** → Check CONTRIBUTING.md

### Documentation Conventions

- `code snippets` - Stata commands to run
- **bold** - Important terms or files
- *italic* - Emphasis
- → - Indicates a reference or next step
- ✓ ✗ - Pass/Fail indicators in tests

### File Naming

- ALL CAPS `.md` - Documentation files
- lowercase `.ado` - Stata program files
- lowercase `.do` - Stata scripts
- lowercase `.sthlp` - Stata help files

---

## 🔗 External Resources

### Standards
- [AEA Data Policy](https://www.aeaweb.org/journals/data/data-code-policy)
- [JPAL Resources](https://www.povertyactionlab.org/research-resources)
- [Code & Data Guide](https://web.stanford.edu/~gentzkow/research/CodeAndData.pdf)

### Related Tools
- [iefolder](https://github.com/worldbank/iefolder) - World Bank tool
- [ietoolkit](https://github.com/worldbank/ietoolkit) - Impact evaluation
- [datacheck](https://ideas.repec.org/c/boc/bocode/s458060.html) - Data validation

---

## 📞 Support Channels

1. **Documentation** - This index and linked files
2. **Stata Help** - `help projectinit`
3. **GitHub Issues** - Bug reports and features
4. **GitHub Discussions** - Questions and ideas
5. **Email** - For sensitive issues

---

## ✨ Quick Links

- **Installation**: [QUICKSTART.md](QUICKSTART.md#installation)
- **First Project**: [QUICKSTART.md](QUICKSTART.md#create-your-first-project)
- **Examples**: [EXAMPLES.md](EXAMPLES.md)
- **Troubleshooting**: [TESTING_GUIDE.md](TESTING_GUIDE.md#troubleshooting)
- **FAQ**: [README.md](README.md#faq)
- **Contributing**: [CONTRIBUTING.md](CONTRIBUTING.md)

---

**Last Updated**: 2025-12-11
**Version**: 1.0.0
**Status**: Complete Documentation Set

---

*For the most up-to-date information, always check the GitHub repository.*
