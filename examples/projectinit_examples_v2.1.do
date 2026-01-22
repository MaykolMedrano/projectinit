****************************************************
* PROJECTINIT v2.1.0 - COMPREHENSIVE EXAMPLES
* Author: Maykol Medrano
* Email: mmedrano2@uc.cl
* Date: 22jan2026
* Purpose: Demonstrate all features of projectinit
****************************************************

clear all
set more off

display as text ""
display as text "{hline 78}"
display as text "{bf:PROJECTINIT v2.1.0 - COMPREHENSIVE EXAMPLES}"
display as text "{hline 78}"
display as text ""

****************************************************
* CONFIGURE YOUR TEST ROOT DIRECTORY
****************************************************
* Windows example:
local test_root "C:/Temp/projectinit_examples"

* Mac/Linux example (uncomment to use):
* local test_root "/tmp/projectinit_examples"

display as text "Examples will be created in: `test_root'"
display as text ""

* Create test directory
capture mkdir "`test_root'"

****************************************************
* EXAMPLE 1: Basic Project (Minimal Options)
****************************************************
display as result "{hline 78}"
display as result "EXAMPLE 1: Basic Project Creation"
display as result "{hline 78}"
display as text ""
display as text "This creates a minimal project with default settings:"
display as text "  - English language"
display as text "  - Standard folder structure"
display as text "  - No LaTeX, no GitHub, no replication package"
display as text ""

projectinit "Example01_Basic", root("`test_root'")

display as text ""
display as text "Created project at: `test_root'/Example01_Basic"
display as text ""
pause Press any key to continue...

****************************************************
* EXAMPLE 2: Verbose Mode
****************************************************
display as result "{hline 78}"
display as result "EXAMPLE 2: Verbose Mode"
display as result "{hline 78}"
display as text ""
display as text "The verbose option displays detailed progress information:"
display as text "  - System information"
display as text "  - Each folder creation"
display as text "  - Each file generation"
display as text ""

projectinit "Example02_Verbose", root("`test_root'") verbose

display as text ""
pause Press any key to continue...

****************************************************
* EXAMPLE 3: LaTeX Standard Template
****************************************************
display as result "{hline 78}"
display as result "EXAMPLE 3: LaTeX Standard Article Template"
display as result "{hline 78}"
display as text ""
display as text "The latex(standard) option creates:"
display as text "  - 04_Writing/ folder with LaTeX environment"
display as text "  - main.tex (article template)"
display as text "  - preamble.tex (packages and settings)"
display as text "  - macros.tex (for Stata-generated macros)"
display as text "  - references.bib (bibliography)"
display as text "  - Section files (01_introduction.tex, etc.)"
display as text ""

projectinit "Example03_LaTeX_Standard", ///
    root("`test_root'") ///
    latex(standard) ///
    author("Jane Doe") ///
    email("jane@university.edu")

display as text ""
display as text "LaTeX files created in: `test_root'/Example03_LaTeX_Standard/04_Writing"
display as text ""
pause Press any key to continue...

****************************************************
* EXAMPLE 4: LaTeX PUC Template
****************************************************
display as result "{hline 78}"
display as result "EXAMPLE 4: LaTeX PUC Thesis Template"
display as result "{hline 78}"
display as text ""
display as text "The latex(puc) option creates a template for:"
display as text "  - Pontificia Universidad Católica de Chile thesis"
display as text "  - Institutional formatting (9pt, a4paper)"
display as text "  - Complete preamble with UC packages"
display as text "  - Professional academic structure"
display as text ""

projectinit "Example04_LaTeX_PUC", ///
    root("`test_root'") ///
    latex(puc) ///
    language(es) ///
    author("María González") ///
    email("mgonzalez@uc.cl")

display as text ""
display as text "PUC thesis template created in: `test_root'/Example04_LaTeX_PUC/04_Writing"
display as text ""
pause Press any key to continue...

****************************************************
* EXAMPLE 5: AEA Replication Package
****************************************************
display as result "{hline 78}"
display as result "EXAMPLE 5: AEA Data Editor Replication Package"
display as result "{hline 78}"
display as text ""
display as text "The replicate option creates:"
display as text "  - 06_Replication/ folder"
display as text "  - README_REPLICATION.md with AEA requirements"
display as text "  - Data availability statement"
display as text "  - Computational requirements section"
display as text "  - Detailed replication instructions"
display as text ""

projectinit "Example05_Replication", ///
    root("`test_root'") ///
    replicate ///
    author("John Smith") ///
    email("jsmith@econ.edu")

display as text ""
display as text "Replication package created in: `test_root'/Example05_Replication/06_Replication"
display as text ""
pause Press any key to continue...

****************************************************
* EXAMPLE 6: Spanish Language Template
****************************************************
display as result "{hline 78}"
display as result "EXAMPLE 6: Spanish Language Template"
display as result "{hline 78}"
display as text ""
display as text "The language(es) option generates:"
display as text "  - Scripts with Spanish comments"
display as text "  - README.md in Spanish"
display as text "  - Spanish section headings"
display as text ""

projectinit "Example06_Spanish", ///
    root("`test_root'") ///
    language(es) ///
    author("Carlos Rodríguez")

display as text ""
pause Press any key to continue...

****************************************************
* EXAMPLE 7: GitHub Integration
****************************************************
display as result "{hline 78}"
display as result "EXAMPLE 7: GitHub Repository Integration"
display as result "{hline 78}"
display as text ""
display as text "The github() option:"
display as text "  - Initializes a local Git repository"
display as text "  - Creates .gitignore (elite version)"
display as text "  - Attempts to create GitHub repository (requires gh CLI)"
display as text "  - Makes initial commit and pushes to GitHub"
display as text ""
display as text "Options: github(public) or github(private)"
display as text ""
display as text "Note: This example will fail if GitHub CLI is not installed."
display as text "      It will still create the local Git repository."
display as text ""

projectinit "Example07_GitHub", ///
    root("`test_root'") ///
    github(private) ///
    author("Research Team") ///
    email("research@institution.edu")

display as text ""
pause Press any key to continue...

****************************************************
* EXAMPLE 8: Complete Setup (All Options)
****************************************************
display as result "{hline 78}"
display as result "EXAMPLE 8: Complete Professional Setup"
display as result "{hline 78}"
display as text ""
display as text "This example combines all features:"
display as text "  - LaTeX standard template"
display as text "  - AEA replication package"
display as text "  - GitHub integration (private)"
display as text "  - Custom author and email"
display as text "  - Verbose output"
display as text ""

projectinit "Example08_Complete", ///
    root("`test_root'") ///
    latex(standard) ///
    github(private) ///
    replicate ///
    author("Dr. Emily Chen") ///
    email("echen@research.org") ///
    verbose

display as text ""
pause Press any key to continue...

****************************************************
* EXAMPLE 9: Overwrite Existing Project
****************************************************
display as result "{hline 78}"
display as result "EXAMPLE 9: Overwrite Protection and Flag"
display as result "{hline 78}"
display as text ""
display as text "By default, projectinit protects existing projects."
display as text "First, try to recreate Example01_Basic (should fail):"
display as text ""

capture noisily projectinit "Example01_Basic", root("`test_root'")

if _rc != 0 {
    display as result ""
    display as result "Correctly prevented overwriting!"
    display as text ""
    display as text "Now, use the overwrite flag to recreate it:"
    display as text ""

    projectinit "Example01_Basic", root("`test_root'") overwrite
}

display as text ""
pause Press any key to continue...

****************************************************
* EXAMPLE 10: Stored Results (r() macros)
****************************************************
display as result "{hline 78}"
display as result "EXAMPLE 10: Accessing Stored Results"
display as result "{hline 78}"
display as text ""
display as text "After running projectinit, you can access stored results:"
display as text ""

projectinit "Example10_Returns", root("`test_root'")

display as text ""
display as result "Stored Results:"
display as text "{hline 78}"
display as text "Project name:     " as result "`r(project_name)'"
display as text "Project path:     " as result "`r(project_path)'"
display as text "Language:         " as result "`r(language)'"
display as text "LaTeX template:   " as result "`r(latex_template)'"
display as text "GitHub status:    " as result "`r(github_status)'"
display as text "Folders created:  " as result "`r(N_folders)'"
display as text "Files created:    " as result "`r(N_files)'"
display as text "{hline 78}"

display as text ""
pause Press any key to continue...

****************************************************
* EXAMPLE 11: Real-World Research Project
****************************************************
display as result "{hline 78}"
display as result "EXAMPLE 11: Real-World Impact Evaluation Project"
display as result "{hline 78}"
display as text ""
display as text "This example shows a complete setup for an impact evaluation:"
display as text ""

projectinit "Impact-Evaluation-Chile-2026", ///
    root("`test_root'") ///
    latex(standard) ///
    replicate ///
    author("Development Research Team") ///
    email("team@development.org") ///
    verbose

display as text ""
display as text "This creates a publication-ready project structure suitable for:"
display as text "  - J-PAL impact evaluations"
display as text "  - World Bank DIME projects"
display as text "  - AEA journal submissions"
display as text "  - NBER working papers"
display as text ""

pause Press any key to continue...

****************************************************
* EXAMPLE 12: Academic Thesis Project (Spanish)
****************************************************
display as result "{hline 78}"
display as result "EXAMPLE 12: PUC Master's Thesis (Spanish)"
display as result "{hline 78}"
display as text ""
display as text "Complete setup for a master's thesis at UC:"
display as text ""

projectinit "Tesis-Maestria-Economia-2026", ///
    root("`test_root'") ///
    latex(puc) ///
    language(es) ///
    author("Estudiante UC") ///
    email("estudiante@uc.cl") ///
    verbose

display as text ""
display as text "This creates everything needed for a thesis:"
display as text "  - PUC institutional LaTeX template"
display as text "  - Spanish documentation"
display as text "  - Professional folder structure"
display as text "  - Version control ready"
display as text ""

****************************************************
* SUMMARY AND NEXT STEPS
****************************************************
display as text ""
display as result "{hline 78}"
display as result "EXAMPLES COMPLETE!"
display as result "{hline 78}"
display as text ""
display as text "All example projects created in: `test_root'"
display as text ""
display as text "To explore an example:"
display as text `"  1. cd "`test_root'/Example01_Basic""'
display as text "  2. Open README.md for project overview"
display as text "  3. Run: do run.do"
display as text ""
display as text "For help:"
display as text "  help projectinit"
display as text ""
display as text "For documentation:"
display as text "  See README.md in the projectinit package directory"
display as text ""
display as text "To clean up these examples:"
display as text `"  Run: rmdir "`test_root'" /s /q     (Windows)"'
display as text `"  Run: rm -rf "`test_root'"          (Mac/Linux)"'
display as text ""
display as result "{hline 78}"
