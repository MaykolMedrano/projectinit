*! version 1.0.0  11dec2025
*! Professional Stata Project Initializer (AEA/JPAL/MIT Standard)
*! Author: Maykol Medrano
*! Email: mmedrano2@uc.cl
*! GitHub: https://github.com/MaykolMedrano/projectinit
*! Description: Creates standardized, reproducible research project structure

program define projectinit, rclass
    version 14.0

    syntax anything(name=projname id="Project name"), ///
        ROOT(string)                                  ///
        [OVERwrite                                    ///
         REPLicate                                    ///
         TEMplate(string)                             ///
         VERBose]

    * Display header
    di as txt ""
    di as txt "{hline 70}"
    di as txt "{bf:projectinit} - Professional Research Project Initializer"
    di as txt "{hline 70}"
    di as txt ""

    * Clean project name (remove quotes if present)
    local projname = trim(`"`projname'"')
    local projname = subinstr(`"`projname'"', `"""', "", .)

    * Validate inputs
    if `"`projname'"' == "" {
        di as error "Error: Project name cannot be empty"
        exit 198
    }

    * Construct full project path
    local mainpath = `"`root'/`projname'"'

    * Check if project exists
    capture confirm file `"`mainpath'"'
    local exists = (_rc == 0)

    if `exists' & "`overwrite'" == "" {
        di as error "Error: Project folder already exists at:"
        di as error "  `mainpath'"
        di as txt ""
        di as txt "Options:"
        di as txt "  1. Use option {bf:overwrite} to recreate the structure"
        di as txt "  2. Choose a different project name"
        di as txt "  3. Delete the existing folder manually"
        exit 602
    }

    if `exists' & "`overwrite'" != "" {
        di as txt "⚠ Overwriting existing project at:"
        di as txt "  `mainpath'"
        di as txt ""
    }

    * Verbose mode
    local quiet = cond("`verbose'" != "", "", "quietly")

    * Create main project directory
    capture mkdir `"`mainpath'"'
    if _rc & _rc != 693 {
        di as error "Error: Could not create main project folder"
        di as error "  Path: `mainpath'"
        di as error "  Check permissions and path validity"
        exit _rc
    }

    di as txt "📁 Creating project: {bf:`projname'}"
    di as txt "📍 Location: `mainpath'"
    di as txt ""

    * Define folder structure
    local folders ""
    local folders `folders' "00_docs"
    local folders `folders' "01_data"
    local folders `folders' "01_data/raw"
    local folders `folders' "01_data/external"
    local folders `folders' "01_data/intermediate"
    local folders `folders' "01_data/final"
    local folders `folders' "02_code"
    local folders `folders' "02_code/00_setup"
    local folders `folders' "02_code/01_cleaning"
    local folders `folders' "02_code/02_analysis"
    local folders `folders' "02_code/03_figures"
    local folders `folders' "02_code/04_tables"
    local folders `folders' "03_output"
    local folders `folders' "03_output/figures"
    local folders `folders' "03_output/tables"
    local folders `folders' "03_output/logs"
    local folders `folders' "temp"
    local folders `folders' "data_backup"

    if "`replicate'" != "" {
        local folders `folders' "04_replication"
        local folders `folders' "04_replication/code"
        local folders `folders' "04_replication/data"
        local folders `folders' "04_replication/output"
    }

    * Create all folders
    di as txt "Creating folder structure..."
    di as txt ""
    foreach folder of local folders {
        capture mkdir `"`mainpath'/`folder'"'
        if _rc == 0 | _rc == 693 {
            if "`verbose'" != "" {
                di as txt "  ✅ Created: `folder'"
            }
        }
        else {
            di as error "  ❌ Failed: `folder' (error `=_rc')"
        }
    }

    if "`verbose'" == "" {
        di as txt "  ✅ All folders created successfully"
    }
    di as txt ""

    * Generate configuration file
    di as txt "Generating configuration files..."
    projectinit_config, path(`"`mainpath'"') projname(`"`projname'"')

    * Generate master.do
    projectinit_master, path(`"`mainpath'"') projname(`"`projname'"')

    * Generate setup file
    projectinit_setup, path(`"`mainpath'"') projname(`"`projname'"')

    * Generate run_all.do
    projectinit_runall, path(`"`mainpath'"') projname(`"`projname'"')

    * Generate template do-files
    projectinit_templates, path(`"`mainpath'"')

    * Generate README
    projectinit_readme, path(`"`mainpath'"') projname(`"`projname'"')

    * Generate .gitignore
    projectinit_gitignore, path(`"`mainpath'"')

    * Generate replication files if requested
    if "`replicate'" != "" {
        di as txt "Generating replication package..."
        projectinit_replication, path(`"`mainpath'"') projname(`"`projname'"')
    }

    * Summary
    di as txt ""
    di as txt "{hline 70}"
    di as txt "{bf:Project setup complete!}"
    di as txt "{hline 70}"
    di as txt ""
    di as txt "📂 Project location: `mainpath'"
    di as txt ""
    di as txt "Next steps:"
    di as txt "  1. Navigate to: {bf:cd \"`mainpath'\"}"
    di as txt "  2. Review and edit: {bf:_config.do}"
    di as txt "  3. Start coding: {bf:do master.do}"
    di as txt "  4. Read: {bf:README.md} for detailed instructions"
    di as txt ""
    di as txt "Key files created:"
    di as txt "  • _config.do       - Project paths configuration"
    di as txt "  • master.do        - Main execution file"
    di as txt "  • run_all.do       - Automated execution script"
    di as txt "  • 00_setup.do      - Setup and package installation"
    di as txt "  • README.md        - Project documentation"
    di as txt "  • .gitignore       - Git configuration"
    if "`replicate'" != "" {
        di as txt "  • replication.do   - Replication instructions"
    }
    di as txt ""
    di as txt "{hline 70}"

    * Return values
    return local projname "`projname'"
    return local mainpath "`mainpath'"
    return local created  "success"

end

********************************************************************************
* Subprogram: Generate _config.do
********************************************************************************
program define projectinit_config
    syntax, PATH(string) PROJname(string)

    file open configfile using `"`path'/_config.do"', write replace

    file write configfile "****************************************************" _n
    file write configfile "* PROJECT CONFIGURATION FILE" _n
    file write configfile "* Project: `projname'" _n
    file write configfile "* Created: `c(current_date)'" _n
    file write configfile "* Style: AEA/JPAL/MIT Standard" _n
    file write configfile "****************************************************" _n
    file write configfile "" _n
    file write configfile "* Main project path (CHANGE THIS TO YOUR LOCAL PATH)" _n
    file write configfile `"global ROOT "`path'""' _n
    file write configfile "" _n
    file write configfile "* Documentation" _n
    file write configfile `"global docs "\$ROOT/00_docs""' _n
    file write configfile "" _n
    file write configfile "* Data folders" _n
    file write configfile `"global data "\$ROOT/01_data""' _n
    file write configfile `"global raw "\$data/raw""' _n
    file write configfile `"global external "\$data/external""' _n
    file write configfile `"global intermediate "\$data/intermediate""' _n
    file write configfile `"global final "\$data/final""' _n
    file write configfile "" _n
    file write configfile "* Code folders" _n
    file write configfile `"global code "\$ROOT/02_code""' _n
    file write configfile `"global setup "\$code/00_setup""' _n
    file write configfile `"global cleaning "\$code/01_cleaning""' _n
    file write configfile `"global analysis "\$code/02_analysis""' _n
    file write configfile `"global figures_code "\$code/03_figures""' _n
    file write configfile `"global tables_code "\$code/04_tables""' _n
    file write configfile "" _n
    file write configfile "* Output folders" _n
    file write configfile `"global output "\$ROOT/03_output""' _n
    file write configfile `"global figures "\$output/figures""' _n
    file write configfile `"global tables "\$output/tables""' _n
    file write configfile `"global logs "\$output/logs""' _n
    file write configfile "" _n
    file write configfile "* Additional folders" _n
    file write configfile `"global temp "\$ROOT/temp""' _n
    file write configfile `"global backup "\$ROOT/data_backup""' _n
    file write configfile `"global replication "\$ROOT/04_replication""' _n
    file write configfile "" _n
    file write configfile "* Verify all paths exist" _n
    file write configfile "local paths \`\"\$docs\" \"\$raw\" \"\$external\" \"\$intermediate\" \"\$final\"' ////" _n
    file write configfile "    \"\$setup\" \"\$cleaning\" \"\$analysis\" \"\$figures_code\" \"\$tables_code\" ////" _n
    file write configfile "    \"\$figures\" \"\$tables\" \"\$logs\" \"\$temp\" \"\$backup\"'" _n
    file write configfile "" _n
    file write configfile "foreach p of local paths {" _n
    file write configfile "    capture confirm file \`\"\`p'\"'" _n
    file write configfile "    if _rc {" _n
    file write configfile "        display as error \"Warning: Path does not exist: \`p'\"" _n
    file write configfile "    }" _n
    file write configfile "}" _n
    file write configfile "" _n
    file write configfile "display as text \"\"" _n
    file write configfile "display as text \"Configuration loaded successfully\"" _n
    file write configfile "display as text \"Project: `projname'\"" _n
    file write configfile "display as text \"Root: \$ROOT\"" _n
    file write configfile "display as text \"\"" _n

    file close configfile

    di as txt "  ✅ Created: _config.do"
end

********************************************************************************
* Subprogram: Generate master.do
********************************************************************************
program define projectinit_master
    syntax, PATH(string) PROJname(string)

    file open masterfile using `"`path'/master.do"', write replace

    file write masterfile "****************************************************" _n
    file write masterfile "* MASTER DO-FILE" _n
    file write masterfile "* Project: `projname'" _n
    file write masterfile "* Created: `c(current_date)'" _n
    file write masterfile "* Purpose: Main execution file for the project" _n
    file write masterfile "****************************************************" _n
    file write masterfile "" _n
    file write masterfile "clear all" _n
    file write masterfile "macro drop _all" _n
    file write masterfile "" _n
    file write masterfile "* Load project configuration" _n
    file write masterfile "do \"_config.do\"" _n
    file write masterfile "" _n
    file write masterfile "* Start master log with timestamp" _n
    file write masterfile "local datetime = subinstr(\"\`c(current_date)' \`c(current_time)'\", \" \", \"_\", .)" _n
    file write masterfile "local datetime = subinstr(\"\`datetime'\", \":\", \"\", .)" _n
    file write masterfile "log using \"\$logs/master_\`datetime'.log\", replace text name(masterlog)" _n
    file write masterfile "" _n
    file write masterfile "display as text \"\"" _n
    file write masterfile "display as text \"{hline 70}\"" _n
    file write masterfile "display as text \"PROJECT: `projname'\"" _n
    file write masterfile "display as text \"Started: \`c(current_date)' \`c(current_time)'\"" _n
    file write masterfile "display as text \"{hline 70}\"" _n
    file write masterfile "display as text \"\"" _n
    file write masterfile "" _n
    file write masterfile "* Run setup" _n
    file write masterfile "display as text \"Running setup...\"" _n
    file write masterfile "do \"\$setup/00_setup.do\"" _n
    file write masterfile "" _n
    file write masterfile "* Run data cleaning" _n
    file write masterfile "display as text \"\"" _n
    file write masterfile "display as text \"Running data cleaning...\"" _n
    file write masterfile "do \"\$cleaning/00_clean.do\"" _n
    file write masterfile "" _n
    file write masterfile "* Run analysis" _n
    file write masterfile "display as text \"\"" _n
    file write masterfile "display as text \"Running analysis...\"" _n
    file write masterfile "do \"\$analysis/00_analysis.do\"" _n
    file write masterfile "" _n
    file write masterfile "* Generate figures" _n
    file write masterfile "display as text \"\"" _n
    file write masterfile "display as text \"Generating figures...\"" _n
    file write masterfile "do \"\$figures_code/00_figures.do\"" _n
    file write masterfile "" _n
    file write masterfile "* Generate tables" _n
    file write masterfile "display as text \"\"" _n
    file write masterfile "display as text \"Generating tables...\"" _n
    file write masterfile "do \"\$tables_code/00_tables.do\"" _n
    file write masterfile "" _n
    file write masterfile "* End" _n
    file write masterfile "display as text \"\"" _n
    file write masterfile "display as text \"{hline 70}\"" _n
    file write masterfile "display as text \"PROJECT COMPLETED SUCCESSFULLY\"" _n
    file write masterfile "display as text \"Finished: \`c(current_date)' \`c(current_time)'\"" _n
    file write masterfile "display as text \"{hline 70}\"" _n
    file write masterfile "" _n
    file write masterfile "log close masterlog" _n
    file write masterfile "" _n
    file write masterfile "* Alternative: Use run_all.do for automated execution" _n
    file write masterfile "* do \"run_all.do\"" _n

    file close masterfile

    di as txt "  ✅ Created: master.do"
end

********************************************************************************
* Subprogram: Generate 00_setup.do
********************************************************************************
program define projectinit_setup
    syntax, PATH(string) PROJname(string)

    file open setupfile using `"`path'/02_code/00_setup/00_setup.do"', write replace

    file write setupfile "****************************************************" _n
    file write setupfile "* SETUP FILE" _n
    file write setupfile "* Project: `projname'" _n
    file write setupfile "* Created: `c(current_date)'" _n
    file write setupfile "* Purpose: Initial setup, checks, and package installation" _n
    file write setupfile "****************************************************" _n
    file write setupfile "" _n
    file write setupfile "* Stata version compatibility" _n
    file write setupfile "version 14.0" _n
    file write setupfile "" _n
    file write setupfile "* General settings" _n
    file write setupfile "clear all" _n
    file write setupfile "set more off" _n
    file write setupfile "set varabbrev off" _n
    file write setupfile "set linesize 120" _n
    file write setupfile "set maxvar 32000" _n
    file write setupfile "" _n
    file write setupfile "* Set random seed for reproducibility" _n
    file write setupfile "set seed 123456789" _n
    file write setupfile "" _n
    file write setupfile "* Memory settings (adjust as needed)" _n
    file write setupfile "* set max_memory 16g" _n
    file write setupfile "" _n
    file write setupfile "* Check that all required paths exist" _n
    file write setupfile "local required_paths \`\"\$ROOT\" \"\$data\" \"\$code\" \"\$output\"'" _n
    file write setupfile "foreach path of local required_paths {" _n
    file write setupfile "    capture confirm file \`\"\`path'\"'" _n
    file write setupfile "    if _rc {" _n
    file write setupfile "        display as error \"Error: Required path not found: \`path'\"" _n
    file write setupfile "        display as error \"Please check _config.do and update paths\"" _n
    file write setupfile "        exit 601" _n
    file write setupfile "    }" _n
    file write setupfile "}" _n
    file write setupfile "" _n
    file write setupfile "display as text \"All required paths verified\"" _n
    file write setupfile "display as text \"\"" _n
    file write setupfile "" _n
    file write setupfile "****************************************************" _n
    file write setupfile "* PACKAGE INSTALLATION" _n
    file write setupfile "****************************************************" _n
    file write setupfile "" _n
    file write setupfile "* Define required packages" _n
    file write setupfile "local packages \"\"" _n
    file write setupfile "* Add your required packages here, e.g.:" _n
    file write setupfile "* local packages \`packages' \"estout\"" _n
    file write setupfile "* local packages \`packages' \"reghdfe\"" _n
    file write setupfile "* local packages \`packages' \"ftools\"" _n
    file write setupfile "* local packages \`packages' \"ivreg2\"" _n
    file write setupfile "* local packages \`packages' \"rangestat\"" _n
    file write setupfile "" _n
    file write setupfile "* Install missing packages" _n
    file write setupfile "if \`\"\`packages'\"' != \"\" {" _n
    file write setupfile "    display as text \"Checking required packages...\"" _n
    file write setupfile "    foreach pkg of local packages {" _n
    file write setupfile "        capture which \`pkg'" _n
    file write setupfile "        if _rc {" _n
    file write setupfile "            display as text \"Installing \`pkg'...\"" _n
    file write setupfile "            ssc install \`pkg', replace" _n
    file write setupfile "        }" _n
    file write setupfile "        else {" _n
    file write setupfile "            display as text \"  ✓ \`pkg' already installed\"" _n
    file write setupfile "        }" _n
    file write setupfile "    }" _n
    file write setupfile "}" _n
    file write setupfile "" _n
    file write setupfile "display as text \"\"" _n
    file write setupfile "display as text \"Setup completed successfully\"" _n
    file write setupfile "display as text \"\"" _n

    file close setupfile

    di as txt "  ✅ Created: 02_code/00_setup/00_setup.do"
end

********************************************************************************
* Subprogram: Generate run_all.do
********************************************************************************
program define projectinit_runall
    syntax, PATH(string) PROJname(string)

    file open runallfile using `"`path'/run_all.do"', write replace

    file write runallfile "****************************************************" _n
    file write runallfile "* RUN ALL - AUTOMATED EXECUTION" _n
    file write runallfile "* Project: `projname'" _n
    file write runallfile "* Created: `c(current_date)'" _n
    file write runallfile "* Purpose: Execute all do-files in correct order" _n
    file write runallfile "****************************************************" _n
    file write runallfile "" _n
    file write runallfile "clear all" _n
    file write runallfile "macro drop _all" _n
    file write runallfile "" _n
    file write runallfile "* Load configuration" _n
    file write runallfile "do \"_config.do\"" _n
    file write runallfile "" _n
    file write runallfile "* Create timestamp for log" _n
    file write runallfile "local datetime = subinstr(\"\`c(current_date)' \`c(current_time)'\", \" \", \"_\", .)" _n
    file write runallfile "local datetime = subinstr(\"\`datetime'\", \":\", \"\", .)" _n
    file write runallfile "log using \"\$logs/run_all_\`datetime'.log\", replace text name(runall)" _n
    file write runallfile "" _n
    file write runallfile "display as text \"\"" _n
    file write runallfile "display as text \"{hline 70}\"" _n
    file write runallfile "display as text \"RUN ALL - `projname'\"" _n
    file write runallfile "display as text \"Started: \`c(current_date)' \`c(current_time)'\"" _n
    file write runallfile "display as text \"{hline 70}\"" _n
    file write runallfile "display as text \"\"" _n
    file write runallfile "" _n
    file write runallfile "****************************************************" _n
    file write runallfile "* STAGE 1: SETUP" _n
    file write runallfile "****************************************************" _n
    file write runallfile "display as text \"STAGE 1: Setup and configuration\"" _n
    file write runallfile "display as text \"\"" _n
    file write runallfile "" _n
    file write runallfile "local setup_files: dir \"\$setup\" files \"*.do\"" _n
    file write runallfile "foreach file of local setup_files {" _n
    file write runallfile "    display as text \"  → Running: \`file'\"" _n
    file write runallfile "    do \"\$setup/\`file'\"" _n
    file write runallfile "}" _n
    file write runallfile "" _n
    file write runallfile "****************************************************" _n
    file write runallfile "* STAGE 2: DATA CLEANING" _n
    file write runallfile "****************************************************" _n
    file write runallfile "display as text \"\"" _n
    file write runallfile "display as text \"STAGE 2: Data cleaning\"" _n
    file write runallfile "display as text \"\"" _n
    file write runallfile "" _n
    file write runallfile "local cleaning_files: dir \"\$cleaning\" files \"*.do\"" _n
    file write runallfile "foreach file of local cleaning_files {" _n
    file write runallfile "    display as text \"  → Running: \`file'\"" _n
    file write runallfile "    do \"\$cleaning/\`file'\"" _n
    file write runallfile "}" _n
    file write runallfile "" _n
    file write runallfile "****************************************************" _n
    file write runallfile "* STAGE 3: ANALYSIS" _n
    file write runallfile "****************************************************" _n
    file write runallfile "display as text \"\"" _n
    file write runallfile "display as text \"STAGE 3: Analysis\"" _n
    file write runallfile "display as text \"\"" _n
    file write runallfile "" _n
    file write runallfile "local analysis_files: dir \"\$analysis\" files \"*.do\"" _n
    file write runallfile "foreach file of local analysis_files {" _n
    file write runallfile "    display as text \"  → Running: \`file'\"" _n
    file write runallfile "    do \"\$analysis/\`file'\"" _n
    file write runallfile "}" _n
    file write runallfile "" _n
    file write runallfile "****************************************************" _n
    file write runallfile "* STAGE 4: FIGURES" _n
    file write runallfile "****************************************************" _n
    file write runallfile "display as text \"\"" _n
    file write runallfile "display as text \"STAGE 4: Generating figures\"" _n
    file write runallfile "display as text \"\"" _n
    file write runallfile "" _n
    file write runallfile "local figures_files: dir \"\$figures_code\" files \"*.do\"" _n
    file write runallfile "foreach file of local figures_files {" _n
    file write runallfile "    display as text \"  → Running: \`file'\"" _n
    file write runallfile "    do \"\$figures_code/\`file'\"" _n
    file write runallfile "}" _n
    file write runallfile "" _n
    file write runallfile "****************************************************" _n
    file write runallfile "* STAGE 5: TABLES" _n
    file write runallfile "****************************************************" _n
    file write runallfile "display as text \"\"" _n
    file write runallfile "display as text \"STAGE 5: Generating tables\"" _n
    file write runallfile "display as text \"\"" _n
    file write runallfile "" _n
    file write runallfile "local tables_files: dir \"\$tables_code\" files \"*.do\"" _n
    file write runallfile "foreach file of local tables_files {" _n
    file write runallfile "    display as text \"  → Running: \`file'\"" _n
    file write runallfile "    do \"\$tables_code/\`file'\"" _n
    file write runallfile "}" _n
    file write runallfile "" _n
    file write runallfile "****************************************************" _n
    file write runallfile "* COMPLETION" _n
    file write runallfile "****************************************************" _n
    file write runallfile "display as text \"\"" _n
    file write runallfile "display as text \"{hline 70}\"" _n
    file write runallfile "display as text \"ALL STAGES COMPLETED SUCCESSFULLY\"" _n
    file write runallfile "display as text \"Finished: \`c(current_date)' \`c(current_time)'\"" _n
    file write runallfile "display as text \"Log saved to: \$logs/run_all_\`datetime'.log\"" _n
    file write runallfile "display as text \"{hline 70}\"" _n
    file write runallfile "display as text \"\"" _n
    file write runallfile "" _n
    file write runallfile "log close runall" _n

    file close runallfile

    di as txt "  ✅ Created: run_all.do"
end

********************************************************************************
* Subprogram: Generate template do-files
********************************************************************************
program define projectinit_templates
    syntax, PATH(string)

    * Template: 00_clean.do
    file open cleanfile using `"`path'/02_code/01_cleaning/00_clean.do"', write replace
    file write cleanfile "****************************************************" _n
    file write cleanfile "* DATA CLEANING" _n
    file write cleanfile "* Created: `c(current_date)'" _n
    file write cleanfile "* Purpose: Clean and prepare raw data" _n
    file write cleanfile "****************************************************" _n
    file write cleanfile "" _n
    file write cleanfile "* Start section log" _n
    file write cleanfile "local datetime = subinstr(\"\`c(current_date)' \`c(current_time)'\", \" \", \"_\", .)" _n
    file write cleanfile "local datetime = subinstr(\"\`datetime'\", \":\", \"\", .)" _n
    file write cleanfile "log using \"\$logs/01_cleaning_\`datetime'.log\", replace text" _n
    file write cleanfile "" _n
    file write cleanfile "display as text \"\"" _n
    file write cleanfile "display as text \"Starting data cleaning...\"" _n
    file write cleanfile "display as text \"\"" _n
    file write cleanfile "" _n
    file write cleanfile "****************************************************" _n
    file write cleanfile "* LOAD RAW DATA" _n
    file write cleanfile "****************************************************" _n
    file write cleanfile "" _n
    file write cleanfile "* Example: Load raw dataset" _n
    file write cleanfile "* use \"\$raw/raw_data.dta\", clear" _n
    file write cleanfile "" _n
    file write cleanfile "****************************************************" _n
    file write cleanfile "* DATA CLEANING STEPS" _n
    file write cleanfile "****************************************************" _n
    file write cleanfile "" _n
    file write cleanfile "* 1. Drop duplicates" _n
    file write cleanfile "* duplicates report id" _n
    file write cleanfile "* duplicates drop id, force" _n
    file write cleanfile "" _n
    file write cleanfile "* 2. Handle missing values" _n
    file write cleanfile "* mvdecode _all, mv(-99 -88 -77)" _n
    file write cleanfile "" _n
    file write cleanfile "* 3. Variable renaming and labeling" _n
    file write cleanfile "* rename oldvar newvar" _n
    file write cleanfile "* label variable newvar \"Variable description\"" _n
    file write cleanfile "" _n
    file write cleanfile "* 4. Data type corrections" _n
    file write cleanfile "* destring varname, replace" _n
    file write cleanfile "" _n
    file write cleanfile "* 5. Create derived variables" _n
    file write cleanfile "* gen new_var = expression" _n
    file write cleanfile "" _n
    file write cleanfile "****************************************************" _n
    file write cleanfile "* SAVE CLEANED DATA" _n
    file write cleanfile "****************************************************" _n
    file write cleanfile "" _n
    file write cleanfile "* compress" _n
    file write cleanfile "* save \"\$intermediate/cleaned_data.dta\", replace" _n
    file write cleanfile "" _n
    file write cleanfile "display as text \"\"" _n
    file write cleanfile "display as text \"Data cleaning completed\"" _n
    file write cleanfile "display as text \"\"" _n
    file write cleanfile "" _n
    file write cleanfile "log close" _n
    file close cleanfile

    * Template: 00_analysis.do
    file open analysisfile using `"`path'/02_code/02_analysis/00_analysis.do"', write replace
    file write analysisfile "****************************************************" _n
    file write analysisfile "* STATISTICAL ANALYSIS" _n
    file write analysisfile "* Created: `c(current_date)'" _n
    file write analysisfile "* Purpose: Main statistical analysis" _n
    file write analysisfile "****************************************************" _n
    file write analysisfile "" _n
    file write analysisfile "* Start section log" _n
    file write analysisfile "local datetime = subinstr(\"\`c(current_date)' \`c(current_time)'\", \" \", \"_\", .)" _n
    file write analysisfile "local datetime = subinstr(\"\`datetime'\", \":\", \"\", .)" _n
    file write analysisfile "log using \"\$logs/02_analysis_\`datetime'.log\", replace text" _n
    file write analysisfile "" _n
    file write analysisfile "display as text \"\"" _n
    file write analysisfile "display as text \"Starting analysis...\"" _n
    file write analysisfile "display as text \"\"" _n
    file write analysisfile "" _n
    file write analysisfile "****************************************************" _n
    file write analysisfile "* LOAD ANALYSIS DATA" _n
    file write analysisfile "****************************************************" _n
    file write analysisfile "" _n
    file write analysisfile "* use \"\$intermediate/cleaned_data.dta\", clear" _n
    file write analysisfile "" _n
    file write analysisfile "****************************************************" _n
    file write analysisfile "* DESCRIPTIVE STATISTICS" _n
    file write analysisfile "****************************************************" _n
    file write analysisfile "" _n
    file write analysisfile "* summarize var1 var2 var3" _n
    file write analysisfile "* tabstat var1 var2, by(group) statistics(mean sd min max n)" _n
    file write analysisfile "" _n
    file write analysisfile "****************************************************" _n
    file write analysisfile "* MAIN ANALYSIS" _n
    file write analysisfile "****************************************************" _n
    file write analysisfile "" _n
    file write analysisfile "* Example: OLS regression" _n
    file write analysisfile "* regress y x1 x2 x3, robust" _n
    file write analysisfile "* estimates store model1" _n
    file write analysisfile "" _n
    file write analysisfile "****************************************************" _n
    file write analysisfile "* ROBUSTNESS CHECKS" _n
    file write analysisfile "****************************************************" _n
    file write analysisfile "" _n
    file write analysisfile "* Add robustness checks here" _n
    file write analysisfile "" _n
    file write analysisfile "****************************************************" _n
    file write analysisfile "* SAVE RESULTS" _n
    file write analysisfile "****************************************************" _n
    file write analysisfile "" _n
    file write analysisfile "* Save results for tables/figures" _n
    file write analysisfile "* estimates save \"\$temp/estimates.ster\", replace" _n
    file write analysisfile "" _n
    file write analysisfile "display as text \"\"" _n
    file write analysisfile "display as text \"Analysis completed\"" _n
    file write analysisfile "display as text \"\"" _n
    file write analysisfile "" _n
    file write analysisfile "log close" _n
    file close analysisfile

    * Template: 00_figures.do
    file open figuresfile using `"`path'/02_code/03_figures/00_figures.do"', write replace
    file write figuresfile "****************************************************" _n
    file write figuresfile "* FIGURE GENERATION" _n
    file write figuresfile "* Created: `c(current_date)'" _n
    file write figuresfile "* Purpose: Generate all figures for paper" _n
    file write figuresfile "****************************************************" _n
    file write figuresfile "" _n
    file write figuresfile "* Start section log" _n
    file write figuresfile "local datetime = subinstr(\"\`c(current_date)' \`c(current_time)'\", \" \", \"_\", .)" _n
    file write figuresfile "local datetime = subinstr(\"\`datetime'\", \":\", \"\", .)" _n
    file write figuresfile "log using \"\$logs/03_figures_\`datetime'.log\", replace text" _n
    file write figuresfile "" _n
    file write figuresfile "display as text \"\"" _n
    file write figuresfile "display as text \"Generating figures...\"" _n
    file write figuresfile "display as text \"\"" _n
    file write figuresfile "" _n
    file write figuresfile "****************************************************" _n
    file write figuresfile "* LOAD DATA" _n
    file write figuresfile "****************************************************" _n
    file write figuresfile "" _n
    file write figuresfile "* use \"\$intermediate/cleaned_data.dta\", clear" _n
    file write figuresfile "" _n
    file write figuresfile "****************************************************" _n
    file write figuresfile "* FIGURE 1: Example scatter plot" _n
    file write figuresfile "****************************************************" _n
    file write figuresfile "" _n
    file write figuresfile "* twoway (scatter y x), ///" _n
    file write figuresfile "*     title(\"Figure 1: Relationship between X and Y\") ///" _n
    file write figuresfile "*     xtitle(\"X Variable\") ytitle(\"Y Variable\") ///" _n
    file write figuresfile "*     scheme(s2color) ///" _n
    file write figuresfile "*     graphregion(color(white))" _n
    file write figuresfile "* graph export \"\$figures/figure1.png\", replace width(3000)" _n
    file write figuresfile "* graph export \"\$figures/figure1.pdf\", replace" _n
    file write figuresfile "" _n
    file write figuresfile "****************************************************" _n
    file write figuresfile "* FIGURE 2: Example bar chart" _n
    file write figuresfile "****************************************************" _n
    file write figuresfile "" _n
    file write figuresfile "* graph bar (mean) var1 (mean) var2, ///" _n
    file write figuresfile "*     over(group) ///" _n
    file write figuresfile "*     title(\"Figure 2: Means by Group\") ///" _n
    file write figuresfile "*     legend(label(1 \"Var 1\") label(2 \"Var 2\")) ///" _n
    file write figuresfile "*     scheme(s2color) ///" _n
    file write figuresfile "*     graphregion(color(white))" _n
    file write figuresfile "* graph export \"\$figures/figure2.png\", replace width(3000)" _n
    file write figuresfile "* graph export \"\$figures/figure2.pdf\", replace" _n
    file write figuresfile "" _n
    file write figuresfile "display as text \"\"" _n
    file write figuresfile "display as text \"All figures generated and saved to: \$figures\"" _n
    file write figuresfile "display as text \"\"" _n
    file write figuresfile "" _n
    file write figuresfile "log close" _n
    file close figuresfile

    * Template: 00_tables.do
    file open tablesfile using `"`path'/02_code/04_tables/00_tables.do"', write replace
    file write tablesfile "****************************************************" _n
    file write tablesfile "* TABLE GENERATION" _n
    file write tablesfile "* Created: `c(current_date)'" _n
    file write tablesfile "* Purpose: Generate all tables for paper" _n
    file write tablesfile "****************************************************" _n
    file write tablesfile "" _n
    file write tablesfile "* Start section log" _n
    file write tablesfile "local datetime = subinstr(\"\`c(current_date)' \`c(current_time)'\", \" \", \"_\", .)" _n
    file write tablesfile "local datetime = subinstr(\"\`datetime'\", \":\", \"\", .)" _n
    file write tablesfile "log using \"\$logs/04_tables_\`datetime'.log\", replace text" _n
    file write tablesfile "" _n
    file write tablesfile "display as text \"\"" _n
    file write tablesfile "display as text \"Generating tables...\"" _n
    file write tablesfile "display as text \"\"" _n
    file write tablesfile "" _n
    file write tablesfile "****************************************************" _n
    file write tablesfile "* LOAD DATA" _n
    file write tablesfile "****************************************************" _n
    file write tablesfile "" _n
    file write tablesfile "* use \"\$intermediate/cleaned_data.dta\", clear" _n
    file write tablesfile "" _n
    file write tablesfile "****************************************************" _n
    file write tablesfile "* TABLE 1: Summary statistics" _n
    file write tablesfile "****************************************************" _n
    file write tablesfile "" _n
    file write tablesfile "* Example using estout (install with: ssc install estout)" _n
    file write tablesfile "* estpost summarize var1 var2 var3" _n
    file write tablesfile "* esttab using \"\$tables/table1_summary.tex\", ///" _n
    file write tablesfile "*     cells(\"mean(fmt(2)) sd(fmt(2)) min max count\") ///" _n
    file write tablesfile "*     label nomtitle nonumber replace" _n
    file write tablesfile "" _n
    file write tablesfile "****************************************************" _n
    file write tablesfile "* TABLE 2: Regression results" _n
    file write tablesfile "****************************************************" _n
    file write tablesfile "" _n
    file write tablesfile "* Run regressions" _n
    file write tablesfile "* regress y x1 x2, robust" _n
    file write tablesfile "* estimates store model1" _n
    file write tablesfile "* " _n
    file write tablesfile "* regress y x1 x2 x3, robust" _n
    file write tablesfile "* estimates store model2" _n
    file write tablesfile "" _n
    file write tablesfile "* Export to LaTeX" _n
    file write tablesfile "* esttab model1 model2 using \"\$tables/table2_regression.tex\", ///" _n
    file write tablesfile "*     b(3) se(3) ///" _n
    file write tablesfile "*     star(* 0.10 ** 0.05 *** 0.01) ///" _n
    file write tablesfile "*     label replace ///" _n
    file write tablesfile "*     title(\"Regression Results\") ///" _n
    file write tablesfile "*     addnote(\"Robust standard errors in parentheses\")" _n
    file write tablesfile "" _n
    file write tablesfile "* Export to CSV" _n
    file write tablesfile "* esttab model1 model2 using \"\$tables/table2_regression.csv\", ///" _n
    file write tablesfile "*     b(3) se(3) replace" _n
    file write tablesfile "" _n
    file write tablesfile "display as text \"\"" _n
    file write tablesfile "display as text \"All tables generated and saved to: \$tables\"" _n
    file write tablesfile "display as text \"\"" _n
    file write tablesfile "" _n
    file write tablesfile "log close" _n
    file close tablesfile

    di as txt "  ✅ Created: Template do-files (cleaning, analysis, figures, tables)"
end

********************************************************************************
* Subprogram: Generate README.md
********************************************************************************
program define projectinit_readme
    syntax, PATH(string) PROJname(string)

    file open readmefile using `"`path'/README.md"', write replace

    file write readmefile "# `projname'" _n
    file write readmefile "" _n
    file write readmefile "**Research project created with projectinit**" _n
    file write readmefile "" _n
    file write readmefile "Created: `c(current_date)'" _n
    file write readmefile "" _n
    file write readmefile "## Overview" _n
    file write readmefile "" _n
    file write readmefile "This project follows AEA/JPAL/MIT reproducibility standards." _n
    file write readmefile "" _n
    file write readmefile "## Project Structure" _n
    file write readmefile "" _n
    file write readmefile "\`\`\`" _n
    file write readmefile "`projname'/" _n
    file write readmefile "├── _config.do              # Project paths configuration" _n
    file write readmefile "├── master.do               # Main execution file" _n
    file write readmefile "├── run_all.do              # Automated execution script" _n
    file write readmefile "├── README.md               # This file" _n
    file write readmefile "├── .gitignore              # Git ignore rules" _n
    file write readmefile "│" _n
    file write readmefile "├── 00_docs/                # Documentation and papers" _n
    file write readmefile "│" _n
    file write readmefile "├── 01_data/" _n
    file write readmefile "│   ├── raw/                # Original, immutable data" _n
    file write readmefile "│   ├── external/           # External datasets" _n
    file write readmefile "│   ├── intermediate/       # Processed data" _n
    file write readmefile "│   └── final/              # Final analysis datasets" _n
    file write readmefile "│" _n
    file write readmefile "├── 02_code/" _n
    file write readmefile "│   ├── 00_setup/           # Setup and installation scripts" _n
    file write readmefile "│   ├── 01_cleaning/        # Data cleaning scripts" _n
    file write readmefile "│   ├── 02_analysis/        # Analysis scripts" _n
    file write readmefile "│   ├── 03_figures/         # Figure generation scripts" _n
    file write readmefile "│   └── 04_tables/          # Table generation scripts" _n
    file write readmefile "│" _n
    file write readmefile "├── 03_output/" _n
    file write readmefile "│   ├── figures/            # Generated figures" _n
    file write readmefile "│   ├── tables/             # Generated tables" _n
    file write readmefile "│   └── logs/               # Execution logs" _n
    file write readmefile "│" _n
    file write readmefile "├── 04_replication/         # Replication package (if applicable)" _n
    file write readmefile "├── temp/                   # Temporary files" _n
    file write readmefile "└── data_backup/            # Backup location" _n
    file write readmefile "\`\`\`" _n
    file write readmefile "" _n
    file write readmefile "## Getting Started" _n
    file write readmefile "" _n
    file write readmefile "### 1. Configure Paths" _n
    file write readmefile "" _n
    file write readmefile "Edit \`_config.do\` and update the \`ROOT\` global to match your local path:" _n
    file write readmefile "" _n
    file write readmefile "\`\`\`stata" _n
    file write readmefile "global ROOT \"C:/your/path/here/`projname'\"" _n
    file write readmefile "\`\`\`" _n
    file write readmefile "" _n
    file write readmefile "### 2. Install Required Packages" _n
    file write readmefile "" _n
    file write readmefile "Edit \`02_code/00_setup/00_setup.do\` and add required Stata packages:" _n
    file write readmefile "" _n
    file write readmefile "\`\`\`stata" _n
    file write readmefile "local packages \"estout reghdfe ftools\"" _n
    file write readmefile "\`\`\`" _n
    file write readmefile "" _n
    file write readmefile "### 3. Add Your Data" _n
    file write readmefile "" _n
    file write readmefile "Place raw data files in \`01_data/raw/\`" _n
    file write readmefile "" _n
    file write readmefile "### 4. Run the Project" _n
    file write readmefile "" _n
    file write readmefile "**Option A: Manual execution**" _n
    file write readmefile "" _n
    file write readmefile "\`\`\`stata" _n
    file write readmefile "do master.do" _n
    file write readmefile "\`\`\`" _n
    file write readmefile "" _n
    file write readmefile "**Option B: Automated execution**" _n
    file write readmefile "" _n
    file write readmefile "\`\`\`stata" _n
    file write readmefile "do run_all.do" _n
    file write readmefile "\`\`\`" _n
    file write readmefile "" _n
    file write readmefile "## Workflow" _n
    file write readmefile "" _n
    file write readmefile "1. **Setup** (\`00_setup/\`): Configure environment and install packages" _n
    file write readmefile "2. **Cleaning** (\`01_cleaning/\`): Clean and prepare raw data" _n
    file write readmefile "3. **Analysis** (\`02_analysis/\`): Run statistical analysis" _n
    file write readmefile "4. **Figures** (\`03_figures/\`): Generate all figures" _n
    file write readmefile "5. **Tables** (\`04_tables/\`): Generate all tables" _n
    file write readmefile "" _n
    file write readmefile "## Best Practices" _n
    file write readmefile "" _n
    file write readmefile "- **Never modify raw data**: Keep \`01_data/raw/\` unchanged" _n
    file write readmefile "- **Use relative paths**: All paths should use globals from \`_config.do\`" _n
    file write readmefile "- **Document everything**: Add comments to explain your code" _n
    file write readmefile "- **Version control**: Use git to track changes" _n
    file write readmefile "- **Set random seed**: For reproducibility (done in \`00_setup.do\`)" _n
    file write readmefile "- **Save logs**: All scripts automatically save execution logs" _n
    file write readmefile "" _n
    file write readmefile "## Reproducibility" _n
    file write readmefile "" _n
    file write readmefile "This project follows AEA Data and Code Availability Policy guidelines:" _n
    file write readmefile "" _n
    file write readmefile "- All code is organized sequentially" _n
    file write readmefile "- Paths are configured through a single configuration file" _n
    file write readmefile "- Required packages are documented and auto-installed" _n
    file write readmefile "- Random seed is set for reproducibility" _n
    file write readmefile "- Execution logs are automatically saved" _n
    file write readmefile "" _n
    file write readmefile "## Contact" _n
    file write readmefile "" _n
    file write readmefile "- **Author**: [Your Name]" _n
    file write readmefile "- **Email**: [mmedrano2@uc.cl]" _n
    file write readmefile "- **Institution**: [Your Institution]" _n
    file write readmefile "" _n
    file write readmefile "## License" _n
    file write readmefile "" _n
    file write readmefile "This project is licensed under the MIT License." _n
    file write readmefile "" _n
    file write readmefile "## Citation" _n
    file write readmefile "" _n
    file write readmefile "If you use this project structure, please cite:" _n
    file write readmefile "" _n
    file write readmefile "\`\`\`" _n
    file write readmefile "[Your citation here]" _n
    file write readmefile "\`\`\`" _n
    file write readmefile "" _n
    file write readmefile "## Acknowledgments" _n
    file write readmefile "" _n
    file write readmefile "Project structure created with **projectinit** following AEA/JPAL/MIT standards." _n

    file close readmefile

    di as txt "  ✅ Created: README.md"
end

********************************************************************************
* Subprogram: Generate .gitignore
********************************************************************************
program define projectinit_gitignore
    syntax, PATH(string)

    file open gitignorefile using `"`path'/.gitignore"', write replace

    file write gitignorefile "# Stata project .gitignore" _n
    file write gitignorefile "" _n
    file write gitignorefile "# Raw data (usually too large or confidential)" _n
    file write gitignorefile "01_data/raw/" _n
    file write gitignorefile "" _n
    file write gitignorefile "# Intermediate data (can be recreated)" _n
    file write gitignorefile "01_data/intermediate/" _n
    file write gitignorefile "" _n
    file write gitignorefile "# Optional: Final data" _n
    file write gitignorefile "# 01_data/final/" _n
    file write gitignorefile "" _n
    file write gitignorefile "# Temporary files" _n
    file write gitignorefile "temp/" _n
    file write gitignorefile "*.tmp" _n
    file write gitignorefile "" _n
    file write gitignorefile "# Stata temporary files" _n
    file write gitignorefile "*.dta~" _n
    file write gitignorefile "*.do~" _n
    file write gitignorefile "" _n
    file write gitignorefile "# Log files" _n
    file write gitignorefile "*.log" _n
    file write gitignorefile "03_output/logs/" _n
    file write gitignorefile "" _n
    file write gitignorefile "# SMCL files" _n
    file write gitignorefile "*.smcl" _n
    file write gitignorefile "" _n
    file write gitignorefile "# Graph files (if not needed)" _n
    file write gitignorefile "*.gph" _n
    file write gitignorefile "" _n
    file write gitignorefile "# Backup files" _n
    file write gitignorefile "data_backup/" _n
    file write gitignorefile "*.bak" _n
    file write gitignorefile "" _n
    file write gitignorefile "# OS generated files" _n
    file write gitignorefile ".DS_Store" _n
    file write gitignorefile ".DS_Store?" _n
    file write gitignorefile "._*" _n
    file write gitignorefile ".Spotlight-V100" _n
    file write gitignorefile ".Trashes" _n
    file write gitignorefile "ehthumbs.db" _n
    file write gitignorefile "Thumbs.db" _n
    file write gitignorefile "" _n
    file write gitignorefile "# IDE files" _n
    file write gitignorefile ".vscode/" _n
    file write gitignorefile ".idea/" _n
    file write gitignorefile "" _n
    file write gitignorefile "# Exception: Keep certain final outputs" _n
    file write gitignorefile "!03_output/figures/*.pdf" _n
    file write gitignorefile "!03_output/tables/*.tex" _n
    file write gitignorefile "!03_output/tables/*.csv" _n

    file close gitignorefile

    di as txt "  ✅ Created: .gitignore"
end

********************************************************************************
* Subprogram: Generate replication files
********************************************************************************
program define projectinit_replication
    syntax, PATH(string) PROJname(string)

    * Generate replication.do
    file open replicationfile using `"`path'/04_replication/replication.do"', write replace

    file write replicationfile "****************************************************" _n
    file write replicationfile "* REPLICATION PACKAGE" _n
    file write replicationfile "* Project: `projname'" _n
    file write replicationfile "* Created: `c(current_date)'" _n
    file write replicationfile "* Purpose: Replicate all results from the paper" _n
    file write replicationfile "****************************************************" _n
    file write replicationfile "" _n
    file write replicationfile "* INSTRUCTIONS FOR REPLICATORS" _n
    file write replicationfile "* 1. Unzip the replication package" _n
    file write replicationfile "* 2. Update the ROOT path below to your local directory" _n
    file write replicationfile "* 3. Run this entire do-file" _n
    file write replicationfile "* 4. All results will be generated in 04_replication/output/" _n
    file write replicationfile "" _n
    file write replicationfile "clear all" _n
    file write replicationfile "set more off" _n
    file write replicationfile "version 14.0" _n
    file write replicationfile "" _n
    file write replicationfile "****************************************************" _n
    file write replicationfile "* SET PATHS (REPLICATOR: UPDATE THIS)" _n
    file write replicationfile "****************************************************" _n
    file write replicationfile "" _n
    file write replicationfile `"global ROOT "`path'""' _n
    file write replicationfile "global replication \"\$ROOT/04_replication\"" _n
    file write replicationfile "global repl_code \"\$replication/code\"" _n
    file write replicationfile "global repl_data \"\$replication/data\"" _n
    file write replicationfile "global repl_output \"\$replication/output\"" _n
    file write replicationfile "" _n
    file write replicationfile "* Create output directories if needed" _n
    file write replicationfile "capture mkdir \"\$repl_output\"" _n
    file write replicationfile "capture mkdir \"\$repl_output/figures\"" _n
    file write replicationfile "capture mkdir \"\$repl_output/tables\"" _n
    file write replicationfile "capture mkdir \"\$repl_output/logs\"" _n
    file write replicationfile "" _n
    file write replicationfile "****************************************************" _n
    file write replicationfile "* START REPLICATION LOG" _n
    file write replicationfile "****************************************************" _n
    file write replicationfile "" _n
    file write replicationfile "local datetime = subinstr(\"\`c(current_date)' \`c(current_time)'\", \" \", \"_\", .)" _n
    file write replicationfile "local datetime = subinstr(\"\`datetime'\", \":\", \"\", .)" _n
    file write replicationfile "log using \"\$repl_output/logs/replication_\`datetime'.log\", replace text" _n
    file write replicationfile "" _n
    file write replicationfile "display as text \"\"" _n
    file write replicationfile "display as text \"{hline 70}\"" _n
    file write replicationfile "display as text \"REPLICATION PACKAGE: `projname'\"" _n
    file write replicationfile "display as text \"Started: \`c(current_date)' \`c(current_time)'\"" _n
    file write replicationfile "display as text \"Stata version: \`c(version)'\"" _n
    file write replicationfile "display as text \"{hline 70}\"" _n
    file write replicationfile "display as text \"\"" _n
    file write replicationfile "" _n
    file write replicationfile "****************************************************" _n
    file write replicationfile "* PACKAGE INSTALLATION" _n
    file write replicationfile "****************************************************" _n
    file write replicationfile "" _n
    file write replicationfile "* List required packages" _n
    file write replicationfile "local packages \"\"" _n
    file write replicationfile "* Example: local packages \"estout reghdfe ftools\"" _n
    file write replicationfile "" _n
    file write replicationfile "* Install missing packages" _n
    file write replicationfile "foreach pkg of local packages {" _n
    file write replicationfile "    capture which \`pkg'" _n
    file write replicationfile "    if _rc {" _n
    file write replicationfile "        display as text \"Installing \`pkg'...\"" _n
    file write replicationfile "        ssc install \`pkg', replace" _n
    file write replicationfile "    }" _n
    file write replicationfile "}" _n
    file write replicationfile "" _n
    file write replicationfile "****************************************************" _n
    file write replicationfile "* RUN REPLICATION SCRIPTS" _n
    file write replicationfile "****************************************************" _n
    file write replicationfile "" _n
    file write replicationfile "* Set random seed" _n
    file write replicationfile "set seed 123456789" _n
    file write replicationfile "" _n
    file write replicationfile "* Run all replication scripts in order" _n
    file write replicationfile "* Example:" _n
    file write replicationfile "* do \"\$repl_code/01_clean_data.do\"" _n
    file write replicationfile "* do \"\$repl_code/02_analysis.do\"" _n
    file write replicationfile "* do \"\$repl_code/03_tables_figures.do\"" _n
    file write replicationfile "" _n
    file write replicationfile "****************************************************" _n
    file write replicationfile "* COMPLETION" _n
    file write replicationfile "****************************************************" _n
    file write replicationfile "" _n
    file write replicationfile "display as text \"\"" _n
    file write replicationfile "display as text \"{hline 70}\"" _n
    file write replicationfile "display as text \"REPLICATION COMPLETED SUCCESSFULLY\"" _n
    file write replicationfile "display as text \"Finished: \`c(current_date)' \`c(current_time)'\"" _n
    file write replicationfile "display as text \"\"" _n
    file write replicationfile "display as text \"Output saved to: \$repl_output\"" _n
    file write replicationfile "display as text \"{hline 70}\"" _n
    file write replicationfile "display as text \"\"" _n
    file write replicationfile "" _n
    file write replicationfile "log close" _n

    file close replicationfile

    * Generate README for replication
    file open replreadme using `"`path'/04_replication/README_REPLICATION.md"', write replace

    file write replreadme "# Replication Package: `projname'" _n
    file write replreadme "" _n
    file write replreadme "## Overview" _n
    file write replreadme "" _n
    file write replreadme "This replication package contains all code and data necessary to replicate the results in the paper." _n
    file write replreadme "" _n
    file write replreadme "## Contents" _n
    file write replreadme "" _n
    file write replreadme "- \`replication.do\` - Main replication script" _n
    file write replreadme "- \`code/\` - All analysis scripts" _n
    file write replreadme "- \`data/\` - All datasets used in analysis" _n
    file write replreadme "- \`output/\` - Where replicated results will be saved" _n
    file write replreadme "" _n
    file write replreadme "## System Requirements" _n
    file write replreadme "" _n
    file write replreadme "### Software" _n
    file write replreadme "" _n
    file write replreadme "- Stata 14.0 or higher (tested on Stata `c(stata_version)')" _n
    file write replreadme "- Required Stata packages:" _n
    file write replreadme "  - estout" _n
    file write replreadme "  - reghdfe" _n
    file write replreadme "  - ftools" _n
    file write replreadme "  - (add others as needed)" _n
    file write replreadme "" _n
    file write replreadme "### Hardware" _n
    file write replreadme "" _n
    file write replreadme "- RAM: Minimum 4GB (8GB+ recommended)" _n
    file write replreadme "- Storage: ~500MB free space" _n
    file write replreadme "- Expected runtime: ~30 minutes (adjust as needed)" _n
    file write replreadme "" _n
    file write replreadme "## Instructions for Replicators" _n
    file write replreadme "" _n
    file write replreadme "### Step 1: Setup" _n
    file write replreadme "" _n
    file write replreadme "1. Extract the replication package to a local directory" _n
    file write replreadme "2. Open Stata" _n
    file write replreadme "3. Change directory to the replication folder:" _n
    file write replreadme "   \`\`\`stata" _n
    file write replreadme "   cd \"path/to/04_replication\"" _n
    file write replreadme "   \`\`\`" _n
    file write replreadme "" _n
    file write replreadme "### Step 2: Configure Paths" _n
    file write replreadme "" _n
    file write replreadme "1. Open \`replication.do\` in a text editor" _n
    file write replreadme "2. Update line 18 with your local path:" _n
    file write replreadme "   \`\`\`stata" _n
    file write replreadme "   global ROOT \"C:/your/path/here\"" _n
    file write replreadme "   \`\`\`" _n
    file write replreadme "" _n
    file write replreadme "### Step 3: Run Replication" _n
    file write replreadme "" _n
    file write replreadme "In Stata, execute:" _n
    file write replreadme "" _n
    file write replreadme "\`\`\`stata" _n
    file write replreadme "do replication.do" _n
    file write replreadme "\`\`\`" _n
    file write replreadme "" _n
    file write replreadme "### Step 4: Verify Results" _n
    file write replreadme "" _n
    file write replreadme "After execution completes:" _n
    file write replreadme "" _n
    file write replreadme "1. Check the log file in \`output/logs/\`" _n
    file write replreadme "2. Compare figures in \`output/figures/\` with published figures" _n
    file write replreadme "3. Compare tables in \`output/tables/\` with published tables" _n
    file write replreadme "" _n
    file write replreadme "## Data Sources" _n
    file write replreadme "" _n
    file write replreadme "### Provided Data" _n
    file write replreadme "" _n
    file write replreadme "The following datasets are included in this package:" _n
    file write replreadme "" _n
    file write replreadme "- \`data/dataset1.dta\` - Description" _n
    file write replreadme "- \`data/dataset2.dta\` - Description" _n
    file write replreadme "" _n
    file write replreadme "### Data Availability Statement" _n
    file write replreadme "" _n
    file write replreadme "[Describe data sources, access restrictions, and how to obtain data if not included]" _n
    file write replreadme "" _n
    file write replreadme "## AEA Compliance Checklist" _n
    file write replreadme "" _n
    file write replreadme "- [ ] README with clear instructions" _n
    file write replreadme "- [ ] All code files included" _n
    file write replreadme "- [ ] Data files or access instructions provided" _n
    file write replreadme "- [ ] Master script that runs all code" _n
    file write replreadme "- [ ] Software requirements documented" _n
    file write replreadme "- [ ] Expected runtime documented" _n
    file write replreadme "- [ ] Random seeds set for reproducibility" _n
    file write replreadme "- [ ] All packages documented with versions" _n
    file write replreadme "" _n
    file write replreadme "## Results Correspondence" _n
    file write replreadme "" _n
    file write replreadme "| Paper Element | Replication File |" _n
    file write replreadme "|---------------|------------------|" _n
    file write replreadme "| Table 1       | \`output/tables/table1.tex\` |" _n
    file write replreadme "| Figure 1      | \`output/figures/figure1.pdf\` |" _n
    file write replreadme "| (add more)    | ... |" _n
    file write replreadme "" _n
    file write replreadme "## Troubleshooting" _n
    file write replreadme "" _n
    file write replreadme "### Common Issues" _n
    file write replreadme "" _n
    file write replreadme "**Issue**: Package installation fails" _n
    file write replreadme "- **Solution**: Manually install required packages using \`ssc install [package]\`" _n
    file write replreadme "" _n
    file write replreadme "**Issue**: Path not found errors" _n
    file write replreadme "- **Solution**: Verify the ROOT global is set correctly in \`replication.do\`" _n
    file write replreadme "" _n
    file write replreadme "**Issue**: Out of memory" _n
    file write replreadme "- **Solution**: Increase Stata's memory allocation with \`set max_memory 8g\`" _n
    file write replreadme "" _n
    file write replreadme "## Contact" _n
    file write replreadme "" _n
    file write replreadme "For questions about this replication package:" _n
    file write replreadme "" _n
    file write replreadme "- **Author**: [Your Name]" _n
    file write replreadme "- **Email**: [mmedrano2@uc.cl]" _n
    file write replreadme "- **Data Editor Contact**: (if applicable)" _n
    file write replreadme "" _n
    file write replreadme "## License" _n
    file write replreadme "" _n
    file write replreadme "This replication package is licensed under [MIT License / CC-BY-4.0 / Other]." _n
    file write replreadme "" _n
    file write replreadme "## Citation" _n
    file write replreadme "" _n
    file write replreadme "\`\`\`" _n
    file write replreadme "[Full citation of the paper]" _n
    file write replreadme "\`\`\`" _n

    file close replreadme

    di as txt "  ✅ Created: Replication files (replication.do, README_REPLICATION.md)"
end
