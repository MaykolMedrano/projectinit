*! certify_projectinit.do - Certification script for projectinit v2.1.0
*! Author: Maykol Medrano
*! Email: mmedrano2@uc.cl
*! Date: 22jan2026
*! Purpose: SSC certification testing for projectinit package

/*==============================================================================
CERTIFICATION SCRIPT FOR PROJECTINIT
==============================================================================

This script tests all major functionality of projectinit for SSC compliance.

Tests covered:
  1. Basic project creation (minimal options)
  2. Verbose mode
  3. LaTeX standard template
  4. LaTeX PUC template
  5. Replication package
  6. Spanish language option
  7. Custom author and email
  8. All options combined
  9. Error handling: invalid root path
  10. Error handling: missing required option
  11. Overwrite protection
  12. Overwrite flag functionality
  13. Stored results verification
  14. Directory structure verification

==============================================================================*/

clear all
set more off
version 14.0

// Initialize test counters
local test_num = 0
local tests_passed = 0
local tests_failed = 0

// Create temporary directory for tests
tempfile testmarker
local testroot = substr("`testmarker'", 1, strlen("`testmarker'") - strlen("testmarker.tmp"))
local testroot "`testroot'projectinit_certification_tests"

display as result "{hline 78}"
display as result "PROJECTINIT v2.1.0 - SSC CERTIFICATION TESTING"
display as result "{hline 78}"
display as text "Test directory: `testroot'"
display as result "{hline 78}"
display ""

// Clean up any previous test runs
capture rmdir "`testroot'"
capture mkdir "`testroot'"

//==============================================================================
// TEST 1: Basic project creation (minimal options)
//==============================================================================
local ++test_num
display as result "{hline 78}"
display as result "TEST `test_num': Basic project creation (minimal options)"
display as result "{hline 78}"

capture noisily projectinit "Test_Basic", root("`testroot'")

if _rc == 0 {
    // Verify essential files and folders exist
    capture confirm file "`testroot'/Test_Basic/run.do"
    local run_exists = (_rc == 0)

    capture confirm file "`testroot'/Test_Basic/00_setup.do"
    local setup_exists = (_rc == 0)

    capture confirm file "`testroot'/Test_Basic/README.md"
    local readme_exists = (_rc == 0)

    capture confirm file "`testroot'/Test_Basic/.gitignore"
    local gitignore_exists = (_rc == 0)

    if `run_exists' & `setup_exists' & `readme_exists' & `gitignore_exists' {
        display as result "  [PASS] Basic project created successfully with all essential files"
        local ++tests_passed
    }
    else {
        display as error "  [FAIL] Missing essential files"
        local ++tests_failed
    }
}
else {
    display as error "  [FAIL] Command returned error code `=_rc'"
    local ++tests_failed
}

display ""

//==============================================================================
// TEST 2: Verbose mode
//==============================================================================
local ++test_num
display as result "{hline 78}"
display as result "TEST `test_num': Verbose mode output"
display as result "{hline 78}"

capture noisily projectinit "Test_Verbose", root("`testroot'") verbose

if _rc == 0 {
    display as result "  [PASS] Verbose mode executed successfully"
    local ++tests_passed
}
else {
    display as error "  [FAIL] Verbose mode returned error code `=_rc'"
    local ++tests_failed
}

display ""

//==============================================================================
// TEST 3: LaTeX standard template
//==============================================================================
local ++test_num
display as result "{hline 78}"
display as result "TEST `test_num': LaTeX standard template generation"
display as result "{hline 78}"

capture noisily projectinit "Test_LaTeX_Standard", root("`testroot'") latex(standard)

if _rc == 0 {
    capture confirm file "`testroot'/Test_LaTeX_Standard/04_Writing/main.tex"
    local main_exists = (_rc == 0)

    capture confirm file "`testroot'/Test_LaTeX_Standard/04_Writing/preamble.tex"
    local preamble_exists = (_rc == 0)

    capture confirm file "`testroot'/Test_LaTeX_Standard/04_Writing/references.bib"
    local bib_exists = (_rc == 0)

    if `main_exists' & `preamble_exists' & `bib_exists' {
        display as result "  [PASS] LaTeX standard template created with all files"
        local ++tests_passed
    }
    else {
        display as error "  [FAIL] Missing LaTeX template files"
        local ++tests_failed
    }
}
else {
    display as error "  [FAIL] LaTeX standard option returned error code `=_rc'"
    local ++tests_failed
}

display ""

//==============================================================================
// TEST 4: LaTeX PUC template
//==============================================================================
local ++test_num
display as result "{hline 78}"
display as result "TEST `test_num': LaTeX PUC template generation"
display as result "{hline 78}"

capture noisily projectinit "Test_LaTeX_PUC", root("`testroot'") latex(puc)

if _rc == 0 {
    capture confirm file "`testroot'/Test_LaTeX_PUC/04_Writing/main.tex"
    if _rc == 0 {
        // Verify PUC-specific formatting in main.tex
        tempname fh
        file open `fh' using "`testroot'/Test_LaTeX_PUC/04_Writing/main.tex", read
        file read `fh' line
        local has_puc = 0
        while r(eof) == 0 {
            if strpos("`line'", "9pt") > 0 | strpos("`line'", "a4paper") > 0 {
                local has_puc = 1
            }
            file read `fh' line
        }
        file close `fh'

        if `has_puc' {
            display as result "  [PASS] LaTeX PUC template created with institutional formatting"
            local ++tests_passed
        }
        else {
            display as error "  [FAIL] PUC template missing institutional formatting"
            local ++tests_failed
        }
    }
    else {
        display as error "  [FAIL] PUC main.tex file not created"
        local ++tests_failed
    }
}
else {
    display as error "  [FAIL] LaTeX PUC option returned error code `=_rc'"
    local ++tests_failed
}

display ""

//==============================================================================
// TEST 5: Replication package
//==============================================================================
local ++test_num
display as result "{hline 78}"
display as result "TEST `test_num': AEA replication package generation"
display as result "{hline 78}"

capture noisily projectinit "Test_Replication", root("`testroot'") replicate

if _rc == 0 {
    capture confirm file "`testroot'/Test_Replication/06_Replication/README_REPLICATION.md"
    if _rc == 0 {
        display as result "  [PASS] Replication package created with README_REPLICATION.md"
        local ++tests_passed
    }
    else {
        display as error "  [FAIL] README_REPLICATION.md not created"
        local ++tests_failed
    }
}
else {
    display as error "  [FAIL] Replicate option returned error code `=_rc'"
    local ++tests_failed
}

display ""

//==============================================================================
// TEST 6: Spanish language option
//==============================================================================
local ++test_num
display as result "{hline 78}"
display as result "TEST `test_num': Spanish language template"
display as result "{hline 78}"

capture noisily projectinit "Test_Spanish", root("`testroot'") language(es)

if _rc == 0 {
    // Verify Spanish content in setup file
    capture confirm file "`testroot'/Test_Spanish/00_setup.do"
    if _rc == 0 {
        tempname fh
        file open `fh' using "`testroot'/Test_Spanish/00_setup.do", read
        file read `fh' line
        local has_spanish = 0
        while r(eof) == 0 {
            if strpos("`line'", "Configuración") > 0 | strpos("`line'", "Proyecto") > 0 {
                local has_spanish = 1
            }
            file read `fh' line
        }
        file close `fh'

        if `has_spanish' {
            display as result "  [PASS] Spanish language template created successfully"
            local ++tests_passed
        }
        else {
            display as error "  [FAIL] Spanish content not found in generated files"
            local ++tests_failed
        }
    }
    else {
        display as error "  [FAIL] Setup file not created"
        local ++tests_failed
    }
}
else {
    display as error "  [FAIL] Language(es) option returned error code `=_rc'"
    local ++tests_failed
}

display ""

//==============================================================================
// TEST 7: Custom author and email
//==============================================================================
local ++test_num
display as result "{hline 78}"
display as result "TEST `test_num': Custom author and email metadata"
display as result "{hline 78}"

capture noisily projectinit "Test_Author", root("`testroot'") ///
    author("Jane Doe") email("jane@example.com")

if _rc == 0 {
    // Verify author in README
    capture confirm file "`testroot'/Test_Author/README.md"
    if _rc == 0 {
        tempname fh
        file open `fh' using "`testroot'/Test_Author/README.md", read
        file read `fh' line
        local has_author = 0
        while r(eof) == 0 {
            if strpos("`line'", "Jane Doe") > 0 {
                local has_author = 1
            }
            file read `fh' line
        }
        file close `fh'

        if `has_author' {
            display as result "  [PASS] Custom author/email metadata applied"
            local ++tests_passed
        }
        else {
            display as error "  [FAIL] Author metadata not found in README"
            local ++tests_failed
        }
    }
}
else {
    display as error "  [FAIL] Author/email options returned error code `=_rc'"
    local ++tests_failed
}

display ""

//==============================================================================
// TEST 8: All options combined
//==============================================================================
local ++test_num
display as result "{hline 78}"
display as result "TEST `test_num': All options combined (stress test)"
display as result "{hline 78}"

capture noisily projectinit "Test_Full", root("`testroot'") ///
    latex(standard) ///
    replicate ///
    language(en) ///
    author("Test Author") ///
    email("test@test.com") ///
    verbose

if _rc == 0 {
    // Verify multiple components exist
    capture confirm file "`testroot'/Test_Full/04_Writing/main.tex"
    local latex_ok = (_rc == 0)

    capture confirm file "`testroot'/Test_Full/06_Replication/README_REPLICATION.md"
    local repl_ok = (_rc == 0)

    capture confirm file "`testroot'/Test_Full/run.do"
    local run_ok = (_rc == 0)

    if `latex_ok' & `repl_ok' & `run_ok' {
        display as result "  [PASS] All options combined successfully"
        local ++tests_passed
    }
    else {
        display as error "  [FAIL] Some components missing in full configuration"
        local ++tests_failed
    }
}
else {
    display as error "  [FAIL] Combined options returned error code `=_rc'"
    local ++tests_failed
}

display ""

//==============================================================================
// TEST 9: Error handling - invalid root path
//==============================================================================
local ++test_num
display as result "{hline 78}"
display as result "TEST `test_num': Error handling - invalid root path"
display as result "{hline 78}"

capture noisily projectinit "Test_BadRoot", root("/this/path/does/not/exist/anywhere")

if _rc != 0 {
    display as result "  [PASS] Correctly rejected invalid root path (error code `=_rc')"
    local ++tests_passed
}
else {
    display as error "  [FAIL] Should have failed with invalid root path"
    local ++tests_failed
}

display ""

//==============================================================================
// TEST 10: Error handling - missing required option
//==============================================================================
local ++test_num
display as result "{hline 78}"
display as result "TEST `test_num': Error handling - missing required root() option"
display as result "{hline 78}"

capture noisily projectinit "Test_NoRoot"

if _rc != 0 {
    display as result "  [PASS] Correctly required root() option (error code `=_rc')"
    local ++tests_passed
}
else {
    display as error "  [FAIL] Should have failed without root() option"
    local ++tests_failed
}

display ""

//==============================================================================
// TEST 11: Overwrite protection
//==============================================================================
local ++test_num
display as result "{hline 78}"
display as result "TEST `test_num': Overwrite protection (existing project)"
display as result "{hline 78}"

// Create a project first
capture noisily projectinit "Test_Overwrite", root("`testroot'")

// Try to create again without overwrite flag
capture noisily projectinit "Test_Overwrite", root("`testroot'")

if _rc != 0 {
    display as result "  [PASS] Correctly prevented overwriting existing project (error code `=_rc')"
    local ++tests_passed
}
else {
    display as error "  [FAIL] Should have prevented overwrite without flag"
    local ++tests_failed
}

display ""

//==============================================================================
// TEST 12: Overwrite flag functionality
//==============================================================================
local ++test_num
display as result "{hline 78}"
display as result "TEST `test_num': Overwrite flag functionality"
display as result "{hline 78}"

capture noisily projectinit "Test_Overwrite", root("`testroot'") overwrite

if _rc == 0 {
    display as result "  [PASS] Overwrite flag allowed project recreation"
    local ++tests_passed
}
else {
    display as error "  [FAIL] Overwrite flag should have succeeded (error code `=_rc')"
    local ++tests_failed
}

display ""

//==============================================================================
// TEST 13: Stored results verification
//==============================================================================
local ++test_num
display as result "{hline 78}"
display as result "TEST `test_num': Stored results (r() macros and scalars)"
display as result "{hline 78}"

capture noisily projectinit "Test_Returns", root("`testroot'")

if _rc == 0 {
    // Check for stored results
    local has_results = 0

    if "`r(project_name)'" == "Test_Returns" {
        local has_results = 1
    }

    if "`r(project_path)'" != "" {
        local has_results = `has_results' + 1
    }

    if `r(N_folders)' > 0 {
        local has_results = `has_results' + 1
    }

    if `has_results' >= 3 {
        display as result "  [PASS] Stored results available (project_name, project_path, N_folders)"
        local ++tests_passed
    }
    else {
        display as error "  [FAIL] Some stored results missing"
        local ++tests_failed
    }
}
else {
    display as error "  [FAIL] Command failed (error code `=_rc')"
    local ++tests_failed
}

display ""

//==============================================================================
// TEST 14: Directory structure verification
//==============================================================================
local ++test_num
display as result "{hline 78}"
display as result "TEST `test_num': Complete directory structure"
display as result "{hline 78}"

capture noisily projectinit "Test_Structure", root("`testroot'")

if _rc == 0 {
    // Verify all standard folders
    local dirs "01_Data 02_Scripts 03_Outputs 04_Writing 05_Admin"
    local all_exist = 1

    foreach dir of local dirs {
        capture confirm file "`testroot'/Test_Structure/`dir'/nul"
        if _rc != 0 {
            display as error "  Missing directory: `dir'"
            local all_exist = 0
        }
    }

    if `all_exist' {
        display as result "  [PASS] Complete directory structure created"
        local ++tests_passed
    }
    else {
        display as error "  [FAIL] Some directories missing"
        local ++tests_failed
    }
}
else {
    display as error "  [FAIL] Command failed (error code `=_rc')"
    local ++tests_failed
}

display ""

//==============================================================================
// CERTIFICATION SUMMARY
//==============================================================================
display as result "{hline 78}"
display as result "CERTIFICATION SUMMARY"
display as result "{hline 78}"
display as text "Total tests run:    " as result `test_num'
display as text "Tests passed:       " as result `tests_passed'
display as text "Tests failed:       " as error `tests_failed'
display as result "{hline 78}"

if `tests_failed' == 0 {
    display as result "STATUS: ALL TESTS PASSED - Package ready for SSC submission"
    display as result "{hline 78}"
}
else {
    display as error "STATUS: CERTIFICATION FAILED - `tests_failed' test(s) need attention"
    display as result "{hline 78}"
    exit 1
}

// Clean up test directory
display ""
display as text "Cleaning up test directory: `testroot'"
capture shell rmdir "`testroot'" /s /q

display as text "Certification complete."
