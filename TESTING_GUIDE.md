# Testing Guide for projectinit

This guide provides comprehensive instructions for testing the **projectinit** package on different platforms.

---

## 📋 Table of Contents

- [Quick Test](#quick-test)
- [Windows Testing](#windows-testing)
- [macOS Testing](#macos-testing)
- [Linux Testing](#linux-testing)
- [Comprehensive Test Suite](#comprehensive-test-suite)
- [Troubleshooting](#troubleshooting)

---

## 🚀 Quick Test

### Prerequisites

- Stata 14.0 or higher installed
- Write access to a test directory
- `projectinit.ado` and `projectinit.sthlp` files

### 5-Minute Test

```stata
* 1. Check if command is available
which projectinit

* 2. View help
help projectinit

* 3. Create a test project
projectinit "QuickTest", root("C:/Temp") verbose

* 4. Verify it works
cd "C:/Temp/QuickTest"
do _config.do
dir

* 5. Clean up
cd ..
```

✅ **Success criteria**: Project created without errors, all expected files present.

---

## 🪟 Windows Testing

### Environment Setup

1. **Open Stata**
   - Start Stata (GUI or console)
   - Check version: `about`

2. **Install projectinit**

   **Option A: Copy files to personal ado**
   ```stata
   * Find your personal ado directory
   sysdir

   * It will show something like:
   * PERSONAL: C:\ado\personal\

   * Copy projectinit.ado and projectinit.sthlp there
   ```

   **Option B: Use adopath for testing**
   ```stata
   * Add the directory containing projectinit files
   adopath + "C:/path/to/projectinit"

   * Verify
   which projectinit
   ```

### Test Suite for Windows

#### Test 1: Basic Creation

```stata
* Create test directory
mkdir "C:/Temp/projectinit_tests"

* Test basic creation
projectinit "Test_Basic", root("C:/Temp/projectinit_tests")

* Verify
cd "C:/Temp/projectinit_tests/Test_Basic"
dir
```

**Expected output**: All folders created, configuration files present.

#### Test 2: With Replication Package

```stata
projectinit "Test_Replication", ///
    root("C:/Temp/projectinit_tests") ///
    replicate

* Verify replication folder exists
cd "C:/Temp/projectinit_tests/Test_Replication"
dir 04_replication
dir 04_replication/code
```

**Expected output**: Replication folder structure created.

#### Test 3: Verbose Mode

```stata
projectinit "Test_Verbose", ///
    root("C:/Temp/projectinit_tests") ///
    verbose

* Check log output for detailed messages
```

**Expected output**: Detailed creation messages for each folder.

#### Test 4: Overwrite Existing

```stata
* Create initial project
projectinit "Test_Overwrite", root("C:/Temp/projectinit_tests")

* Try to recreate (should fail)
projectinit "Test_Overwrite", root("C:/Temp/projectinit_tests")

* Now overwrite
projectinit "Test_Overwrite", ///
    root("C:/Temp/projectinit_tests") ///
    overwrite
```

**Expected output**:
- Second command fails with error
- Third command succeeds with overwrite message

#### Test 5: Generated Files Work

```stata
cd "C:/Temp/projectinit_tests/Test_Basic"

* Test config file
do _config.do

* Check globals are set
display "$ROOT"
display "$data"
display "$code"
display "$output"

* Test setup file
do 02_code/00_setup/00_setup.do

* Test template files
do 02_code/01_cleaning/00_clean.do
do 02_code/02_analysis/00_analysis.do
do 02_code/03_figures/00_figures.do
do 02_code/04_tables/00_tables.do
```

**Expected output**: All do-files run without errors.

#### Test 6: Paths with Spaces

```stata
* Create directory with spaces
mkdir "C:/Temp/My Projects"

* Test
projectinit "Space Test", root("C:/Temp/My Projects")

* Verify
cd "C:/Temp/My Projects/Space Test"
do _config.do
```

**Expected output**: Works correctly with spaces in path.

#### Test 7: Return Values

```stata
* Run and capture return values
projectinit "Test_Returns", root("C:/Temp/projectinit_tests")

* Check returns
return list
display "`r(projname)'"
display "`r(mainpath)'"
display "`r(created)'"
```

**Expected output**: All return values populated correctly.

### Windows-Specific Tests

#### Test 8: Different Drive Letters

```stata
* If you have D: drive
projectinit "Test_DriveD", root("D:/Projects")

* If you have network drive
projectinit "Test_Network", root("\\\\server\\share\\folder")
```

#### Test 9: UNC Paths

```stata
* Test with UNC path (if available)
projectinit "Test_UNC", root("\\\\server\\research")
```

---

## 🍎 macOS Testing

### Environment Setup

1. **Start Stata**
   ```bash
   # From Terminal
   /Applications/Stata/Stata.app/Contents/MacOS/stata

   # Or open Stata app
   ```

2. **Install projectinit**
   ```stata
   * Personal ado directory
   sysdir

   * Usually: ~/Library/Application Support/Stata/ado/personal/

   * Or add to adopath
   adopath + "~/Documents/projectinit"
   ```

### Test Suite for macOS

#### Test 1: Basic Creation

```stata
* Create test directory
mkdir "/tmp/projectinit_tests"

* Test basic creation
projectinit "Test_Basic", root("/tmp/projectinit_tests")

* Verify
cd "/tmp/projectinit_tests/Test_Basic"
ls
```

#### Test 2: Home Directory (~)

```stata
* Test with ~ expansion
projectinit "Test_Home", root("~/Documents/Research")

* Verify
cd "~/Documents/Research/Test_Home"
pwd
```

#### Test 3: Spaces in Path

```stata
* macOS often has spaces in paths
projectinit "Test_Spaces", root("/Users/username/My Documents")

* Verify
cd "/Users/username/My Documents/Test_Spaces"
do _config.do
```

#### Test 4: Execute All Do-Files

```stata
cd "/tmp/projectinit_tests/Test_Basic"

* Run config
do _config.do

* Run setup
do 02_code/00_setup/00_setup.do

* Run all templates
do 02_code/01_cleaning/00_clean.do
do 02_code/02_analysis/00_analysis.do
do 02_code/03_figures/00_figures.do
do 02_code/04_tables/00_tables.do
```

---

## 🐧 Linux Testing

### Environment Setup

1. **Start Stata**
   ```bash
   # Console mode
   stata

   # Or GUI mode (if installed)
   xstata
   ```

2. **Install projectinit**
   ```stata
   * Personal ado directory
   sysdir

   * Usually: ~/.stata/ado/personal/

   * Or add to adopath
   adopath + "~/projectinit"
   ```

### Test Suite for Linux

#### Test 1: Basic Creation

```stata
* Create test directory
mkdir "/tmp/projectinit_tests"

* Test basic creation
projectinit "Test_Basic", root("/tmp/projectinit_tests")

* Verify
cd "/tmp/projectinit_tests/Test_Basic"
shell ls -la
```

#### Test 2: Home Directory

```stata
* Test with home directory
projectinit "Test_Home", root("~/research")

* Verify
cd "~/research/Test_Home"
shell pwd
```

#### Test 3: Permissions Check

```stata
* Test with restricted permissions
shell mkdir -p /tmp/restricted_test
shell chmod 755 /tmp/restricted_test

projectinit "Test_Perms", root("/tmp/restricted_test")
```

#### Test 4: Case Sensitivity

```stata
* Linux filesystems are case-sensitive
projectinit "TestLower", root("/tmp/projectinit_tests")
projectinit "TESTUPPER", root("/tmp/projectinit_tests")

* Both should create different folders
cd "/tmp/projectinit_tests"
shell ls -l
```

---

## 🧪 Comprehensive Test Suite

### Complete Test Script

Save this as `test_projectinit.do`:

```stata
****************************************************
* COMPREHENSIVE TEST SUITE FOR PROJECTINIT
****************************************************

clear all
set more off

* Adjust this path for your system
local test_root "C:/Temp/projectinit_tests"  // Windows
* local test_root "/tmp/projectinit_tests"    // Mac/Linux

* Create clean test directory
capture mkdir "`test_root'"
cd "`test_root'"

display as text ""
display as text "{hline 70}"
display as text "PROJECTINIT COMPREHENSIVE TEST SUITE"
display as text "{hline 70}"
display as text ""

local test_count = 0
local pass_count = 0
local fail_count = 0

****************************************************
* TEST 1: Basic Creation
****************************************************
local ++test_count
display as text "Test 1: Basic project creation"

capture projectinit "Test01_Basic", root("`test_root'")
if _rc == 0 {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (rc=`=_rc')"
}

****************************************************
* TEST 2: Replication Package
****************************************************
local ++test_count
display as text "Test 2: Project with replication package"

capture projectinit "Test02_Replication", ///
    root("`test_root'") replicate
if _rc == 0 {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (rc=`=_rc')"
}

****************************************************
* TEST 3: Verbose Mode
****************************************************
local ++test_count
display as text "Test 3: Verbose output"

capture projectinit "Test03_Verbose", ///
    root("`test_root'") verbose
if _rc == 0 {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (rc=`=_rc')"
}

****************************************************
* TEST 4: Error - Missing Project Name
****************************************************
local ++test_count
display as text "Test 4: Error handling - missing name"

capture projectinit "", root("`test_root'")
if _rc != 0 {
    local ++pass_count
    display as result "  ✓ PASS (correctly failed)"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (should have failed)"
}

****************************************************
* TEST 5: Error - Existing Project
****************************************************
local ++test_count
display as text "Test 5: Error handling - existing project"

* Create project
quietly projectinit "Test05_Existing", root("`test_root'")

* Try to recreate without overwrite
capture projectinit "Test05_Existing", root("`test_root'")
if _rc != 0 {
    local ++pass_count
    display as result "  ✓ PASS (correctly failed)"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (should have failed)"
}

****************************************************
* TEST 6: Overwrite Existing
****************************************************
local ++test_count
display as text "Test 6: Overwrite existing project"

capture projectinit "Test05_Existing", ///
    root("`test_root'") overwrite
if _rc == 0 {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (rc=`=_rc')"
}

****************************************************
* TEST 7: Config File Works
****************************************************
local ++test_count
display as text "Test 7: Configuration file loads"

capture {
    cd "`test_root'/Test01_Basic"
    do _config.do
    assert "$ROOT" != ""
}
if _rc == 0 {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (rc=`=_rc')"
}

****************************************************
* TEST 8: Setup File Works
****************************************************
local ++test_count
display as text "Test 8: Setup file runs"

capture {
    cd "`test_root'/Test01_Basic"
    do 02_code/00_setup/00_setup.do
}
if _rc == 0 {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (rc=`=_rc')"
}

****************************************************
* TEST 9: Template Files Work
****************************************************
local ++test_count
display as text "Test 9: All template files run"

capture {
    cd "`test_root'/Test01_Basic"
    do 02_code/01_cleaning/00_clean.do
    do 02_code/02_analysis/00_analysis.do
    do 02_code/03_figures/00_figures.do
    do 02_code/04_tables/00_tables.do
}
if _rc == 0 {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (rc=`=_rc')"
}

****************************************************
* TEST 10: Return Values
****************************************************
local ++test_count
display as text "Test 10: Return values set correctly"

projectinit "Test10_Returns", root("`test_root'")
capture {
    assert "`r(projname)'" == "Test10_Returns"
    assert "`r(created)'" == "success"
}
if _rc == 0 {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (rc=`=_rc')"
}

****************************************************
* SUMMARY
****************************************************
display as text ""
display as text "{hline 70}"
display as text "TEST SUMMARY"
display as text "{hline 70}"
display as text "Total tests:  `test_count'"
display as result "Passed:       `pass_count'"
if `fail_count' > 0 {
    display as error "Failed:       `fail_count'"
}
else {
    display as text "Failed:       `fail_count'"
}

local success_rate = round(100 * `pass_count' / `test_count', 0.1)
display as text "Success rate: `success_rate'%"
display as text "{hline 70}"

if `fail_count' == 0 {
    display as result ""
    display as result "✓ ALL TESTS PASSED!"
    display as result ""
}
else {
    display as error ""
    display as error "✗ SOME TESTS FAILED"
    display as error ""
}
```

### Running the Comprehensive Test

```stata
* Run all tests
do test_projectinit.do

* Or copy and paste sections individually
```

---

## 🔧 Troubleshooting

### Common Issues

#### Issue 1: Command Not Found

```stata
* Error: unrecognized command: projectinit
```

**Solutions:**
1. Check installation:
   ```stata
   which projectinit
   ```

2. Add to adopath:
   ```stata
   adopath + "C:/path/to/projectinit"
   ```

3. Verify file location:
   ```stata
   sysdir
   * Files should be in PERSONAL or PLUS directory
   ```

#### Issue 2: Permission Denied

```stata
* Error: Permission denied creating folder
```

**Solutions:**
1. Check write permissions on target directory
2. Try a different location (e.g., `/tmp` on Unix, `C:/Temp` on Windows)
3. Run Stata with appropriate permissions

#### Issue 3: Path Not Found

```stata
* Error: ROOT path not found
```

**Solutions:**
1. Verify root directory exists:
   ```stata
   dir "C:/Research"
   ```

2. Create parent directory first:
   ```stata
   mkdir "C:/Research"
   ```

3. Use absolute paths (not relative)

#### Issue 4: Files Already Exist

```stata
* Error: Project folder already exists
```

**Solutions:**
1. Use `overwrite` option:
   ```stata
   projectinit "MyProject", root("C:/") overwrite
   ```

2. Delete existing folder manually
3. Choose different project name

#### Issue 5: Special Characters in Name

```stata
* Error with special characters
```

**Solutions:**
1. Avoid special characters in project name
2. Use letters, numbers, and underscores only
3. Don't use spaces in project name

---

## ✅ Test Checklist

Use this checklist when testing a new version:

### Functionality Tests
- [ ] Basic project creation works
- [ ] Replication package option works
- [ ] Verbose mode displays extra info
- [ ] Overwrite option works correctly
- [ ] Error handling for invalid inputs
- [ ] Return values are set correctly

### Generated Files Tests
- [ ] _config.do loads without errors
- [ ] master.do runs without errors
- [ ] run_all.do runs without errors
- [ ] 00_setup.do runs without errors
- [ ] All template files run without errors
- [ ] README.md is well-formatted
- [ ] .gitignore contains correct entries

### Platform Tests
- [ ] Works on Windows
- [ ] Works on macOS
- [ ] Works on Linux
- [ ] Handles paths with spaces
- [ ] Handles different drive letters (Windows)
- [ ] Handles UNC paths (Windows)
- [ ] Handles home directory expansion (~)

### Stata Version Tests
- [ ] Works on Stata 14
- [ ] Works on Stata 15
- [ ] Works on Stata 16
- [ ] Works on Stata 17
- [ ] Works on Stata 18

---

## 📊 Expected Test Results

### File Structure Verification

After running `projectinit "TestProject", root("C:/Temp")`, verify:

```
C:/Temp/TestProject/
├── _config.do               ✓ exists
├── master.do                ✓ exists
├── run_all.do               ✓ exists
├── README.md                ✓ exists
├── .gitignore               ✓ exists
├── 00_docs/                 ✓ exists
├── 01_data/
│   ├── raw/                 ✓ exists
│   ├── external/            ✓ exists
│   ├── intermediate/        ✓ exists
│   └── final/               ✓ exists
├── 02_code/
│   ├── 00_setup/
│   │   └── 00_setup.do      ✓ exists
│   ├── 01_cleaning/
│   │   └── 00_clean.do      ✓ exists
│   ├── 02_analysis/
│   │   └── 00_analysis.do   ✓ exists
│   ├── 03_figures/
│   │   └── 00_figures.do    ✓ exists
│   └── 04_tables/
│       └── 00_tables.do     ✓ exists
├── 03_output/
│   ├── figures/             ✓ exists
│   ├── tables/              ✓ exists
│   └── logs/                ✓ exists
├── temp/                    ✓ exists
└── data_backup/             ✓ exists
```

---

## 📝 Logging Test Results

To keep a record of test results:

```stata
* Start log
log using "test_results.log", replace text

* Run tests
do test_projectinit.do

* Close log
log close
```

---

## 🆘 Getting Help

If tests fail:

1. **Check Stata version**: `about`
2. **Check file permissions**: Ensure write access
3. **Review error messages**: Note exact error codes
4. **Consult documentation**: `help projectinit`
5. **Report issues**: Open a GitHub issue with:
   - Stata version
   - Operating system
   - Command that failed
   - Full error message
   - Test log file

---

**Happy Testing! 🧪**
