*! version 2.1.0  22dec2025
*! projectinit - Professional Research Project Initializer (Enterprise Grade)
*! Author: Maykol Medrano
*! Email: mmedrano2@uc.cl
*! GitHub: https://github.com/MaykolMedrano/projectinit
*! License: MIT
*! Standards: J-PAL (MIT) | DIME (World Bank) | AEA Data Editor
*! Description: One-click reproducible research infrastructure with LaTeX & GitHub
*! Citation: Please cite if used in published research

/*******************************************************************************
METADATA
================================================================================
Package:     projectinit
Version:     2.1.0
Released:    December 22, 2025
Stata:       14.0+
Platform:    Windows | macOS | Linux
Standards:   J-PAL, DIME, AEA, NBER
Features:    LaTeX integration, GitHub automation, Multi-OS, Dependency mgmt
Changelog:   v2.1.0 - Enhanced with J-PAL/DIME/AEA standards
             v2.0.0 - Added LaTeX and GitHub integration
             v1.0.0 - Initial release
*******************************************************************************/
program drop _all
program define projectinit, rclass
    version 14.0

    syntax anything(name=projname id="Project name"), ///
        ROOT(string)                                  ///
        [OVERwrite                                    ///
         REPLicate                                    ///
         LAng(string)                                 ///
         LAtex(string)                                ///
         GIThub(string)                               ///
         AUthor(string)                               ///
         Email(string)                                ///
         VERBose]

    *---------------------------------------------------------------------------
    * SMCL INTERFACE (Professional UX)
    *---------------------------------------------------------------------------

    di as txt ""
    di as txt "{hline 78}"
    di as result "{bf:projectinit v2.1.0}" as txt " - Enterprise Research Infrastructure"
    di as txt "Standards: {bf:J-PAL (MIT)} | {bf:DIME (World Bank)} | {bf:AEA Data Editor}"
    di as txt "{hline 78}"
    di as txt ""

    *---------------------------------------------------------------------------
    * INPUT VALIDATION (Defensive Programming)
    *---------------------------------------------------------------------------

    * Clean project name
    local projname = trim(`"`projname'"')
    local projname = subinstr(`"`projname'"', `"""', "", .)

    * Security: Validate project name (no special chars, path traversal)
    if regexm("`projname'", "[^a-zA-Z0-9_-]") {
        di as error "{bf:Error:} Invalid project name"
        di as error "Only alphanumeric characters, hyphens, and underscores allowed"
        di as error "Attempted: `projname'"
        exit 198
    }

    if `"`projname'"' == "" {
        di as error "{bf:Error:} Project name cannot be empty"
        exit 198
    }

    * Note: Root path existence will be validated during mkdir attempt
    * We don't validate here because Stata's confirm file is unreliable for directories

    * Set intelligent defaults
    if "`lang'" == "" local lang "en"
    if "`latex'" == "" local latex "none"
    if "`github'" == "" local github "none"
    if "`author'" == "" local author "Maykol Medrano"
    if "`email'" == "" local email "mmedrano2@uc.cl"

    * Validate options
    if !inlist("`lang'", "en", "es") {
        di as error "{bf:Error:} lang() must be 'en' or 'es'"
        exit 198
    }

    if !inlist("`latex'", "none", "puc", "standard") {
        di as error "{bf:Error:} latex() must be 'puc', 'standard', or omitted"
        exit 198
    }

    if !inlist("`github'", "none", "public", "private") {
        di as error "{bf:Error:} github() must be 'public', 'private', or omitted"
        exit 198
    }

    *---------------------------------------------------------------------------
    * OS DETECTION & PATH HANDLING
    *---------------------------------------------------------------------------

    local os = "`c(os)'"
    local pathsep "/"  // Stata handles / on all platforms

    if "`verbose'" != "" {
        di as txt "{bf:System Information:}"
        di as txt "  OS: `os'"
        di as txt "  Stata version: `c(stata_version)'"
        di as txt "  Flavor: `c(flavor)'"
        di as txt "  Machine type: `c(machine_type)'"
        di as txt ""
    }

    *---------------------------------------------------------------------------
    * PROJECT PATH CONSTRUCTION
    *---------------------------------------------------------------------------

    local mainpath = `"`root'`pathsep'`projname'"'

    * Check if project exists
    capture confirm file `"`mainpath'"'
    local exists = (_rc == 0)

    if `exists' & "`overwrite'" == "" {
        di as error "{bf:Error:} Project folder already exists"
        di as error "Location: {it:`mainpath'}"
        di as txt ""
        di as txt "{bf:Solutions:}"
        di as txt "  1. Use {bf:overwrite} option to recreate"
        di as txt "  2. Choose a different project name"
        di as txt "  3. Manually delete the existing folder"
        di as txt ""
        di as txt "Example: {it:projectinit \"`projname'\", root(\"`root'\") overwrite}"
        exit 602
    }

    if `exists' & "`overwrite'" != "" {
        di as txt "{bf:Warning:} Overwriting existing project"
        di as txt "Location: {it:`mainpath'}"
        di as txt ""
    }

    * Test write permissions by attempting to create directory
    capture mkdir `"`mainpath'"'
    if _rc & _rc != 693 {
        di as error "{bf:Error:} Cannot create project directory"
        di as error "Path: `mainpath'"
        di as error "Error code: `=_rc'"
        di as txt ""
        di as txt "{bf:Possible causes:}"
        di as txt "  • Root directory does not exist: `root'"
        di as txt "  • Insufficient write permissions"
        di as txt "  • Path contains invalid characters"
        di as txt "  • Disk is full or write-protected"
        di as txt ""
        di as txt "{bf:Solutions:}"
        di as txt "  1. Create the root directory first: mkdir \"`root'\""
        di as txt "  2. Use an existing directory as root"
        di as txt "  3. Check permissions and try a different location"
        di as txt ""
        di as txt "{bf:Example:} projectinit \"`projname'\", root(\"C:\Users\User\Desktop\")"
        exit _rc
    }

    *---------------------------------------------------------------------------
    * PROJECT INITIALIZATION HEADER
    *---------------------------------------------------------------------------

    di as result "{bf:Initializing Project:} `projname'"
    di as txt "{hline 78}"
    di as txt "Location:     {it:`mainpath'}"
    di as txt "Language:     `lang'"
    di as txt "Author:       `author'"
    di as txt "Email:        `email'"
    if "`latex'" != "none" di as txt "LaTeX:        `latex' template"
    if "`github'" != "none" di as txt "GitHub:       `github' repository"
    if "`replicate'" != "" di as txt "Replication:  Enabled"
    di as txt "{hline 78}"
    di as txt ""

    *---------------------------------------------------------------------------
    * J-PAL/DIME FOLDER STRUCTURE
    *---------------------------------------------------------------------------

    di as txt "{bf:Stage 1/6:} Creating J-PAL/DIME folder structure..."

    local folders ""

    * 01_Data (J-PAL/DIME Standard)
    local folders `folders' "01_Data"
    local folders `folders' "01_Data/Raw"
    local folders `folders' "01_Data/De-identified"
    local folders `folders' "01_Data/Intermediate"
    local folders `folders' "01_Data/Final"

    * 02_Scripts (NBER/J-PAL Standard)
    local folders `folders' "02_Scripts"
    local folders `folders' "02_Scripts/Ados"
    local folders `folders' "02_Scripts/Data_Preparation"
    local folders `folders' "02_Scripts/Analysis"
    local folders `folders' "02_Scripts/Validation"

    * 03_Outputs (AEA Standard)
    local folders `folders' "03_Outputs"
    local folders `folders' "03_Outputs/Tables"
    local folders `folders' "03_Outputs/Figures"
    local folders `folders' "03_Outputs/Logs"
    local folders `folders' "03_Outputs/Raw_Outputs"

    * 04_Writing (LaTeX Environment)
    if "`latex'" != "none" {
        local folders `folders' "04_Writing"
        local folders `folders' "04_Writing/sections"
        local folders `folders' "04_Writing/tables"
        local folders `folders' "04_Writing/figures"
        local folders `folders' "04_Writing/references"
    }

    * 05_Doc (Data Documentation)
    local folders `folders' "05_Doc"
    local folders `folders' "05_Doc/Codebooks"
    local folders `folders' "05_Doc/Questionnaires"
    local folders `folders' "05_Doc/IRB"

    * Replication (AEA Submission)
    if "`replicate'" != "" {
        local folders `folders' "06_Replication"
        local folders `folders' "06_Replication/code"
        local folders `folders' "06_Replication/data"
        local folders `folders' "06_Replication/output"
        local folders `folders' "06_Replication/readme"
    }

    * Create all folders
    local folder_count = 0
    foreach folder of local folders {
        quietly capture mkdir `"`mainpath'/`folder'"'
        if _rc == 0 | _rc == 693 {
            local ++folder_count
            if "`verbose'" != "" {
                di as txt "  {result:✓} `folder'"
            }
        }
        else {
            di as error "  {error:✗} Failed: `folder' (error `=_rc')"
        }
    }

    if "`verbose'" == "" {
        di as result "  ✓ Created `folder_count' directories"
    }
    di as txt ""

    *---------------------------------------------------------------------------
    * GENERATE CORE FILES
    *---------------------------------------------------------------------------

    di as txt "{bf:Stage 2/6:} Generating master scripts..."

    * run.do (Master Script)
    projectinit_run, path(`"`mainpath'"') projname(`"`projname'"') ///
        lang(`lang') author(`"`author'"') email(`"`email'"') os(`os')

    * 00_setup.do (Environment Setup)
    projectinit_setup, path(`"`mainpath'"') lang(`lang') os(`os')

    * .gitignore (Elite Version)
    projectinit_gitignore_elite, path(`"`mainpath'"') latex(`latex')

    * README.md (AEA Standard)
    projectinit_readme_aea, path(`"`mainpath'"') projname(`"`projname'"') ///
        lang(`lang') author(`"`author'"') email(`"`email'"') ///
        latex(`latex') github(`github')

    di as txt ""

    *---------------------------------------------------------------------------
    * LATEX ENVIRONMENT
    *---------------------------------------------------------------------------

    if "`latex'" != "none" {
        di as txt "{bf:Stage 3/6:} Generating LaTeX environment..."
        projectinit_latex_enhanced, path(`"`mainpath'"') projname(`"`projname'"') ///
            template(`latex') lang(`lang') author(`"`author'"')
        di as txt ""
    }
    else {
        di as txt "{bf:Stage 3/6:} Skipping LaTeX (not requested)"
        di as txt ""
    }

    *---------------------------------------------------------------------------
    * TEMPLATE SCRIPTS
    *---------------------------------------------------------------------------

    di as txt "{bf:Stage 4/6:} Generating template analysis scripts..."
    projectinit_scripts_jpal, path(`"`mainpath'"') lang(`lang')
    di as txt ""

    *---------------------------------------------------------------------------
    * GITHUB INTEGRATION
    *---------------------------------------------------------------------------

    if "`github'" != "none" {
        di as txt "{bf:Stage 5/6:} Initializing GitHub repository..."
        projectinit_github_enhanced, path(`"`mainpath'"') projname(`"`projname'"') ///
            visibility(`github') author(`"`author'"') email(`"`email'"')
        di as txt ""
    }
    else {
        di as txt "{bf:Stage 5/6:} Skipping GitHub (not requested)"
        di as txt ""
    }

    *---------------------------------------------------------------------------
    * REPLICATION PACKAGE
    *---------------------------------------------------------------------------

    if "`replicate'" != "" {
        di as txt "{bf:Stage 6/6:} Generating AEA replication package..."
        projectinit_replication_aea, path(`"`mainpath'"') projname(`"`projname'"') ///
            lang(`lang') author(`"`author'"') email(`"`email'"')
        di as txt ""
    }
    else {
        di as txt "{bf:Stage 6/6:} Skipping replication package (not requested)"
        di as txt ""
    }

    *---------------------------------------------------------------------------
    * SUCCESS SUMMARY
    *---------------------------------------------------------------------------

    di as txt "{hline 78}"
    di as result "{bf:✓ PROJECT INITIALIZED SUCCESSFULLY}"
    di as txt "{hline 78}"
    di as txt ""
    di as txt "{bf:Location:} {it:`mainpath'}"
    di as txt ""
    di as txt "{bf:Next Steps:}"
    di as txt `"  {bf:1.} Navigate: cd "`mainpath'""'
    di as txt "  {bf:2.} Review:   doedit run.do"
    di as txt "  {bf:3.} Execute:  do run.do"
    if "`latex'" != "none" {
        di as txt "  {bf:4.} LaTeX:    Import 04_Writing/ to Overleaf"
        di as txt `"             {browse "https://www.overleaf.com/project":https://www.overleaf.com/project}"'
    }
    if "`github'" != "none" {
        di as txt "  {bf:5.} GitHub:   gh repo view --web"
    }
    di as txt ""
    di as txt "{bf:Documentation:}"
    di as txt "  • README.md       - Project overview and replication guide"
    di as txt "  • run.do          - Master execution script"
    di as txt "  • 00_setup.do     - Environment configuration"
    if "`replicate'" != "" {
        di as txt "  • replication.do  - AEA replication instructions"
    }
    di as txt ""
    di as txt "{bf:Standards Compliance:}"
    di as result "  ✓ J-PAL (MIT) folder structure"
    di as result "  ✓ DIME (World Bank) best practices"
    di as result "  ✓ AEA Data Editor requirements"
    di as result "  ✓ NBER reproducibility standards"
    di as txt ""
    di as txt "{hline 78}"
    di as txt ""

    *---------------------------------------------------------------------------
    * RETURN VALUES
    *---------------------------------------------------------------------------

    return local projname "`projname'"
    return local mainpath "`mainpath'"
    return local lang "`lang'"
    return local latex "`latex'"
    return local github "`github'"
    return local author "`author'"
    return local email "`email'"
    return local os "`os'"
    return local created "success"
    return local version "2.1.0"

end

********************************************************************************
* SUBPROGRAM: Generate run.do (Master Script - J-PAL Standard)
********************************************************************************
program define projectinit_run
    syntax, PATH(string) PROJname(string) LAng(string) AUthor(string) Email(string) OS(string)

    file open runfile using `"`path'/run.do"', write replace

    file write runfile "/*******************************************************************************" _n
    file write runfile "* MASTER EXECUTION SCRIPT - run.do" _n
    file write runfile "*" _n
    file write runfile "* Project:     `projname'" _n
    file write runfile "* Author:      `author'" _n
    file write runfile "* Email:       `email'" _n
    file write runfile "* Created:     `c(current_date)'" _n
    file write runfile "* Modified:    `c(current_date)'" _n
    file write runfile "* Stata:       `c(stata_version)' (`c(flavor)')" _n
    file write runfile "* OS:          `os'" _n
    file write runfile "*" _n
    file write runfile "* Purpose:     One-click reproducible execution of entire project" _n
    file write runfile "*" _n
    file write runfile "* Standards:   J-PAL (MIT) | DIME (World Bank) | AEA Data Editor" _n
    file write runfile "*" _n
    file write runfile "* Instructions:" _n
    file write runfile "*   1. Update project-specific settings in Section 1" _n
    file write runfile "*   2. Uncomment scripts in Section 5 as you develop them" _n
    file write runfile "*   3. Run entire file: do run.do" _n
    file write runfile "*" _n
    file write runfile "*******************************************************************************/" _n
    file write runfile "" _n
    file write runfile "clear all" _n
    file write runfile "macro drop _all" _n
    file write runfile "set more off" _n
    file write runfile "set varabbrev off           // Prevent ambiguous abbreviations" _n
    file write runfile "set type double             // Precision" _n
    file write runfile "version 14.0                // Compatibility" _n
    file write runfile "" _n
    file write runfile "/*******************************************************************************" _n
    file write runfile "SECTION 1: DYNAMIC PATH CONFIGURATION (VIRTUALIZATION)" _n
    file write runfile "================================================================================" _n
    file write runfile "Rationale: Paths are constructed dynamically based on current working" _n
    file write runfile "directory, ensuring the project works on any machine without modification." _n
    file write runfile "*******************************************************************************/" _n
    file write runfile "" _n
    file write runfile "* Root directory (automatically detected)" _n
    file write runfile `"global root "\`c(pwd)'"' _n
    file write runfile "" _n
    file write runfile "* Data directories (J-PAL/DIME standard)" _n
    file write runfile `"global data          "\$root/01_Data""' _n
    file write runfile `"global raw           "\$data/Raw""' _n
    file write runfile `"global deidentified  "\$data/De-identified""' _n
    file write runfile `"global intermediate  "\$data/Intermediate""' _n
    file write runfile `"global final         "\$data/Final""' _n
    file write runfile "" _n
    file write runfile "* Script directories (NBER standard)" _n
    file write runfile `"global scripts       "\$root/02_Scripts""' _n
    file write runfile `"global ados          "\$scripts/Ados""' _n
    file write runfile `"global dataprep      "\$scripts/Data_Preparation""' _n
    file write runfile `"global analysis      "\$scripts/Analysis""' _n
    file write runfile `"global validation    "\$scripts/Validation""' _n
    file write runfile "" _n
    file write runfile "* Output directories (AEA standard)" _n
    file write runfile `"global outputs       "\$root/03_Outputs""' _n
    file write runfile `"global tables        "\$outputs/Tables""' _n
    file write runfile `"global figures       "\$outputs/Figures""' _n
    file write runfile `"global logs          "\$outputs/Logs""' _n
    file write runfile `"global rawout        "\$outputs/Raw_Outputs""' _n
    file write runfile "" _n
    file write runfile "* Documentation" _n
    file write runfile `"global doc           "\$root/05_Doc""' _n
    file write runfile `"global codebooks     "\$doc/Codebooks""' _n
    file write runfile "" _n
    file write runfile "* Writing (if applicable)" _n
    file write runfile `"global writing       "\$root/04_Writing""' _n
    file write runfile "" _n
    file write runfile "* Display configuration" _n
    file write runfile `"display as text """' _n
    file write runfile `"display as result "{hline 78}""' _n
    file write runfile `"display as result "PROJECT: `projname'""' _n
    file write runfile `"display as result "{hline 78}""' _n
    file write runfile `"display as text "Root:      \$root""' _n
    file write runfile `"display as text "Started:   \`c(current_date)' \`c(current_time)'""' _n
    file write runfile `"display as text "User:      \`c(username)'""' _n
    file write runfile `"display as text "Stata:     `c(stata_version)' (`c(flavor)')""' _n
    file write runfile `"display as result "{hline 78}""' _n
    file write runfile `"display as text """' _n
    file write runfile "" _n
    file write runfile "/*******************************************************************************" _n
    file write runfile "SECTION 2: ENVIRONMENT ISOLATION (NBER Standard)" _n
    file write runfile "================================================================================" _n
    file write runfile "Rationale: Use project-specific ado files to avoid conflicts with global" _n
    file write runfile "installations. This ensures package versions remain consistent." _n
    file write runfile "*******************************************************************************/" _n
    file write runfile "" _n
    file write runfile "* Add local ado directory to search path (highest priority)" _n
    file write runfile `"adopath ++ "\$ados""' _n
    file write runfile "" _n
    file write runfile "* Display adopath for verification" _n
    file write runfile "adopath" _n
    file write runfile `"display as text """' _n
    file write runfile "" _n
    file write runfile "/*******************************************************************************" _n
    file write runfile "SECTION 3: DEPENDENCY MANAGEMENT (Automated Installation)" _n
    file write runfile "================================================================================" _n
    file write runfile "Rationale: Automatically install required packages if missing." _n
    file write runfile "*******************************************************************************/" _n
    file write runfile "" _n
    file write runfile "* Core packages (customize as needed)" _n
    file write runfile `"local packages """' _n
    file write runfile `"local packages \`packages' "estout"      // Table export"' _n
    file write runfile `"local packages \`packages' "reghdfe"     // High-dimensional FE"' _n
    file write runfile `"local packages \`packages' "ftools"      // Fast collapse/join"' _n
    file write runfile `"local packages \`packages' "grc1leg"     // Combined graphs"' _n
    file write runfile `"local packages \`packages' "coefplot"    // Coefficient plots"' _n
    file write runfile "" _n
    file write runfile "* Latin American microdata packages (uncomment if needed)" _n
    file write runfile `"* local packages \`packages' "usecasen"    // Chile CASEN"' _n
    file write runfile `"* local packages \`packages' "enahodata"   // Peru ENAHO"' _n
    file write runfile `"* local packages \`packages' "usebcrp"     // Peru Central Bank"' _n
    file write runfile `"* local packages \`packages' "fixencoding" // Character encoding"' _n
    file write runfile `"* local packages \`packages' "datadex"     // Data exploration"' _n
    file write runfile "" _n
    file write runfile "* Installation loop" _n
    file write runfile `"display as text "Checking dependencies...""' _n
    file write runfile "foreach pkg of local packages {" _n
    file write runfile "    capture which \`pkg'" _n
    file write runfile "    if _rc {" _n
    file write runfile `"        display as text "  Installing \`pkg'...""' _n
    file write runfile "        capture ssc install \`pkg', replace" _n
    file write runfile "        if _rc {" _n
    file write runfile `"            display as error "  Warning: Could not install \`pkg'""' _n
    file write runfile `"            display as error "  Install manually or check internet connection""' _n
    file write runfile "        }" _n
    file write runfile "        else {" _n
    file write runfile `"            display as result "  ✓ Installed \`pkg'""' _n
    file write runfile "        }" _n
    file write runfile "    }" _n
    file write runfile "    else {" _n
    file write runfile `"        display as result "  ✓ \`pkg' available""' _n
    file write runfile "    }" _n
    file write runfile "}" _n
    file write runfile `"display as text """' _n
    file write runfile "" _n
    file write runfile "/*******************************************************************************" _n
    file write runfile "SECTION 4: REPRODUCIBILITY SETTINGS" _n
    file write runfile "================================================================================" _n
    file write runfile "Rationale: Ensure identical results across machines and time." _n
    file write runfile "*******************************************************************************/" _n
    file write runfile "" _n
    file write runfile "set seed 20251222           // IMPORTANT: Set unique seed for your project" _n
    file write runfile "set linesize 120            // Readable logs" _n
    file write runfile "set maxvar 32000            // Handle large datasets" _n
    file write runfile "set matsize 11000           // Large matrices (if Stata/MP or SE)" _n
    file write runfile "set niceness 5              // Cooperative multitasking" _n
    file write runfile "" _n
    file write runfile "/*******************************************************************************" _n
    file write runfile "SECTION 5: AUDIT TRAIL (Timestamped Logging)" _n
    file write runfile "================================================================================" _n
    file write runfile "Rationale: Comprehensive logs for debugging and documentation." _n
    file write runfile "*******************************************************************************/" _n
    file write runfile "" _n
    file write runfile "* Generate timestamp" _n
    file write runfile `"local datetime = subinstr("\`c(current_date)' \`c(current_time)'", " ", "_", .)"' _n
    file write runfile `"local datetime = subinstr("\`datetime'", ":", "-", .)"' _n
    file write runfile "" _n
    file write runfile "* Open master log" _n
    file write runfile `"log using "\$logs/run_\`datetime'.log", replace text name(masterlog)"' _n
    file write runfile "" _n
    file write runfile "* Log system information" _n
    file write runfile `"display "Software: Stata \`c(stata_version)' (\`c(flavor)')""' _n
    file write runfile `"display "OS: \`c(os)' \`c(osdtl)'""' _n
    file write runfile `"display "Memory: \`c(memory)' bytes""' _n
    file write runfile `"display "Processors: \`c(processors)'""' _n
    file write runfile `"display "Seed: \`c(seed)'""' _n
    file write runfile `"display """' _n
    file write runfile "" _n
    file write runfile "/*******************************************************************************" _n
    file write runfile "SECTION 6: SEQUENTIAL EXECUTION" _n
    file write runfile "================================================================================" _n
    file write runfile "Instructions: Uncomment scripts as you develop them. Run in numerical order." _n
    file write runfile "*******************************************************************************/" _n
    file write runfile "" _n
    file write runfile "* Setup" _n
    file write runfile `"display as result "Stage 1: Setup""' _n
    file write runfile `"do "\$scripts/00_setup.do""' _n
    file write runfile "" _n
    file write runfile "* Data Preparation" _n
    file write runfile `"display as result """' _n
    file write runfile `"display as result "Stage 2: Data Preparation""' _n
    file write runfile `"* do "\$dataprep/01_import.do""' _n
    file write runfile `"* do "\$dataprep/02_clean.do""' _n
    file write runfile `"* do "\$dataprep/03_merge.do""' _n
    file write runfile `"* do "\$dataprep/04_construct.do""' _n
    file write runfile "" _n
    file write runfile "* Analysis" _n
    file write runfile `"display as result """' _n
    file write runfile `"display as result "Stage 3: Analysis""' _n
    file write runfile `"* do "\$analysis/01_descriptive.do""' _n
    file write runfile `"* do "\$analysis/02_main_results.do""' _n
    file write runfile `"* do "\$analysis/03_robustness.do""' _n
    file write runfile `"* do "\$analysis/04_heterogeneity.do""' _n
    file write runfile "" _n
    file write runfile "* Validation" _n
    file write runfile `"display as result """' _n
    file write runfile `"display as result "Stage 4: Validation""' _n
    file write runfile `"* do "\$validation/01_balance_checks.do""' _n
    file write runfile `"* do "\$validation/02_placebo_tests.do""' _n
    file write runfile `"* do "\$validation/03_data_quality.do""' _n
    file write runfile "" _n
    file write runfile "/*******************************************************************************" _n
    file write runfile "SECTION 7: COMPLETION" _n
    file write runfile "*******************************************************************************/" _n
    file write runfile "" _n
    file write runfile `"display """' _n
    file write runfile `"display as result "{hline 78}""' _n
    file write runfile `"display as result "PROJECT EXECUTION COMPLETED""' _n
    file write runfile `"display as result "{hline 78}""' _n
    file write runfile `"display as text "Finished: \`c(current_date)' \`c(current_time)'""' _n
    file write runfile `"display as text "Duration: TBD (implement timer if needed)""' _n
    file write runfile `"display as text "Log file: \$logs/run_\`datetime'.log""' _n
    file write runfile `"display as result "{hline 78}""' _n
    file write runfile `"display """' _n
    file write runfile "" _n
    file write runfile "log close masterlog" _n
    file write runfile "" _n
    file write runfile "* End of run.do" _n

    file close runfile

    di as result "  ✓ run.do"
end

********************************************************************************
* SUBPROGRAM: Generate 00_setup.do (Environment Configuration)
********************************************************************************
program define projectinit_setup
    syntax, PATH(string) LAng(string) OS(string)

    file open setupfile using `"`path'/02_Scripts/00_setup.do"', write replace

    if "`lang'" == "en" {
        file write setupfile "/*******************************************************************************" _n
        file write setupfile "* SETUP SCRIPT - 00_setup.do" _n
        file write setupfile "*" _n
        file write setupfile "* Purpose: Environment configuration and system checks" _n
        file write setupfile "* Created: `c(current_date)'" _n
        file write setupfile "*******************************************************************************/" _n
        file write setupfile "" _n
        file write setupfile "* System information" _n
        file write setupfile `"display as text "System diagnostics:""' _n
        file write setupfile `"display as text "  Stata version: \`c(stata_version)'""' _n
        file write setupfile `"display as text "  Flavor: \`c(flavor)'""' _n
        file write setupfile `"display as text "  OS: \`c(os)'""' _n
        file write setupfile `"display as text "  Processors: \`c(processors)'""' _n
        file write setupfile `"display as text "  Memory: \`c(memory)' bytes""' _n
        file write setupfile `"display as text """' _n
        file write setupfile "" _n
        file write setupfile "* Verify critical paths exist" _n
        file write setupfile `"local critical_paths "\$data" "\$scripts" "\$outputs""' _n
        file write setupfile "foreach path of local critical_paths {" _n
        file write setupfile `"    capture confirm file "\`path'""' _n
        file write setupfile "    if _rc {" _n
        file write setupfile `"        display as error "Critical path not found: \`path'""' _n
        file write setupfile "        exit 601" _n
        file write setupfile "    }" _n
        file write setupfile "}" _n
        file write setupfile "" _n
        file write setupfile `"display as result "✓ All critical paths verified""' _n
        file write setupfile `"display as text """' _n
    }
    else {
        file write setupfile "/*******************************************************************************" _n
        file write setupfile "* SCRIPT DE CONFIGURACIÓN - 00_setup.do" _n
        file write setupfile "*" _n
        file write setupfile "* Propósito: Configuración del entorno y verificaciones del sistema" _n
        file write setupfile "* Creado: `c(current_date)'" _n
        file write setupfile "*******************************************************************************/" _n
        file write setupfile "" _n
        file write setupfile "* Información del sistema" _n
        file write setupfile `"display as text "Diagnóstico del sistema:""' _n
        file write setupfile `"display as text "  Versión Stata: \`c(stata_version)'""' _n
        file write setupfile `"display as text "  Tipo: \`c(flavor)'""' _n
        file write setupfile `"display as text "  OS: \`c(os)'""' _n
        file write setupfile `"display as text "  Procesadores: \`c(processors)'""' _n
        file write setupfile `"display as text "  Memoria: \`c(memory)' bytes""' _n
        file write setupfile `"display as text """' _n
        file write setupfile "" _n
        file write setupfile "* Verificar que las rutas críticas existan" _n
        file write setupfile `"local critical_paths "\$data" "\$scripts" "\$outputs""' _n
        file write setupfile "foreach path of local critical_paths {" _n
        file write setupfile `"    capture confirm file "\`path'""' _n
        file write setupfile "    if _rc {" _n
        file write setupfile `"        display as error "Ruta crítica no encontrada: \`path'""' _n
        file write setupfile "        exit 601" _n
        file write setupfile "    }" _n
        file write setupfile "}" _n
        file write setupfile "" _n
        file write setupfile `"display as result "✓ Todas las rutas críticas verificadas""' _n
        file write setupfile `"display as text """' _n
    }

    file close setupfile

    di as result "  ✓ 00_setup.do"
end

********************************************************************************
* Elite .gitignore (DevOps Grade)
********************************************************************************
program define projectinit_gitignore_elite
    syntax, PATH(string) LAtex(string)

    file open gitfile using `"`path'/.gitignore"', write replace

    file write gitfile "# =============================================================================" _n
    file write gitfile "# .gitignore - Elite Research Project (J-PAL/DIME/AEA Standard)" _n
    file write gitfile "# Generated by projectinit v2.1.0" _n
    file write gitfile "# =============================================================================" _n
    file write gitfile "" _n
    file write gitfile "# CRITICAL: Raw microdata (NEVER commit sensitive data)" _n
    file write gitfile "01_Data/Raw/" _n
    file write gitfile "01_Data/De-identified/*.dta" _n
    file write gitfile "*.dta" _n
    file write gitfile "*.csv" _n
    file write gitfile "*.xlsx" _n
    file write gitfile "*.xls" _n
    file write gitfile "*.sav" _n
    file write gitfile "*.por" _n
    file write gitfile "" _n
    file write gitfile "# Stata temporary and log files" _n
    file write gitfile "*.smcl" _n
    file write gitfile "*.log" _n
    file write gitfile "*.dta~" _n
    file write gitfile "*.do~" _n
    file write gitfile "*.gph" _n
    file write gitfile "*.stpr" _n
    file write gitfile "" _n
    file write gitfile "# Temporary directories" _n
    file write gitfile "temp/" _n
    file write gitfile "tmp/" _n
    file write gitfile "*.tmp" _n
    file write gitfile "" _n
    file write gitfile "# Logs (keep structure, ignore content)" _n
    file write gitfile "03_Outputs/Logs/*.log" _n
    file write gitfile "03_Outputs/Logs/*.smcl" _n
    file write gitfile "" _n

    if "`latex'" != "none" {
        file write gitfile "# LaTeX compilation artifacts" _n
        file write gitfile "*.aux" _n
        file write gitfile "*.out" _n
        file write gitfile "*.bbl" _n
        file write gitfile "*.blg" _n
        file write gitfile "*.synctex.gz" _n
        file write gitfile "*.fdb_latexmk" _n
        file write gitfile "*.fls" _n
        file write gitfile "*.toc" _n
        file write gitfile "*.lof" _n
        file write gitfile "*.lot" _n
        file write gitfile "*.nav" _n
        file write gitfile "*.snm" _n
        file write gitfile "*.vrb" _n
        file write gitfile "*.bcf" _n
        file write gitfile "*.run.xml" _n
        file write gitfile "*.bak" _n
        file write gitfile "*.spl" _n
        file write gitfile "" _n
    }

    file write gitfile "# OS-specific files" _n
    file write gitfile ".DS_Store" _n
    file write gitfile "._*" _n
    file write gitfile "Thumbs.db" _n
    file write gitfile "ehthumbs.db" _n
    file write gitfile "Desktop.ini" _n
    file write gitfile "\$RECYCLE.BIN/" _n
    file write gitfile ".Spotlight-V100" _n
    file write gitfile ".Trashes" _n
    file write gitfile "" _n
    file write gitfile "# IDE and editor files" _n
    file write gitfile ".vscode/" _n
    file write gitfile ".idea/" _n
    file write gitfile "*.sublime-project" _n
    file write gitfile "*.sublime-workspace" _n
    file write gitfile "*~" _n
    file write gitfile "" _n
    file write gitfile "# =============================================================================" _n
    file write gitfile "# EXCEPTIONS (Force include these critical outputs)" _n
    file write gitfile "# =============================================================================" _n
    file write gitfile "" _n
    file write gitfile "# Keep final tables and figures for replication" _n
    file write gitfile "!03_Outputs/Tables/*.tex" _n
    file write gitfile "!03_Outputs/Tables/*.csv" _n
    file write gitfile "!03_Outputs/Figures/*.pdf" _n
    file write gitfile "!03_Outputs/Figures/*.png" _n
    file write gitfile "!03_Outputs/Figures/*.eps" _n
    file write gitfile "" _n
    file write gitfile "# Keep replication package data (if de-identified)" _n
    file write gitfile "!06_Replication/data/*.dta" _n
    file write gitfile "" _n
    file write gitfile "# Keep codebooks and documentation" _n
    file write gitfile "!05_Doc/**/*.pdf" _n
    file write gitfile "!05_Doc/**/*.md" _n
    file write gitfile "" _n
    file write gitfile "# End of .gitignore" _n

    file close gitfile

    di as result "  ✓ .gitignore (Elite)"
end

********************************************************************************
* AEA-Compliant README.md
********************************************************************************
program define projectinit_readme_aea
    syntax, PATH(string) PROJname(string) LAng(string) AUthor(string) ///
        Email(string) LAtex(string) GIThub(string)

    file open readmefile using `"`path'/README.md"', write replace

    if "`lang'" == "en" {
        file write readmefile "# `projname'" _n
        file write readmefile "" _n
        file write readmefile "> **Research Project following J-PAL, DIME, and AEA Standards**" _n
        file write readmefile "" _n
        file write readmefile "---" _n
        file write readmefile "" _n
        file write readmefile "## Project Information" _n
        file write readmefile "" _n
        file write readmefile "- **Principal Investigator**: `author'" _n
        file write readmefile "- **Email**: `email'" _n
        file write readmefile "- **Created**: `c(current_date)'" _n
        file write readmefile "- **Last Modified**: `c(current_date)'" _n
        file write readmefile "- **Software**: Stata `c(stata_version)' or higher" _n
        file write readmefile "- **Generated by**: projectinit v2.1.0" _n
        file write readmefile "" _n
        file write readmefile "---" _n
        file write readmefile "" _n
        file write readmefile "## Overview" _n
        file write readmefile "" _n
        file write readmefile "[Provide a brief description of your research project]" _n
        file write readmefile "" _n
        file write readmefile "This project adheres to:" _n
        file write readmefile "- **J-PAL (MIT)** reproducibility guidelines" _n
        file write readmefile "- **DIME (World Bank)** best practices" _n
        file write readmefile "- **AEA Data Editor** requirements" _n
        file write readmefile "" _n
        file write readmefile "---" _n
        file write readmefile "" _n
        file write readmefile "## Data Availability Statement" _n
        file write readmefile "" _n
        file write readmefile "### Primary Data Sources" _n
        file write readmefile "" _n
        file write readmefile "[Describe your data sources following AEA guidelines]" _n
        file write readmefile "" _n
        file write readmefile "**Example for Chilean/Peruvian microdata:**" _n
        file write readmefile "" _n
        file write readmefile "- **CASEN (Chile)**: National Socioeconomic Characterization Survey" _n
        file write readmefile "  - Source: Ministry of Social Development and Family, Chile" _n
        file write readmefile "  - Access: http://observatorio.ministeriodesarrollosocial.gob.cl/" _n
        file write readmefile "  - Restriction: Publicly available" _n
        file write readmefile "" _n
        file write readmefile "- **ENAHO (Peru)**: National Household Survey" _n
        file write readmefile "  - Source: INEI (National Institute of Statistics, Peru)" _n
        file write readmefile "  - Access: http://iinei.inei.gob.pe/microdatos/" _n
        file write readmefile "  - Restriction: Publicly available with registration" _n
        file write readmefile "" _n
        file write readmefile "### Data Access" _n
        file write readmefile "" _n
        file write readmefile "- **Confidentiality**: [Describe any confidentiality restrictions]" _n
        file write readmefile "- **IRB Approval**: [Provide IRB information if applicable]" _n
        file write readmefile "- **Data Sharing**: [Specify what data will be shared for replication]" _n
        file write readmefile "" _n
        file write readmefile "---" _n
        file write readmefile "" _n
        file write readmefile "## Project Structure" _n
        file write readmefile "" _n
        file write readmefile "```" _n
        file write readmefile "`projname'/" _n
        file write readmefile "│" _n
        file write readmefile "├── run.do                    # Master execution script (START HERE)" _n
        file write readmefile "├── README.md                 # This file" _n
        file write readmefile "├── .gitignore                # Git configuration" _n
        file write readmefile "│" _n
        file write readmefile "├── 01_Data/                  # Data (J-PAL/DIME standard)" _n
        file write readmefile "│   ├── Raw/                  # Original data (NEVER modified)" _n
        file write readmefile "│   ├── De-identified/        # Anonymized data" _n
        file write readmefile "│   ├── Intermediate/         # Processed data" _n
        file write readmefile "│   └── Final/                # Analysis-ready data" _n
        file write readmefile "│" _n
        file write readmefile "├── 02_Scripts/               # All analysis code (NBER standard)" _n
        file write readmefile "│   ├── Ados/                 # Project-specific ado files" _n
        file write readmefile "│   ├── Data_Preparation/     # Data cleaning and construction" _n
        file write readmefile "│   ├── Analysis/             # Statistical analysis" _n
        file write readmefile "│   └── Validation/           # Validation and robustness" _n
        file write readmefile "│" _n
        file write readmefile "├── 03_Outputs/               # Generated outputs (AEA standard)" _n
        file write readmefile "│   ├── Tables/               # Publication-ready tables" _n
        file write readmefile "│   ├── Figures/              # Publication-ready figures" _n
        file write readmefile "│   ├── Logs/                 # Execution logs" _n
        file write readmefile "│   └── Raw_Outputs/          # Intermediate outputs" _n
        file write readmefile "│" _n
    }
    else {
        file write readmefile "# `projname'" _n
        file write readmefile "" _n
        file write readmefile "> **Proyecto de Investigación siguiendo estándares J-PAL, DIME y AEA**" _n
        file write readmefile "" _n
        file write readmefile "---" _n
        file write readmefile "" _n
        file write readmefile "## Información del Proyecto" _n
        file write readmefile "" _n
        file write readmefile "- **Investigador Principal**: `author'" _n
        file write readmefile "- **Email**: `email'" _n
        file write readmefile "- **Creado**: `c(current_date)'" _n
        file write readmefile "- **Última Modificación**: `c(current_date)'" _n
        file write readmefile "- **Software**: Stata `c(stata_version)' o superior" _n
        file write readmefile "- **Generado por**: projectinit v2.1.0" _n
        file write readmefile "" _n
        file write readmefile "---" _n
        file write readmefile "" _n
        file write readmefile "## Descripción" _n
        file write readmefile "" _n
        file write readmefile "[Provea una breve descripción de su proyecto de investigación]" _n
        file write readmefile "" _n
        file write readmefile "Este proyecto cumple con:" _n
        file write readmefile "- Guías de reproducibilidad de **J-PAL (MIT)**" _n
        file write readmefile "- Mejores prácticas de **DIME (Banco Mundial)**" _n
        file write readmefile "- Requerimientos del **AEA Data Editor**" _n
        file write readmefile "" _n
        file write readmefile "---" _n
        file write readmefile "" _n
        file write readmefile "## Declaración de Disponibilidad de Datos" _n
        file write readmefile "" _n
        file write readmefile "### Fuentes de Datos Primarias" _n
        file write readmefile "" _n
        file write readmefile "[Describa sus fuentes de datos siguiendo las guías de AEA]" _n
        file write readmefile "" _n
        file write readmefile "**Ejemplo para microdatos chilenos/peruanos:**" _n
        file write readmefile "" _n
        file write readmefile "- **CASEN (Chile)**: Encuesta de Caracterización Socioeconómica Nacional" _n
        file write readmefile "  - Fuente: Ministerio de Desarrollo Social y Familia, Chile" _n
        file write readmefile "  - Acceso: http://observatorio.ministeriodesarrollosocial.gob.cl/" _n
        file write readmefile "  - Restricción: Disponible públicamente" _n
        file write readmefile "" _n
        file write readmefile "- **ENAHO (Perú)**: Encuesta Nacional de Hogares" _n
        file write readmefile "  - Fuente: INEI (Instituto Nacional de Estadística, Perú)" _n
        file write readmefile "  - Acceso: http://iinei.inei.gob.pe/microdatos/" _n
        file write readmefile "  - Restricción: Disponible con registro" _n
        file write readmefile "" _n
        file write readmefile "---" _n
        file write readmefile "" _n
        file write readmefile "## Estructura del Proyecto" _n
        file write readmefile "" _n
        file write readmefile "```" _n
        file write readmefile "`projname'/" _n
        file write readmefile "│" _n
        file write readmefile "├── run.do                    # Script de ejecución maestro (COMENZAR AQUÍ)" _n
        file write readmefile "├── README.md                 # Este archivo" _n
        file write readmefile "├── .gitignore                # Configuración Git" _n
        file write readmefile "│" _n
        file write readmefile "├── 01_Data/                  # Datos (estándar J-PAL/DIME)" _n
        file write readmefile "│   ├── Raw/                  # Datos originales (NUNCA modificar)" _n
        file write readmefile "│   ├── De-identified/        # Datos anonimizados" _n
        file write readmefile "│   ├── Intermediate/         # Datos procesados" _n
        file write readmefile "│   └── Final/                # Datos listos para análisis" _n
        file write readmefile "│" _n
        file write readmefile "├── 02_Scripts/               # Todo el código de análisis" _n
        file write readmefile "│   ├── Ados/                 # Comandos específicos del proyecto" _n
        file write readmefile "│   ├── Data_Preparation/     # Limpieza y construcción de datos" _n
        file write readmefile "│   ├── Analysis/             # Análisis estadístico" _n
        file write readmefile "│   └── Validation/           # Validación y robustez" _n
        file write readmefile "│" _n
        file write readmefile "├── 03_Outputs/               # Resultados generados" _n
        file write readmefile "│   ├── Tables/               # Tablas para publicación" _n
        file write readmefile "│   ├── Figures/              # Figuras para publicación" _n
        file write readmefile "│   ├── Logs/                 # Logs de ejecución" _n
        file write readmefile "│   └── Raw_Outputs/          # Resultados intermedios" _n
        file write readmefile "│" _n
    }

    if "`latex'" != "none" {
        file write readmefile "├── 04_Writing/               # Manuscript LaTeX" _n
        file write readmefile "│   ├── main.tex              # Main document" _n
        file write readmefile "│   ├── sections/             # Paper sections" _n
        file write readmefile "│   └── results_macros.tex    # Auto-generated from Stata" _n
        file write readmefile "│" _n
    }

    file write readmefile "├── 05_Doc/                   # Documentation" _n
    file write readmefile "│   ├── Codebooks/            # Data dictionaries" _n
    file write readmefile "│   ├── Questionnaires/       # Survey instruments" _n
    file write readmefile "│   └── IRB/                  # Ethics approvals" _n
    file write readmefile "```" _n
    file write readmefile "" _n
    file write readmefile "---" _n
    file write readmefile "" _n

    if "`lang'" == "en" {
        file write readmefile "## Replication Instructions" _n
        file write readmefile "" _n
        file write readmefile "### Prerequisites" _n
        file write readmefile "" _n
        file write readmefile "1. **Software**: Stata `c(stata_version)' or higher" _n
        file write readmefile "2. **Packages**: Automatically installed by `run.do`" _n
        file write readmefile "3. **Data**: [Specify how to obtain data]" _n
        file write readmefile "4. **Hardware**: Minimum 8GB RAM recommended" _n
        file write readmefile "5. **Runtime**: Approximately [X] hours on standard machine" _n
        file write readmefile "" _n
        file write readmefile "### Step-by-Step Replication" _n
        file write readmefile "" _n
        file write readmefile "1. **Clone or download this repository**" _n
        file write readmefile "   ```bash" _n
        file write readmefile "   git clone https://github.com/username/`projname'.git" _n
        file write readmefile "   ```" _n
        file write readmefile "" _n
        file write readmefile "2. **Place raw data** in `01_Data/Raw/`" _n
        file write readmefile "" _n
        file write readmefile "3. **Navigate to project directory** in Stata" _n
        file write readmefile "   ```stata" _n
        file write readmefile `"   cd "path/to/`projname'""' _n
        file write readmefile "   ```" _n
        file write readmefile "" _n
        file write readmefile "4. **Execute master script**" _n
        file write readmefile "   ```stata" _n
        file write readmefile "   do run.do" _n
        file write readmefile "   ```" _n
        file write readmefile "" _n
        file write readmefile "5. **Check outputs**" _n
        file write readmefile "   - Tables: `03_Outputs/Tables/`" _n
        file write readmefile "   - Figures: `03_Outputs/Figures/`" _n
        file write readmefile "   - Logs: `03_Outputs/Logs/`" _n
        file write readmefile "" _n
        file write readmefile "### Troubleshooting" _n
        file write readmefile "" _n
        file write readmefile "- **Memory errors**: Increase `set max_memory` in run.do" _n
        file write readmefile "- **Package errors**: Install manually via `ssc install [package]`" _n
        file write readmefile "- **Path errors**: Ensure you're in the project directory" _n
        file write readmefile "" _n
    }
    else {
        file write readmefile "## Instrucciones de Replicación" _n
        file write readmefile "" _n
        file write readmefile "### Requisitos Previos" _n
        file write readmefile "" _n
        file write readmefile "1. **Software**: Stata `c(stata_version)' o superior" _n
        file write readmefile "2. **Paquetes**: Instalados automáticamente por `run.do`" _n
        file write readmefile "3. **Datos**: [Especificar cómo obtener los datos]" _n
        file write readmefile "4. **Hardware**: Mínimo 8GB RAM recomendado" _n
        file write readmefile "5. **Tiempo de ejecución**: Aproximadamente [X] horas" _n
        file write readmefile "" _n
        file write readmefile "### Pasos para Replicar" _n
        file write readmefile "" _n
        file write readmefile "1. **Clonar o descargar este repositorio**" _n
        file write readmefile "   ```bash" _n
        file write readmefile "   git clone https://github.com/usuario/`projname'.git" _n
        file write readmefile "   ```" _n
        file write readmefile "" _n
        file write readmefile "2. **Colocar datos crudos** en `01_Data/Raw/`" _n
        file write readmefile "" _n
        file write readmefile "3. **Navegar al directorio del proyecto** en Stata" _n
        file write readmefile "   ```stata" _n
        file write readmefile `"   cd "ruta/a/`projname'""' _n
        file write readmefile "   ```" _n
        file write readmefile "" _n
        file write readmefile "4. **Ejecutar script maestro**" _n
        file write readmefile "   ```stata" _n
        file write readmefile "   do run.do" _n
        file write readmefile "   ```" _n
        file write readmefile "" _n
        file write readmefile "5. **Verificar resultados**" _n
        file write readmefile "   - Tablas: `03_Outputs/Tables/`" _n
        file write readmefile "   - Figuras: `03_Outputs/Figures/`" _n
        file write readmefile "   - Logs: `03_Outputs/Logs/`" _n
        file write readmefile "" _n
    }

    file write readmefile "---" _n
    file write readmefile "" _n
    file write readmefile "## Citation" _n
    file write readmefile "" _n
    file write readmefile "If you use this code or data, please cite:" _n
    file write readmefile "" _n
    file write readmefile "```" _n
    file write readmefile `"`author' (`c(current_year)'). "`projname'"."' _n
    file write readmefile "[Journal/Repository information]" _n
    file write readmefile "```" _n
    file write readmefile "" _n
    file write readmefile "---" _n
    file write readmefile "" _n
    file write readmefile "## License" _n
    file write readmefile "" _n
    file write readmefile "MIT License - see LICENSE file for details" _n
    file write readmefile "" _n
    file write readmefile "---" _n
    file write readmefile "" _n
    file write readmefile "## Contact" _n
    file write readmefile "" _n
    file write readmefile "- **Author**: `author'" _n
    file write readmefile "- **Email**: `email'" _n
    if "`github'" != "none" {
        file write readmefile "- **Repository**: https://github.com/username/`projname'" _n
    }
    file write readmefile "" _n
    file write readmefile "---" _n
    file write readmefile "" _n
    file write readmefile "*Generated by projectinit v2.1.0 - Professional Research Infrastructure*" _n

    file close readmefile

    di as result "  ✓ README.md (AEA-compliant)"
end

********************************************************************************
* SUBPROGRAM: Generate Template Analysis Scripts (J-PAL Standard)
********************************************************************************
program define projectinit_scripts_jpal
    syntax, PATH(string) LAng(string)

    * This is a placeholder - creates basic template files
    * Users can customize these scripts as needed

    if "`lang'" == "en" {
        * Create placeholder in Data_Preparation
        file open scriptfile using `"`path'/02_Scripts/Data_Preparation/01_import.do"', write replace
        file write scriptfile "/*******************************************************************************" _n
        file write scriptfile "* DATA IMPORT SCRIPT" _n
        file write scriptfile "*" _n
        file write scriptfile "* Purpose: Import raw data files" _n
        file write scriptfile "*******************************************************************************/" _n
        file write scriptfile "" _n
        file write scriptfile "* Example:" _n
        file write scriptfile `"* use "\$raw/yourdata.dta", clear"' _n
        file write scriptfile `"* save "\$intermediate/imported.dta", replace"' _n
        file close scriptfile

        * Create placeholder in Analysis
        file open scriptfile using `"`path'/02_Scripts/Analysis/01_descriptive.do"', write replace
        file write scriptfile "/*******************************************************************************" _n
        file write scriptfile "* DESCRIPTIVE ANALYSIS" _n
        file write scriptfile "*" _n
        file write scriptfile "* Purpose: Descriptive statistics and summary tables" _n
        file write scriptfile "*******************************************************************************/" _n
        file write scriptfile "" _n
        file write scriptfile "* Example:" _n
        file write scriptfile `"* use "\$final/analysis.dta", clear"' _n
        file write scriptfile "* summarize" _n
        file close scriptfile
    }
    else {
        * Spanish version
        file open scriptfile using `"`path'/02_Scripts/Data_Preparation/01_import.do"', write replace
        file write scriptfile "/*******************************************************************************" _n
        file write scriptfile "* SCRIPT DE IMPORTACIÓN DE DATOS" _n
        file write scriptfile "*" _n
        file write scriptfile "* Propósito: Importar archivos de datos crudos" _n
        file write scriptfile "*******************************************************************************/" _n
        file write scriptfile "" _n
        file write scriptfile "* Ejemplo:" _n
        file write scriptfile `"* use "\$raw/tusdatos.dta", clear"' _n
        file write scriptfile `"* save "\$intermediate/importados.dta", replace"' _n
        file close scriptfile

        file open scriptfile using `"`path'/02_Scripts/Analysis/01_descriptive.do"', write replace
        file write scriptfile "/*******************************************************************************" _n
        file write scriptfile "* ANÁLISIS DESCRIPTIVO" _n
        file write scriptfile "*" _n
        file write scriptfile "* Propósito: Estadísticas descriptivas y tablas resumen" _n
        file write scriptfile "*******************************************************************************/" _n
        file write scriptfile "" _n
        file write scriptfile "* Ejemplo:" _n
        file write scriptfile `"* use "\$final/analisis.dta", clear"' _n
        file write scriptfile "* summarize" _n
        file close scriptfile
    }

    di as result "  ✓ Template scripts created"
end

********************************************************************************
* SUBPROGRAM: GitHub Repository Initialization (Enhanced)
********************************************************************************
program define projectinit_github_enhanced
    syntax, PATH(string) PROJname(string) VISibility(string) AUthor(string) Email(string)

    * Navigate to project directory first
    local olddir `"`c(pwd)'"'
    quietly cd `"`path'"'

    * Initialize git repository (always safe to do)
    di as text "  Initializing git repository..."
    capture shell git init
    if _rc {
        di as error "  Git not found. Install git first."
        di as text "  Repository initialized locally only (no GitHub integration)."
        quietly cd `"`olddir'"'
        exit 0
    }

    * Configure git
    capture shell git config user.name "`author'"
    capture shell git config user.email "`email'"

    * Initial commit (do this first, before trying GitHub)
    di as text "  Making initial commit..."
    capture shell git add .
    capture shell git commit -m "Initial project structure from projectinit v2.1"

    * Try to use GitHub CLI
    di as text "  Creating GitHub repository..."
    if "`visibility'" == "private" {
        capture shell gh repo create "`projname'" --`visibility' --source=. --remote=origin
    }
    else {
        capture shell gh repo create "`projname'" --public --source=. --remote=origin
    }

    local gh_failed = _rc

    if `gh_failed' {
        di as error "  GitHub CLI (gh) not available in PATH."
        di as text "  Repository created locally with Git."
        di as text ""
        di as text "  {bf:To sync with GitHub:}"
        di as text "  1. Create repository manually at https://github.com/new"
        di as text "  2. Run these commands:"
        di as text `"     cd "`path'""'
        di as text "     git remote add origin https://github.com/YOUR_USERNAME/`projname'.git"
        di as text "     git push -u origin main"
        di as text ""
        di as text "  Or install GitHub CLI: https://cli.github.com/"
        quietly cd `"`olddir'"'
        exit 0
    }

    * Push to GitHub
    di as text "  Pushing to GitHub..."
    capture shell git push -u origin main
    if _rc {
        capture shell git push -u origin master
    }

    * Return to original directory
    quietly cd `"`olddir'"'

    di as result "  ✓ GitHub repository created and pushed"
end

********************************************************************************
* SUBPROGRAM: AEA Replication Package
********************************************************************************
program define projectinit_replication_aea
    syntax, PATH(string) PROJname(string) LAng(string) AUthor(string) Email(string)

    * Create replication directory structure
    capture mkdir `"`path'/06_Replication"'
    capture mkdir `"`path'/06_Replication/data"'
    capture mkdir `"`path'/06_Replication/code"'
    capture mkdir `"`path'/06_Replication/outputs"'

    * Create replication README
    file open repfile using `"`path'/06_Replication/README_REPLICATION.md"', write replace

    if "`lang'" == "en" {
        file write repfile "# Replication Package: `projname'" _n
        file write repfile "" _n
        file write repfile "**Author**: `author'" _n
        file write repfile "**Email**: `email'" _n
        file write repfile "" _n
        file write repfile "## Overview" _n
        file write repfile "" _n
        file write repfile "This package contains all materials needed to replicate the results" _n
        file write repfile "presented in the paper." _n
        file write repfile "" _n
        file write repfile "## Data Availability Statement" _n
        file write repfile "" _n
        file write repfile "[Describe data sources, access restrictions, and licensing]" _n
        file write repfile "" _n
        file write repfile "## Computational Requirements" _n
        file write repfile "" _n
        file write repfile "- **Software**: Stata `c(stata_version)' or higher" _n
        file write repfile "- **Packages**: Listed in replication.do" _n
        file write repfile "- **Runtime**: Approximately [X] hours on standard desktop" _n
        file write repfile "- **Memory**: Minimum 8GB RAM recommended" _n
        file write repfile "" _n
        file write repfile "## Instructions" _n
        file write repfile "" _n
        file write repfile "1. Place data files in `data/` directory" _n
        file write repfile "2. Run `replication.do` in Stata" _n
        file write repfile "3. Check outputs in `outputs/` directory" _n
    }
    else {
        file write repfile "# Paquete de Replicación: `projname'" _n
        file write repfile "" _n
        file write repfile "**Autor**: `author'" _n
        file write repfile "**Email**: `email'" _n
        file write repfile "" _n
        file write repfile "## Resumen" _n
        file write repfile "" _n
        file write repfile "Este paquete contiene todos los materiales necesarios para replicar" _n
        file write repfile "los resultados presentados en el documento." _n
        file write repfile "" _n
        file write repfile "## Declaración de Disponibilidad de Datos" _n
        file write repfile "" _n
        file write repfile "[Describir fuentes de datos, restricciones de acceso y licencias]" _n
        file write repfile "" _n
        file write repfile "## Requisitos Computacionales" _n
        file write repfile "" _n
        file write repfile "- **Software**: Stata `c(stata_version)' o superior" _n
        file write repfile "- **Paquetes**: Listados en replication.do" _n
        file write repfile "- **Tiempo de ejecución**: Aproximadamente [X] horas en PC estándar" _n
        file write repfile "- **Memoria**: Mínimo 8GB RAM recomendado" _n
        file write repfile "" _n
        file write repfile "## Instrucciones" _n
        file write repfile "" _n
        file write repfile "1. Colocar archivos de datos en directorio `data/`" _n
        file write repfile "2. Ejecutar `replication.do` en Stata" _n
        file write repfile "3. Verificar resultados en directorio `outputs/`" _n
    }

    file close repfile

    * Create replication.do master script
    file open repdo using `"`path'/06_Replication/replication.do"', write replace
    file write repdo "* Replication Master Script" _n
    file write repdo "* Project: `projname'" _n
    file write repdo "" _n
    file write repdo "clear all" _n
    file write repdo "set more off" _n
    file write repdo "" _n
    file write repdo "* Set working directory" _n
    file write repdo `"cd "\`c(pwd)'/06_Replication""' _n
    file write repdo "" _n
    file write repdo "* Run analysis scripts" _n
    file write repdo "* do code/01_analysis.do" _n
    file write repdo "" _n
    file write repdo "* End of replication" _n
    file close repdo

    di as result "  ✓ Replication package created (06_Replication/)"
end

********************************************************************************
* SUBPROGRAM: LaTeX Environment (Enhanced)
********************************************************************************
program define projectinit_latex_enhanced
    syntax, PATH(string) PROJname(string) TEMplate(string) LAng(string) AUthor(string)

    * Create LaTeX directory structure
    capture mkdir `"`path'/04_Writing"'
    capture mkdir `"`path'/04_Writing/sections"'
    capture mkdir `"`path'/04_Writing/tables"'
    capture mkdir `"`path'/04_Writing/figures"'
    capture mkdir `"`path'/04_Writing/bibliography"'

    * Create main.tex
    file open maintex using `"`path'/04_Writing/main.tex"', write replace

    if "`template'" == "puc" {
        * PUC Thesis Template - Complete Professional Format
        file write maintex "\documentclass[9pt, a4paper]{article}" _n
        file write maintex "" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "%% Codificación, Fuentes e Idioma" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "\usepackage[utf8]{inputenc}" _n
        file write maintex "\usepackage[T1]{fontenc}" _n
        file write maintex "\usepackage{lmodern}" _n
        file write maintex "\usepackage[english, spanish]{babel}" _n
        file write maintex "\renewcommand*\familydefault{\sfdefault}" _n
        file write maintex "\usepackage{relsize}" _n
        file write maintex "\usepackage{url}" _n
        file write maintex "\usepackage{doi}" _n
        file write maintex "" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "%% Configuración de Página y Espaciado" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "\usepackage{geometry}" _n
        file write maintex "\geometry{a4paper, margin=2.5cm}" _n
        file write maintex "\setlength{\parindent}{1.5em}" _n
        file write maintex "\setlength{\parskip}{0.5em}" _n
        file write maintex "\renewcommand{\baselinestretch}{1.15}" _n
        file write maintex "" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "%% Matemáticas" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "\usepackage{amsmath}" _n
        file write maintex "\usepackage{amssymb}" _n
        file write maintex "\usepackage{amsthm}" _n
        file write maintex "\usepackage{bm}" _n
        file write maintex "\newtheorem{mydef}{Definition}" _n
        file write maintex "\newtheorem{mytherm}{Theorem}" _n
        file write maintex "" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "%% Gráficos y Figuras" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "\usepackage{graphicx}" _n
        file write maintex "\usepackage{caption}" _n
        file write maintex "\usepackage{subcaption}" _n
        file write maintex "\usepackage{float}" _n
        file write maintex "" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "%% Tablas" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "\usepackage{booktabs}" _n
        file write maintex "\usepackage{multirow}" _n
        file write maintex "\usepackage{makecell}" _n
        file write maintex "\usepackage{rotating}" _n
        file write maintex "\usepackage{threeparttable}" _n
        file write maintex "" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "%% Listas y Columnas" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "\usepackage{enumitem}" _n
        file write maintex "\usepackage{multicol}" _n
        file write maintex "" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "%% Algoritmos y Código Fuente" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "\usepackage{algorithm}" _n
        file write maintex "\usepackage{algpseudocode}" _n
        file write maintex "\renewcommand{\algorithmicrequire}{\textbf{Input:}}" _n
        file write maintex "\renewcommand{\algorithmicensure}{\textbf{Output:}}" _n
        file write maintex "\usepackage{listings}" _n
        file write maintex "\usepackage{xcolor}" _n
        file write maintex "" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "%% Referencias y Bibliografía" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "\usepackage[round, authoryear]{natbib}" _n
        file write maintex "\bibliographystyle{apalike}" _n
        file write maintex "\renewcommand{\bibname}{referencias}" _n
        file write maintex "\usepackage{tikz}" _n
        file write maintex "\usetikzlibrary{positioning, arrows.meta, shapes}" _n
        file write maintex "" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "%% Hipervínculos" _n
        file write maintex "%%-------------------------------------" _n
        file write maintex "\usepackage{hyperref}" _n
        file write maintex "\hypersetup{" _n
        file write maintex "    colorlinks=true," _n
        file write maintex "    linkcolor=blue!60!black," _n
        file write maintex "    urlcolor=blue!70!black," _n
        file write maintex "    citecolor=blue!70!black," _n
        file write maintex "    bookmarksopen=true," _n
        file write maintex "    pdftitle={`projname'}," _n
        file write maintex "    pdfauthor={`author'}" _n
        file write maintex "}" _n
        file write maintex "\usepackage{titling}" _n
        file write maintex "\usepackage{setspace}" _n
        file write maintex "" _n
        file write maintex "% Macros from Stata" _n
        file write maintex "\input{macros.tex}" _n
        file write maintex "" _n
        file write maintex "\begin{document}" _n
        file write maintex "" _n
        file write maintex "\begin{titlepage}" _n
        file write maintex "    \begin{center}" _n
        file write maintex "        {\fontsize{16}{20}\selectfont" _n
        file write maintex "         \textbf{PONTIFICIA UNIVERSIDAD CATÓLICA DE CHILE}\\[0.3cm]" _n
        file write maintex "        }" _n
        file write maintex "        \vspace*{1cm}" _n
        file write maintex "        % \includegraphics[width=4cm]{UC_logo.jpg}" _n
        file write maintex "        \vspace{0.8cm}" _n
        file write maintex "        \vspace{2cm}" _n
        file write maintex "        \begin{spacing}{1.1}" _n
        file write maintex "            {\fontsize{18}{24}\selectfont\bfseries" _n
        file write maintex "             \textcolor{navy}{`projname'}" _n
        file write maintex "            }" _n
        file write maintex "        \end{spacing}" _n
        file write maintex "        \vspace{2cm}" _n
        file write maintex "        {\begin{minipage}{0.6\textwidth}" _n
        file write maintex "            \centering" _n
        file write maintex "            {\fontsize{12}{12}\selectfont" _n
        file write maintex "             \textbf{Autores}\\[0.3cm]" _n
        file write maintex "             `author'" _n
        file write maintex "            }" _n
        file write maintex "        \end{minipage}}" _n
        file write maintex "        \vspace{1.5cm}" _n
        file write maintex "        \vfill" _n
        file write maintex "        \begin{minipage}{\textwidth}" _n
        file write maintex "            \centering" _n
        file write maintex "            {\fontsize{12}{14}\selectfont" _n
        file write maintex "             \textbf{Santiago, Chile}\\[0.2cm]" _n
        file write maintex "             \today\\[0.5cm]" _n
        file write maintex "             \textcolor{gray!70!black}{\rule{0.5\textwidth}{0.5pt}}\\[0.3cm]" _n
        file write maintex "             {\fontsize{10}{12}\selectfont" _n
        file write maintex "              \textit{Facultad de Ciencias Económicas y Administrativas}\\[0.1cm]" _n
        file write maintex "              \textit{Instituto de Economía UC}" _n
        file write maintex "             }" _n
        file write maintex "            }" _n
        file write maintex "        \end{minipage}" _n
        file write maintex "    \end{center}" _n
        file write maintex "\end{titlepage}" _n
        file write maintex "" _n
        file write maintex "\newpage" _n
        file write maintex "\tableofcontents" _n
        file write maintex "\newpage" _n
        file write maintex "" _n
        file write maintex "\input{sections/01_introduction.tex}" _n
        file write maintex "" _n
        file write maintex "\section{Revisión de Literatura}" _n
        file write maintex "\input{sections/02_literature.tex}" _n
        file write maintex "" _n
        file write maintex "\section{Marco Conceptual}" _n
        file write maintex "\input{sections/03_framework.tex}" _n
        file write maintex "" _n
        file write maintex "\section{Datos}" _n
        file write maintex "\input{sections/04_data.tex}" _n
        file write maintex "" _n
        file write maintex "\section{Estrategia Empírica}" _n
        file write maintex "\input{sections/05_methodology.tex}" _n
        file write maintex "" _n
        file write maintex "\section{Estadísticas descriptivas y caracterización del fenómeno}" _n
        file write maintex "\input{sections/06_results.tex}" _n
        file write maintex "" _n
        file write maintex "\section{Conclusiones}" _n
        file write maintex "\input{sections/07_conclusions.tex}" _n
        file write maintex "" _n
        file write maintex "\newpage" _n
        file write maintex "\bibliographystyle{apalike-doi}" _n
        file write maintex "\bibliography{bibliography/references}" _n
        file write maintex "" _n
        file write maintex "\appendix" _n
        file write maintex "\newpage" _n
        file write maintex "\section{Anexo}" _n
        file write maintex "\input{sections/08_appendix.tex}" _n
        file write maintex "" _n
        file write maintex "\end{document}" _n
    }
    else {
        * Standard article template
        file write maintex "\documentclass[12pt]{article}" _n
        file write maintex "\usepackage[utf8]{inputenc}" _n
        file write maintex "\usepackage{amsmath,amssymb}" _n
        file write maintex "\usepackage{graphicx}" _n
        file write maintex "\usepackage{booktabs}" _n
        file write maintex "\usepackage{hyperref}" _n
        file write maintex "\usepackage[margin=2.5cm]{geometry}" _n
        file write maintex "" _n
        file write maintex "\title{`projname'}" _n
        file write maintex "\author{`author'}" _n
        file write maintex "\date{\today}" _n
        file write maintex "" _n
        file write maintex "\input{preamble.tex}" _n
        file write maintex "\input{macros.tex}" _n
        file write maintex "" _n
        file write maintex "\begin{document}" _n
        file write maintex "" _n
        file write maintex "\maketitle" _n
        file write maintex "\begin{abstract}" _n
        file write maintex "Your abstract here." _n
        file write maintex "\end{abstract}" _n
        file write maintex "" _n
        file write maintex "\section{Introduction}" _n
        file write maintex "\input{sections/01_introduction.tex}" _n
        file write maintex "" _n
        file write maintex "\section{Data and Methodology}" _n
        file write maintex "\input{sections/02_data.tex}" _n
        file write maintex "" _n
        file write maintex "\section{Results}" _n
        file write maintex "\input{sections/03_results.tex}" _n
        file write maintex "" _n
        file write maintex "\section{Conclusion}" _n
        file write maintex "\input{sections/04_conclusion.tex}" _n
        file write maintex "" _n
        file write maintex "\bibliographystyle{apalike}" _n
        file write maintex "\bibliography{bibliography/references}" _n
        file write maintex "" _n
        file write maintex "\end{document}" _n
    }
    file close maintex

    * Create preamble.tex
    file open preamble using `"`path'/04_Writing/preamble.tex"', write replace
    file write preamble "% Custom packages and settings" _n
    file write preamble "" _n
    file write preamble "% Tables" _n
    file write preamble "\usepackage{array}" _n
    file write preamble "\usepackage{multirow}" _n
    file write preamble "\usepackage{longtable}" _n
    file write preamble "" _n
    file write preamble "% Figures" _n
    file write preamble "\usepackage{subcaption}" _n
    file write preamble "\graphicspath{{figures/}}" _n
    file write preamble "" _n
    file write preamble "% Math" _n
    file write preamble "\usepackage{amsthm}" _n
    file write preamble "\newtheorem{theorem}{Theorem}" _n
    file write preamble "\newtheorem{proposition}{Proposition}" _n
    file close preamble

    * Create macros.tex (empty template for Stata-generated macros)
    file open macros using `"`path'/04_Writing/macros.tex"', write replace
    file write macros "% Auto-generated macros from Stata" _n
    file write macros "% Use Stata to write commands like:" _n
    file write macros "% \newcommand{\samplesize}{1234}" _n
    file write macros "% \newcommand{\meanage}{45.6}" _n
    file write macros "" _n
    file write macros "% Example usage in LaTeX:" _n
    file write macros "% Our sample contains \samplesize observations." _n
    file close macros

    * Create section templates based on template type
    if "`template'" == "puc" {
        * PUC format - Spanish sections
        file open intro using `"`path'/04_Writing/sections/01_introduction.tex"', write replace
        file write intro "\section{Introducción}" _n
        file write intro "" _n
        file write intro "% Escribe tu introducción aquí..." _n
        file close intro

        file open lit using `"`path'/04_Writing/sections/02_literature.tex"', write replace
        file write lit "% Revisión de Literatura" _n
        file write lit "" _n
        file write lit "% Escribe la revisión de literatura aquí..." _n
        file close lit

        file open framework using `"`path'/04_Writing/sections/03_framework.tex"', write replace
        file write framework "% Marco Conceptual" _n
        file write framework "" _n
        file write framework "% Escribe el marco conceptual aquí..." _n
        file close framework

        file open data using `"`path'/04_Writing/sections/04_data.tex"', write replace
        file write data "% Datos" _n
        file write data "" _n
        file write data "% Describe los datos aquí..." _n
        file close data

        file open method using `"`path'/04_Writing/sections/05_methodology.tex"', write replace
        file write method "% Estrategia Empírica" _n
        file write method "" _n
        file write method "% Describe la metodología aquí..." _n
        file close method

        file open results using `"`path'/04_Writing/sections/06_results.tex"', write replace
        file write results "% Resultados" _n
        file write results "" _n
        file write results "% La Tabla~\ref{tab:main} presenta los resultados principales..." _n
        file close results

        file open conclusion using `"`path'/04_Writing/sections/07_conclusions.tex"', write replace
        file write conclusion "% Conclusiones" _n
        file write conclusion "" _n
        file write conclusion "% Escribe las conclusiones aquí..." _n
        file close conclusion

        file open appendix using `"`path'/04_Writing/sections/08_appendix.tex"', write replace
        file write appendix "% Anexo" _n
        file write appendix "" _n
        file write appendix "% Material adicional..." _n
        file close appendix
    }
    else {
        * Standard format - English sections
        file open intro using `"`path'/04_Writing/sections/01_introduction.tex"', write replace
        file write intro "% Introduction" _n
        file write intro "" _n
        file write intro "This paper examines..." _n
        file close intro

        file open data using `"`path'/04_Writing/sections/02_data.tex"', write replace
        file write data "% Data and Methodology" _n
        file write data "" _n
        file write data "We use data from..." _n
        file close data

        file open results using `"`path'/04_Writing/sections/03_results.tex"', write replace
        file write results "% Results" _n
        file write results "" _n
        file write results "Table~\ref{tab:main} presents our main results..." _n
        file close results

        file open conclusion using `"`path'/04_Writing/sections/04_conclusion.tex"', write replace
        file write conclusion "% Conclusion" _n
        file write conclusion "" _n
        file write conclusion "In conclusion..." _n
        file close conclusion
    }

    * Create bibliography file
    file open bib using `"`path'/04_Writing/bibliography/references.bib"', write replace
    file write bib "@article{example2020," _n
    file write bib "  author = {Author, First}," _n
    file write bib "  title = {Paper Title}," _n
    file write bib "  journal = {Journal Name}," _n
    file write bib "  year = {2020}," _n
    file write bib "  volume = {1}," _n
    file write bib "  pages = {1--20}" _n
    file write bib "}" _n
    file close bib

    di as result "  ✓ LaTeX environment created (04_Writing/)"
    di as text "    Template: `template'"
    di as text "    Files: main.tex, preamble.tex, macros.tex"
end
