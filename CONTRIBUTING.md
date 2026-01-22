# Contributing to projectinit

Thank you for your interest in contributing to **projectinit**! This document provides guidelines and instructions for contributing.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Development Setup](#development-setup)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Submitting Changes](#submitting-changes)
- [Reporting Bugs](#reporting-bugs)
- [Feature Requests](#feature-requests)

## 🤝 Code of Conduct

This project adheres to a code of conduct. By participating, you are expected to:

- Be respectful and inclusive
- Accept constructive criticism gracefully
- Focus on what is best for the community
- Show empathy towards other community members

## 🚀 How to Contribute

### Types of Contributions

We welcome several types of contributions:

1. **Bug reports** - Found a bug? Let us know!
2. **Bug fixes** - Fixed a bug? Submit a PR!
3. **Documentation improvements** - Better docs help everyone
4. **Feature requests** - Have an idea? Share it!
5. **Feature implementations** - Built something cool? Contribute it!
6. **Examples** - Share your use cases and workflows

## 🛠️ Development Setup

### Prerequisites

- Stata 14.0 or higher
- Git
- Text editor (VS Code, Sublime Text, or Stata's do-file editor)

### Fork and Clone

1. Fork the repository on GitHub
2. Clone your fork locally:
   ```bash
   git clone https://github.com/MaykolMedrano/projectinit.git
   cd projectinit
   ```

3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/MaykolMedrano/projectinit.git
   ```

### Install for Development

For testing local changes without affecting your main Stata installation:

```stata
* Create a test directory
mkdir "C:/Stata_dev/projectinit_test"

* Copy files to test location
copy projectinit.ado "C:/Stata_dev/projectinit_test/"
copy projectinit.sthlp "C:/Stata_dev/projectinit_test/"

* In Stata, add to adopath temporarily
adopath + "C:/Stata_dev/projectinit_test"

* Test your changes
projectinit "TestProject", root("C:/Temp") verbose
```

## 📝 Coding Standards

### Stata Code Style

Follow these conventions in all `.ado` and `.do` files:

1. **Version declaration**
   ```stata
   version 14.0
   ```

2. **Indentation**
   - Use 4 spaces (not tabs)
   - Indent code blocks consistently

3. **Comments**
   ```stata
   * Single-line comments use asterisk
   // Alternative comment style

   /*
      Multi-line comments
      use this style
   */

   ****************************************************
   * SECTION HEADERS
   ****************************************************
   ```

4. **Variable naming**
   - Use descriptive names
   - Local macros: lowercase with underscores (`local my_variable`)
   - Globals: UPPERCASE (`global ROOT`)

5. **Line length**
   - Keep lines under 120 characters
   - Use `///` for line continuation:
   ```stata
   regress y x1 x2 x3, ///
       robust ///
       cluster(id)
   ```

6. **Error handling**
   ```stata
   capture confirm file "`filepath'"
   if _rc {
       display as error "Error: File not found"
       exit 601
   }
   ```

### Documentation Style

1. **Help files (.sthlp)**
   - Follow Stata's SMCL format
   - Include all sections: syntax, description, options, examples
   - Provide multiple examples covering different use cases

2. **README files**
   - Use clear markdown formatting
   - Include code examples
   - Keep sections organized and scannable

3. **Code comments**
   - Comment WHY, not WHAT (code shows what)
   - Explain complex logic
   - Document assumptions

## 🧪 Testing

### Before Submitting

Test your changes thoroughly:

1. **Fresh installation test**
   ```stata
   * Test on a clean Stata session
   clear all
   which projectinit
   help projectinit
   ```

2. **Basic functionality**
   ```stata
   projectinit "Test1", root("C:/Temp")
   projectinit "Test2", root("C:/Temp") replicate
   projectinit "Test3", root("C:/Temp") verbose
   projectinit "Test4", root("C:/Temp") overwrite
   ```

3. **Error handling**
   ```stata
   * Test error cases
   projectinit "", root("C:/Temp")  * Should fail
   projectinit "Test", root("")      * Should fail
   projectinit "Test", root("C:/Temp")  * Should warn (exists)
   ```

4. **Cross-platform** (if possible)
   - Test on Windows, Mac, and Linux
   - Check path separators work correctly

5. **Generated files**
   - Verify all files are created
   - Check file contents are correct
   - Test that generated do-files run without errors

### Test Checklist

Before submitting a PR, ensure:

- [ ] Code runs without errors on Stata 14+
- [ ] All new features are documented in help file
- [ ] README.md updated if needed
- [ ] Examples added for new features
- [ ] Code follows style guidelines
- [ ] No debug code or personal paths left in
- [ ] Test on Windows (and Mac/Linux if possible)

## 📤 Submitting Changes

### Workflow

1. **Create a branch**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make your changes**
   - Write code following style guidelines
   - Add/update documentation
   - Test thoroughly

3. **Commit your changes**
   ```bash
   git add .
   git commit -m "Add feature: brief description"
   ```

   Commit message format:
   - `Add feature: description` - New features
   - `Fix bug: description` - Bug fixes
   - `Update docs: description` - Documentation
   - `Refactor: description` - Code refactoring

4. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```

5. **Create Pull Request**
   - Go to GitHub and create a PR
   - Describe what you changed and why
   - Reference any related issues
   - Provide testing evidence

### Pull Request Guidelines

Good PR description includes:

```markdown
## Description
Brief description of changes

## Motivation
Why is this change needed?

## Changes Made
- Change 1
- Change 2
- Change 3

## Testing
- Tested on: Windows 10, Stata 17
- Test cases: [list test scenarios]
- All tests pass: Yes/No

## Screenshots (if applicable)
[Add screenshots of output]

## Checklist
- [ ] Code follows style guidelines
- [ ] Documentation updated
- [ ] Tests pass
- [ ] Tested on multiple platforms
```

## 🐛 Reporting Bugs

### Before Reporting

1. Check existing issues to avoid duplicates
2. Test on the latest version
3. Verify it's not a user error

### Bug Report Template

```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce:
1. Run command '...'
2. See error '...'

**Expected behavior**
What you expected to happen.

**Actual behavior**
What actually happened.

**Environment:**
- OS: [e.g., Windows 10, macOS 12]
- Stata version: [e.g., 17]
- projectinit version: [e.g., 1.0.0]

**Additional context**
Error messages, screenshots, etc.
```

## 💡 Feature Requests

We welcome feature ideas! When requesting a feature:

1. **Check existing requests** - Maybe it's already planned
2. **Describe the use case** - Why is this needed?
3. **Provide examples** - How would it work?
4. **Consider scope** - Does it fit the project's goals?

### Feature Request Template

```markdown
**Is your feature request related to a problem?**
A clear description of the problem.

**Describe the solution you'd like**
What you want to happen.

**Describe alternatives you've considered**
Other solutions you've thought about.

**Additional context**
Examples, mockups, etc.
```

## 🎯 Good First Issues

Looking for a place to start? Check issues labeled:
- `good first issue` - Beginner-friendly
- `help wanted` - Need assistance
- `documentation` - Improve docs

## 🔍 Code Review Process

All submissions require review. We look for:

1. **Correctness** - Does it work?
2. **Style** - Follows guidelines?
3. **Tests** - Adequately tested?
4. **Documentation** - Well documented?
5. **Scope** - Focused and appropriate?

## 📚 Resources

### Stata Programming

- [Stata Programming Reference](https://www.stata.com/manuals/u.pdf)
- [Stata Programming Guide by Kit Baum](http://www.stata.com/meeting/germany12/abstracts/desug12_baum.pdf)

### Standards Followed

- [AEA Data and Code Availability Policy](https://www.aeaweb.org/journals/data/data-code-policy)
- [Code and Data for the Social Sciences](https://web.stanford.edu/~gentzkow/research/CodeAndData.pdf)

### Git and GitHub

- [GitHub Flow](https://guides.github.com/introduction/flow/)
- [Git Basics](https://git-scm.com/book/en/v2/Getting-Started-Git-Basics)

## 📬 Questions?

- Open a [GitHub Discussion](https://github.com/MaykolMedrano/projectinit/discussions)
- Check the [FAQ in README](README.md#faq)

## 🙏 Thank You!

Your contributions make **projectinit** better for everyone. Thank you for taking the time to contribute!

---

*This contributing guide is adapted from open source best practices.*
