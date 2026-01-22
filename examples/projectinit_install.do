****************************************************
* PROJECTINIT INSTALLATION SCRIPT
* Version: 1.0.0
* Created: 11dec2025
****************************************************

clear all
set more off

display as text ""
display as text "{hline 70}"
display as text "{bf:projectinit} - Installation Script"
display as text "{hline 70}"
display as text ""

* Get current directory (where installation files are)
local install_dir "`c(pwd)'"

display as text "Installation directory: `install_dir'"
display as text ""

* Check required files exist
local required_files "projectinit.ado projectinit.sthlp"
local missing_files ""

foreach file of local required_files {
    capture confirm file "`install_dir'/`file'"
    if _rc {
        local missing_files "`missing_files' `file'"
    }
}

if "`missing_files'" != "" {
    display as error "Error: Missing required files:"
    display as error "`missing_files'"
    display as error ""
    display as error "Please ensure all files are in the current directory."
    exit 601
}

* Get user's personal ado directory
sysdir
local personal_ado "`c(sysdir_personal)'"

* Check if directory exists, create if not
capture confirm file "`personal_ado'"
if _rc {
    display as text "Creating personal ado directory: `personal_ado'"
    mkdir "`personal_ado'"
}

* Create p subdirectory if it doesn't exist
local p_dir "`personal_ado'p"
capture confirm file "`p_dir'"
if _rc {
    display as text "Creating subdirectory: `p_dir'"
    mkdir "`p_dir'"
}

display as text ""
display as text "Installing projectinit files..."
display as text ""

* Copy files
foreach file of local required_files {
    capture copy "`install_dir'/`file'" "`p_dir'/`file'", replace
    if _rc {
        display as error "  ✗ Failed to copy `file' (error `=_rc')"
        display as error ""
        display as error "Possible issues:"
        display as error "  - Check file permissions"
        display as error "  - Close Stata and try again"
        display as error "  - Manually copy files to: `p_dir'"
        exit _rc
    }
    else {
        display as text "  ✓ Installed: `file'"
    }
}

* Verify installation
display as text ""
display as text "Verifying installation..."

capture which projectinit
if _rc {
    display as error ""
    display as error "Warning: projectinit not found in adopath"
    display as error "You may need to restart Stata"
}
else {
    display as result ""
    display as result "✓ Installation successful!"
}

display as text ""
display as text "{hline 70}"
display as text "Installation complete"
display as text "{hline 70}"
display as text ""
display as text "Files installed to: `p_dir'"
display as text ""
display as text "Next steps:"
display as text "  1. Restart Stata (if verification failed)"
display as text "  2. Try: {bf:help projectinit}"
display as text "  3. Test: {bf:projectinit \"TestProject\", root(\"C:/Temp\")}"
display as text ""
display as text "For documentation, see: README.md"
display as text "For testing, see: TESTING_GUIDE.md"
display as text ""
display as text "{hline 70}"
