****************************************************
* COMPREHENSIVE TEST SUITE FOR PROJECTINIT
* Version: 1.0.0
* Created: 11dec2025
* Purpose: Test all projectinit functionality
****************************************************

clear all
set more off

display as text ""
display as text "{hline 70}"
display as text "{bf:PROJECTINIT COMPREHENSIVE TEST SUITE}"
display as text "Version 1.0.0"
display as text "{hline 70}"
display as text ""

* CONFIGURE TEST LOCATION (CHANGE THIS FOR YOUR SYSTEM)
* Windows:
local test_root "C:/Temp/projectinit_tests"

* Mac/Linux (uncomment to use):
* local test_root "/tmp/projectinit_tests"

display as text "Test directory: `test_root'"
display as text ""

* Create and navigate to test directory
capture mkdir "`test_root'"
cd "`test_root'"

* Initialize counters
local test_count = 0
local pass_count = 0
local fail_count = 0

****************************************************
* TEST 1: Basic Project Creation
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
display as text ""

****************************************************
* TEST 2: Replication Package Option
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
display as text ""

****************************************************
* TEST 3: Verbose Mode
****************************************************
local ++test_count
display as text "Test 3: Verbose output mode"

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
display as text ""

****************************************************
* TEST 4: Error Handling - Missing Project Name
****************************************************
local ++test_count
display as text "Test 4: Error handling - missing project name"

capture projectinit "", root("`test_root'")
if _rc != 0 {
    local ++pass_count
    display as result "  ✓ PASS (correctly rejected empty name)"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (should have rejected empty name)"
}
display as text ""

****************************************************
* TEST 5: Error Handling - Existing Project
****************************************************
local ++test_count
display as text "Test 5: Error handling - existing project without overwrite"

* Create project first
quietly projectinit "Test05_Existing", root("`test_root'")

* Try to recreate without overwrite (should fail)
capture projectinit "Test05_Existing", root("`test_root'")
if _rc != 0 {
    local ++pass_count
    display as result "  ✓ PASS (correctly rejected existing project)"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (should have rejected existing project)"
}
display as text ""

****************************************************
* TEST 6: Overwrite Existing Project
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
display as text ""

****************************************************
* TEST 7: Configuration File Loads
****************************************************
local ++test_count
display as text "Test 7: Configuration file loads without errors"

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
display as text ""

****************************************************
* TEST 8: Setup File Runs
****************************************************
local ++test_count
display as text "Test 8: Setup file runs without errors"

capture {
    cd "`test_root'/Test01_Basic"
    quietly do 02_code/00_setup/00_setup.do
}
if _rc == 0 {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (rc=`=_rc')"
}
display as text ""

****************************************************
* TEST 9: All Template Files Run
****************************************************
local ++test_count
display as text "Test 9: All template do-files run without errors"

capture {
    cd "`test_root'/Test01_Basic"
    quietly do 02_code/01_cleaning/00_clean.do
    quietly do 02_code/02_analysis/00_analysis.do
    quietly do 02_code/03_figures/00_figures.do
    quietly do 02_code/04_tables/00_tables.do
}
if _rc == 0 {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (rc=`=_rc')"
}
display as text ""

****************************************************
* TEST 10: Return Values
****************************************************
local ++test_count
display as text "Test 10: Command returns correct values"

projectinit "Test10_Returns", root("`test_root'")
capture {
    assert "`r(projname)'" == "Test10_Returns"
    assert "`r(created)'" == "success"
    local expected_path "`test_root'/Test10_Returns"
    assert "`r(mainpath)'" == "`expected_path'"
}
if _rc == 0 {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (rc=`=_rc')"
}
display as text ""

****************************************************
* TEST 11: Folder Structure Complete
****************************************************
local ++test_count
display as text "Test 11: All folders created correctly"

local folders ""
local folders `folders' "00_docs"
local folders `folders' "01_data/raw"
local folders `folders' "01_data/external"
local folders `folders' "01_data/intermediate"
local folders `folders' "01_data/final"
local folders `folders' "02_code/00_setup"
local folders `folders' "02_code/01_cleaning"
local folders `folders' "02_code/02_analysis"
local folders `folders' "02_code/03_figures"
local folders `folders' "02_code/04_tables"
local folders `folders' "03_output/figures"
local folders `folders' "03_output/tables"
local folders `folders' "03_output/logs"
local folders `folders' "temp"
local folders `folders' "data_backup"

local folder_check_pass = 1
cd "`test_root'/Test01_Basic"
foreach folder of local folders {
    capture confirm file "`folder'"
    if _rc {
        display as error "    Missing folder: `folder'"
        local folder_check_pass = 0
    }
}

if `folder_check_pass' {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (some folders missing)"
}
display as text ""

****************************************************
* TEST 12: Required Files Created
****************************************************
local ++test_count
display as text "Test 12: All required files created"

local files ""
local files `files' "_config.do"
local files `files' "master.do"
local files `files' "run_all.do"
local files `files' "README.md"
local files `files' ".gitignore"
local files `files' "02_code/00_setup/00_setup.do"
local files `files' "02_code/01_cleaning/00_clean.do"
local files `files' "02_code/02_analysis/00_analysis.do"
local files `files' "02_code/03_figures/00_figures.do"
local files `files' "02_code/04_tables/00_tables.do"

local file_check_pass = 1
cd "`test_root'/Test01_Basic"
foreach file of local files {
    capture confirm file "`file'"
    if _rc {
        display as error "    Missing file: `file'"
        local file_check_pass = 0
    }
}

if `file_check_pass' {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (some files missing)"
}
display as text ""

****************************************************
* TEST 13: Replication Files Created (if applicable)
****************************************************
local ++test_count
display as text "Test 13: Replication package files created"

local repl_check_pass = 1
cd "`test_root'/Test02_Replication"

local repl_items ""
local repl_items `repl_items' "04_replication"
local repl_items `repl_items' "04_replication/code"
local repl_items `repl_items' "04_replication/data"
local repl_items `repl_items' "04_replication/output"
local repl_items `repl_items' "04_replication/replication.do"
local repl_items `repl_items' "04_replication/README_REPLICATION.md"

foreach item of local repl_items {
    capture confirm file "`item'"
    if _rc {
        display as error "    Missing: `item'"
        local repl_check_pass = 0
    }
}

if `repl_check_pass' {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (replication files missing)"
}
display as text ""

****************************************************
* TEST 14: Master Script Runs
****************************************************
local ++test_count
display as text "Test 14: Master script runs (creates actual project)"

* Create a simple test project with data
cd "`test_root'"
quietly projectinit "Test14_FullRun", root("`test_root'")

cd "`test_root'/Test14_FullRun"

* Create minimal test data
quietly {
    clear
    set obs 10
    gen x = _n
    gen y = x + rnormal()
    save "01_data/raw/test_data.dta", replace
}

* Modify cleaning script to actually do something
file open cleanfile using "02_code/01_cleaning/00_clean.do", write replace
file write cleanfile "use \"\$raw/test_data.dta\", clear" _n
file write cleanfile "save \"\$intermediate/test_clean.dta\", replace" _n
file close cleanfile

* Try running master
capture quietly do master.do

if _rc == 0 {
    local ++pass_count
    display as result "  ✓ PASS"
}
else {
    local ++fail_count
    display as error "  ✗ FAIL (rc=`=_rc')"
}
display as text ""

****************************************************
* SUMMARY
****************************************************
cd "`test_root'"

display as text ""
display as text "{hline 70}"
display as text "{bf:TEST SUMMARY}"
display as text "{hline 70}"
display as text ""
display as text "Total tests:  `test_count'"

if `pass_count' > 0 {
    display as result "Passed:       `pass_count'"
}
else {
    display as text "Passed:       `pass_count'"
}

if `fail_count' > 0 {
    display as error "Failed:       `fail_count'"
}
else {
    display as text "Failed:       `fail_count'"
}

local success_rate = round(100 * `pass_count' / `test_count', 0.1)
display as text "Success rate: `success_rate'%"
display as text ""

if `fail_count' == 0 {
    display as result "{hline 70}"
    display as result "✓ ALL TESTS PASSED!"
    display as result "{hline 70}"
    display as result ""
    display as result "projectinit is working correctly on your system."
    display as result ""
    display as result "Test projects created in: `test_root'"
    display as result "You can safely delete this directory if no longer needed."
}
else {
    display as error "{hline 70}"
    display as error "✗ SOME TESTS FAILED"
    display as error "{hline 70}"
    display as error ""
    display as error "Please review the failed tests above."
    display as error "Common issues:"
    display as error "  - Permissions: Check write access to test directory"
    display as error "  - Paths: Ensure test_root is set correctly"
    display as error "  - Installation: Verify projectinit is installed correctly"
    display as error ""
    display as error "For help, see TESTING_GUIDE.md or open an issue on GitHub"
}

display as text ""
display as text "{hline 70}"
display as text ""

* Return to original directory
cd "`c(pwd)'"
