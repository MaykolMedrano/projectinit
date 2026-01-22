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
    di as txt "  {bf:1.} Navigate: {it:cd \"`mainpath'\"}"
    di as txt "  {bf:2.} Review:   {it:doedit run.do}"
    di as txt "  {bf:3.} Execute:  {it:do run.do}"
    if "`latex'" != "none" {
        di as txt "  {bf:4.} LaTeX:    Import {it:04_Writing/} to Overleaf"
        di as txt "             {browse \"https://www.overleaf.com/project\":https://www.overleaf.com/project}"
    }
    if "`github'" != "none" {
        di as txt "  {bf:5.} GitHub:   {it:gh repo view --web}"
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
    file write runfile `"global root "\`c(pwd)'"' _n"' _n
    file write runfile "" _n
    file write runfile "* Data directories (J-PAL/DIME standard)" _n
    file write runfile "global data          \"\$root/01_Data\"" _n
    file write runfile "global raw           \"\$data/Raw\"" _n
    file write runfile "global deidentified  \"\$data/De-identified\"" _n
    file write runfile "global intermediate  \"\$data/Intermediate\"" _n
    file write runfile "global final         \"\$data/Final\"" _n
    file write runfile "" _n
    file write runfile "* Script directories (NBER standard)" _n
    file write runfile "global scripts       \"\$root/02_Scripts\"" _n
    file write runfile "global ados          \"\$scripts/Ados\"" _n
    file write runfile "global dataprep      \"\$scripts/Data_Preparation\"" _n
    file write runfile "global analysis      \"\$scripts/Analysis\"" _n
    file write runfile "global validation    \"\$scripts/Validation\"" _n
    file write runfile "" _n
    file write runfile "* Output directories (AEA standard)" _n
    file write runfile "global outputs       \"\$root/03_Outputs\"" _n
    file write runfile "global tables        \"\$outputs/Tables\"" _n
    file write runfile "global figures       \"\$outputs/Figures\"" _n
    file write runfile "global logs          \"\$outputs/Logs\"" _n
    file write runfile "global rawout        \"\$outputs/Raw_Outputs\"" _n
    file write runfile "" _n
    file write runfile "* Documentation" _n
    file write runfile "global doc           \"\$root/05_Doc\"" _n
    file write runfile "global codebooks     \"\$doc/Codebooks\"" _n
    file write runfile "" _n
    file write runfile "* Writing (if applicable)" _n
    file write runfile "global writing       \"\$root/04_Writing\"" _n
    file write runfile "" _n
    file write runfile "* Display configuration" _n
    file write runfile "display as text \"\"" _n
    file write runfile "display as result \"{hline 78}\"" _n
    file write runfile "display as result \"PROJECT: `projname'\"" _n
    file write runfile "display as result \"{hline 78}\"" _n
    file write runfile "display as text \"Root:      \$root\"" _n
    file write runfile "display as text \"Started:   \`c(current_date)' \`c(current_time)'\"" _n
    file write runfile "display as text \"User:      \`c(username)'\"" _n
    file write runfile "display as text \"Stata:     `c(stata_version)' (`c(flavor)')\"" _n
    file write runfile "display as result \"{hline 78}\"" _n
    file write runfile "display as text \"\"" _n
    file write runfile "" _n
    file write runfile "/*******************************************************************************" _n
    file write runfile "SECTION 2: ENVIRONMENT ISOLATION (NBER Standard)" _n
    file write runfile "================================================================================" _n
    file write runfile "Rationale: Use project-specific ado files to avoid conflicts with global" _n
    file write runfile "installations. This ensures package versions remain consistent." _n
    file write runfile "*******************************************************************************/" _n
    file write runfile "" _n
    file write runfile "* Add local ado directory to search path (highest priority)" _n
    file write runfile "adopath ++ \"\$ados\"" _n
    file write runfile "" _n
    file write runfile "* Display adopath for verification" _n
    file write runfile "adopath" _n
    file write runfile "display as text \"\"" _n
    file write runfile "" _n
    file write runfile "/*******************************************************************************" _n
    file write runfile "SECTION 3: DEPENDENCY MANAGEMENT (Automated Installation)" _n
    file write runfile "================================================================================" _n
    file write runfile "Rationale: Automatically install required packages if missing." _n
    file write runfile "*******************************************************************************/" _n
    file write runfile "" _n
    file write runfile "* Core packages (customize as needed)" _n
    file write runfile "local packages \"\"" _n
    file write runfile "local packages \`packages' \"estout\"      // Table export" _n
    file write runfile "local packages \`packages' \"reghdfe\"     // High-dimensional FE" _n
    file write runfile "local packages \`packages' \"ftools\"      // Fast collapse/join" _n
    file write runfile "local packages \`packages' \"grc1leg\"     // Combined graphs" _n
    file write runfile "local packages \`packages' \"coefplot\"    // Coefficient plots" _n
    file write runfile "" _n
    file write runfile "* Latin American microdata packages (uncomment if needed)" _n
    file write runfile "* local packages \`packages' \"usecasen\"    // Chile CASEN" _n
    file write runfile "* local packages \`packages' \"enahodata\"   // Peru ENAHO" _n
    file write runfile "* local packages \`packages' \"usebcrp\"     // Peru Central Bank" _n
    file write runfile "* local packages \`packages' \"fixencoding\" // Character encoding" _n
    file write runfile "* local packages \`packages' \"datadex\"     // Data exploration" _n
    file write runfile "" _n
    file write runfile "* Installation loop" _n
    file write runfile "display as text \"Checking dependencies...\"" _n
    file write runfile "foreach pkg of local packages {" _n
    file write runfile "    capture which \`pkg'" _n
    file write runfile "    if _rc {" _n
    file write runfile "        display as text \"  Installing \`pkg'...\"" _n
    file write runfile "        capture ssc install \`pkg', replace" _n
    file write runfile "        if _rc {" _n
    file write runfile "            display as error \"  Warning: Could not install \`pkg'\"" _n
    file write runfile "            display as error \"  Install manually or check internet connection\"" _n
    file write runfile "        }" _n
    file write runfile "        else {" _n
    file write runfile "            display as result \"  ✓ Installed \`pkg'\"" _n
    file write runfile "        }" _n
    file write runfile "    }" _n
    file write runfile "    else {" _n
    file write runfile "        display as result \"  ✓ \`pkg' available\"" _n
    file write runfile "    }" _n
    file write runfile "}" _n
    file write runfile "display as text \"\"" _n
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
    file write runfile "local datetime = subinstr(\"\`c(current_date)' \`c(current_time)'\", \" \", \"_\", .)" _n
    file write runfile "local datetime = subinstr(\"\`datetime'\", \":\", \"-\", .)" _n
    file write runfile "" _n
    file write runfile "* Open master log" _n
    file write runfile "log using \"\$logs/run_\`datetime'.log\", replace text name(masterlog)" _n
    file write runfile "" _n
    file write runfile "* Log system information" _n
    file write runfile "display \"Software: Stata \`c(stata_version)' (\`c(flavor)')\"" _n
    file write runfile "display \"OS: \`c(os)' \`c(osdtl)'\"" _n
    file write runfile "display \"Memory: \`c(memory)' bytes\"" _n
    file write runfile "display \"Processors: \`c(processors)'\"" _n
    file write runfile "display \"Seed: \`c(seed)'\"" _n
    file write runfile "display \"\"" _n
    file write runfile "" _n
    file write runfile "/*******************************************************************************" _n
    file write runfile "SECTION 6: SEQUENTIAL EXECUTION" _n
    file write runfile "================================================================================" _n
    file write runfile "Instructions: Uncomment scripts as you develop them. Run in numerical order." _n
    file write runfile "*******************************************************************************/" _n
    file write runfile "" _n
    file write runfile "* Setup" _n
    file write runfile "display as result \"Stage 1: Setup\"" _n
    file write runfile "do \"\$scripts/00_setup.do\"" _n
    file write runfile "" _n
    file write runfile "* Data Preparation" _n
    file write runfile "display as result \"\"" _n
    file write runfile "display as result \"Stage 2: Data Preparation\"" _n
    file write runfile "* do \"\$dataprep/01_import.do\"" _n
    file write runfile "* do \"\$dataprep/02_clean.do\"" _n
    file write runfile "* do \"\$dataprep/03_merge.do\"" _n
    file write runfile "* do \"\$dataprep/04_construct.do\"" _n
    file write runfile "" _n
    file write runfile "* Analysis" _n
    file write runfile "display as result \"\"" _n
    file write runfile "display as result \"Stage 3: Analysis\"" _n
    file write runfile "* do \"\$analysis/01_descriptive.do\"" _n
    file write runfile "* do \"\$analysis/02_main_results.do\"" _n
    file write runfile "* do \"\$analysis/03_robustness.do\"" _n
    file write runfile "* do \"\$analysis/04_heterogeneity.do\"" _n
    file write runfile "" _n
    file write runfile "* Validation" _n
    file write runfile "display as result \"\"" _n
    file write runfile "display as result \"Stage 4: Validation\"" _n
    file write runfile "* do \"\$validation/01_balance_checks.do\"" _n
    file write runfile "* do \"\$validation/02_placebo_tests.do\"" _n
    file write runfile "* do \"\$validation/03_data_quality.do\"" _n
    file write runfile "" _n
    file write runfile "/*******************************************************************************" _n
    file write runfile "SECTION 7: COMPLETION" _n
    file write runfile "*******************************************************************************/" _n
    file write runfile "" _n
    file write runfile "display \"\"" _n
    file write runfile "display as result \"{hline 78}\"" _n
    file write runfile "display as result \"PROJECT EXECUTION COMPLETED\"" _n
    file write runfile "display as result \"{hline 78}\"" _n
    file write runfile "display as text \"Finished: \`c(current_date)' \`c(current_time)'\"" _n
    file write runfile "display as text \"Duration: TBD (implement timer if needed)\"" _n
    file write runfile "display as text \"Log file: \$logs/run_\`datetime'.log\"" _n
    file write runfile "display as result \"{hline 78}\"" _n
    file write runfile "display \"\"" _n
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
        file write setupfile "display as text \"System diagnostics:\"" _n
        file write setupfile "display as text \"  Stata version: \`c(stata_version)'\"" _n
        file write setupfile "display as text \"  Flavor: \`c(flavor)'\"" _n
        file write setupfile "display as text \"  OS: \`c(os)'\"" _n
        file write setupfile "display as text \"  Processors: \`c(processors)'\"" _n
        file write setupfile "display as text \"  Memory: \`c(memory)' bytes\"" _n
        file write setupfile "display as text \"\"" _n
        file write setupfile "" _n
        file write setupfile "* Verify critical paths exist" _n
        file write setupfile "local critical_paths \"\$data\" \"\$scripts\" \"\$outputs\"" _n
        file write setupfile "foreach path of local critical_paths {" _n
        file write setupfile "    capture confirm file \"\`path'\"" _n
        file write setupfile "    if _rc {" _n
        file write setupfile "        display as error \"Critical path not found: \`path'\"" _n
        file write setupfile "        exit 601" _n
        file write setupfile "    }" _n
        file write setupfile "}" _n
        file write setupfile "" _n
        file write setupfile "display as result \"✓ All critical paths verified\"" _n
        file write setupfile "display as text \"\"" _n
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
        file write setupfile "display as text \"Diagnóstico del sistema:\"" _n
        file write setupfile "display as text \"  Versión Stata: \`c(stata_version)'\"" _n
        file write setupfile "display as text \"  Tipo: \`c(flavor)'\"" _n
        file write setupfile "display as text \"  OS: \`c(os)'\"" _n
        file write setupfile "display as text \"  Procesadores: \`c(processors)'\"" _n
        file write setupfile "display as text \"  Memoria: \`c(memory)' bytes\"" _n
        file write setupfile "display as text \"\"" _n
        file write setupfile "" _n
        file write setupfile "* Verificar que las rutas críticas existan" _n
        file write setupfile "local critical_paths \"\$data\" \"\$scripts\" \"\$outputs\"" _n
        file write setupfile "foreach path of local critical_paths {" _n
        file write setupfile "    capture confirm file \"\`path'\"" _n
        file write setupfile "    if _rc {" _n
        file write setupfile "        display as error \"Ruta crítica no encontrada: \`path'\"" _n
        file write setupfile "        exit 601" _n
        file write setupfile "    }" _n
        file write setupfile "}" _n
        file write setupfile "" _n
        file write setupfile "display as result \"✓ Todas las rutas críticas verificadas\"" _n
        file write setupfile "display as text \"\"" _n
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
        file write readmefile "   cd \"path/to/`projname'\"" _n
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
        file write readmefile "   cd \"ruta/a/`projname'\"" _n
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
    file write readmefile "`author' (`c(current_year)'). \"`projname'\"." _n
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
