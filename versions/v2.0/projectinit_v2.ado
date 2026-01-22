*! version 2.0.0  22dec2025
*! Professional Stata Project Initializer v2.0 (AEA/JPAL/MIT Standard + LaTeX + GitHub)
*! Author: Maykol Medrano
*! Email: mmedrano2@uc.cl
*! GitHub: https://github.com/MaykolMedrano/projectinit
*! Description: Enhanced project structure with LaTeX integration and GitHub automation
*! Special focus: Chilean and Peruvian microdata research

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
         VERBose]

    * Display header
    di as txt ""
    di as txt "{hline 70}"
    di as txt "{bf:projectinit v2.0} - Professional Research Project Initializer"
    di as txt "LaTeX Integration • GitHub Automation • Microdata Ready"
    di as txt "{hline 70}"
    di as txt ""

    * Clean and validate project name
    local projname = trim(`"`projname'"')
    local projname = subinstr(`"`projname'"', `"""', "", .)

    * Validate project name (no special characters)
    if regexm("`projname'", "[^a-zA-Z0-9_-]") {
        di as error "Error: Project name contains invalid characters"
        di as error "Only letters, numbers, hyphens, and underscores allowed"
        exit 198
    }

    if `"`projname'"' == "" {
        di as error "Error: Project name cannot be empty"
        exit 198
    }

    * Set defaults
    if "`lang'" == "" local lang "en"
    if "`latex'" == "" local latex "none"
    if "`github'" == "" local github "none"
    if "`author'" == "" local author "Maykol Medrano"

    * Validate options
    if !inlist("`lang'", "en", "es") {
        di as error "Error: lang() must be 'en' or 'es'"
        exit 198
    }

    if !inlist("`latex'", "none", "puc", "standard") {
        di as error "Error: latex() must be 'puc', 'standard', or omitted"
        exit 198
    }

    if !inlist("`github'", "none", "public", "private") {
        di as error "Error: github() must be 'public', 'private', or omitted"
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
        di as txt "Use option {bf:overwrite} to recreate the structure"
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
        exit _rc
    }

    di as txt "📁 Creating project: {bf:`projname'}"
    di as txt "📍 Location: `mainpath'"
    di as txt "🌐 Language: `lang'"
    if "`latex'" != "none" di as txt "📝 LaTeX: `latex' template"
    if "`github'" != "none" di as txt "🔗 GitHub: `github' repository"
    di as txt ""

    * Define folder structure (enhanced for v2.0)
    local folders ""
    local folders `folders' "data"
    local folders `folders' "data/raw"
    local folders `folders' "data/processed"
    local folders `folders' "scripts"
    local folders `folders' "results"
    local folders `folders' "results/tables"
    local folders `folders' "results/figures"
    local folders `folders' "temp"

    if "`latex'" != "none" {
        local folders `folders' "writing"
        local folders `folders' "writing/sections"
        local folders `folders' "writing/tables"
        local folders `folders' "writing/figures"
    }

    if "`replicate'" != "" {
        local folders `folders' "replication"
        local folders `folders' "replication/code"
        local folders `folders' "replication/data"
        local folders `folders' "replication/output"
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

    * Generate main.do (master script)
    di as txt "Generating master script..."
    projectinit_v2_main, path(`"`mainpath'"') projname(`"`projname'"') ///
        lang(`lang') author(`"`author'"')

    * Generate .gitignore
    di as txt "Generating .gitignore..."
    projectinit_v2_gitignore, path(`"`mainpath'"') latex(`latex')

    * Generate README.md
    di as txt "Generating README.md..."
    projectinit_v2_readme, path(`"`mainpath'"') projname(`"`projname'"') ///
        lang(`lang') author(`"`author'"') latex(`latex') github(`github')

    * Generate LaTeX structure if requested
    if "`latex'" != "none" {
        di as txt "Generating LaTeX structure..."
        projectinit_v2_latex, path(`"`mainpath'"') projname(`"`projname'"') ///
            template(`latex') lang(`lang') author(`"`author'"')
    }

    * Generate sample scripts
    di as txt "Generating template scripts..."
    projectinit_v2_scripts, path(`"`mainpath'"') lang(`lang')

    * GitHub initialization if requested
    if "`github'" != "none" {
        di as txt ""
        di as txt "Initializing GitHub repository..."
        projectinit_v2_github, path(`"`mainpath'"') projname(`"`projname'"') ///
            visibility(`github') author(`"`author'"')
    }

    * Generate replication files if requested
    if "`replicate'" != "" {
        di as txt "Generating replication package..."
        projectinit_v2_replication, path(`"`mainpath'"') projname(`"`projname'"') ///
            lang(`lang') author(`"`author'"')
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
    di as txt "  2. Run setup: {bf:do main.do}"
    if "`latex'" != "none" {
        di as txt "  3. Edit LaTeX: {bf:writing/main.tex}"
        di as txt "  4. Import to Overleaf: https://www.overleaf.com/project"
    }
    if "`github'" != "none" {
        di as txt "  5. View repository: {bf:gh repo view --web}"
    }
    di as txt ""
    di as txt "{hline 70}"

    * Return values
    return local projname "`projname'"
    return local mainpath "`mainpath'"
    return local lang "`lang'"
    return local latex "`latex'"
    return local github "`github'"
    return local created "success"

end

********************************************************************************
* Subprogram: Generate main.do (Master Script)
********************************************************************************
program define projectinit_v2_main
    syntax, PATH(string) PROJname(string) LAng(string) AUthor(string)

    file open mainfile using `"`path'/main.do"', write replace

    file write mainfile "****************************************************" _n
    file write mainfile "* MASTER SCRIPT - `projname'" _n
    file write mainfile "* Author: `author'" _n
    file write mainfile "* Created: `c(current_date)'" _n
    file write mainfile "* Version: 2.0 (projectinit)" _n
    file write mainfile "****************************************************" _n
    file write mainfile "" _n
    file write mainfile "clear all" _n
    file write mainfile "macro drop _all" _n
    file write mainfile "set more off" _n
    file write mainfile "set varabbrev off" _n
    file write mainfile "version 14.0" _n
    file write mainfile "" _n
    file write mainfile "****************************************************" _n
    file write mainfile "* DYNAMIC PATHS (Portable across users)" _n
    file write mainfile "****************************************************" _n
    file write mainfile "" _n
    file write mainfile "* Get current working directory" _n
    file write mainfile "global root \"\`c(pwd)\'\"" _n
    file write mainfile "" _n
    file write mainfile "* Define project paths" _n
    file write mainfile "global data \"\$root/data\"" _n
    file write mainfile "global raw \"\$data/raw\"" _n
    file write mainfile "global processed \"\$data/processed\"" _n
    file write mainfile "global scripts \"\$root/scripts\"" _n
    file write mainfile "global results \"\$root/results\"" _n
    file write mainfile "global tables \"\$results/tables\"" _n
    file write mainfile "global figures \"\$results/figures\"" _n
    file write mainfile "global temp \"\$root/temp\"" _n
    file write mainfile "global writing \"\$root/writing\"" _n
    file write mainfile "" _n
    file write mainfile "* Display paths" _n
    file write mainfile "display as text \"\"" _n
    file write mainfile "display as text \"Project: `projname'\"" _n
    file write mainfile "display as text \"Root: \$root\"" _n
    file write mainfile "display as text \"\"" _n
    file write mainfile "" _n
    file write mainfile "****************************************************" _n
    file write mainfile "* DEPENDENCY CHECK & INSTALLATION" _n
    file write mainfile "****************************************************" _n
    file write mainfile "" _n
    file write mainfile "* Define required packages" _n
    file write mainfile "local packages \"\"" _n
    file write mainfile "" _n
    file write mainfile "* Core packages" _n
    file write mainfile "local packages \`packages' \"estout\"" _n
    file write mainfile "local packages \`packages' \"reghdfe\"" _n
    file write mainfile "local packages \`packages' \"ftools\"" _n
    file write mainfile "" _n
    file write mainfile "* Chilean/Peruvian microdata packages (if available)" _n
    file write mainfile "* Uncomment to use:" _n
    file write mainfile "* local packages \`packages' \"usecasen\"" _n
    file write mainfile "* local packages \`packages' \"enahodata\"" _n
    file write mainfile "* local packages \`packages' \"usebcrp\"" _n
    file write mainfile "* local packages \`packages' \"fixencoding\"" _n
    file write mainfile "* local packages \`packages' \"datadex\"" _n
    file write mainfile "" _n
    file write mainfile "* Install missing packages" _n
    file write mainfile "foreach pkg of local packages {" _n
    file write mainfile "    capture which \`pkg'" _n
    file write mainfile "    if _rc {" _n
    file write mainfile "        display as text \"Installing \`pkg'...\"" _n
    file write mainfile "        capture ssc install \`pkg', replace" _n
    file write mainfile "        if _rc {" _n
    file write mainfile "            display as error \"Warning: Could not install \`pkg'\"" _n
    file write mainfile "            display as error \"You may need to install manually\"" _n
    file write mainfile "        }" _n
    file write mainfile "    }" _n
    file write mainfile "    else {" _n
    file write mainfile "        display as text \"  ✓ \`pkg' installed\"" _n
    file write mainfile "    }" _n
    file write mainfile "}" _n
    file write mainfile "" _n
    file write mainfile "display as text \"\"" _n
    file write mainfile "" _n
    file write mainfile "****************************************************" _n
    file write mainfile "* REPRODUCIBILITY SETTINGS" _n
    file write mainfile "****************************************************" _n
    file write mainfile "" _n
    file write mainfile "set seed 123456789" _n
    file write mainfile "set linesize 120" _n
    file write mainfile "set maxvar 32000" _n
    file write mainfile "" _n
    file write mainfile "****************************************************" _n
    file write mainfile "* EXECUTION LOG" _n
    file write mainfile "****************************************************" _n
    file write mainfile "" _n
    file write mainfile "local datetime = subinstr(\"\`c(current_date)' \`c(current_time)'\", \" \", \"_\", .)" _n
    file write mainfile "local datetime = subinstr(\"\`datetime'\", \":\", \"\", .)" _n
    file write mainfile "log using \"\$temp/main_\`datetime'.log\", replace text name(mainlog)" _n
    file write mainfile "" _n
    file write mainfile "display as text \"{hline 70}\"" _n
    file write mainfile "display as text \"PROJECT: `projname'\"" _n
    file write mainfile "display as text \"Started: \`c(current_date)' \`c(current_time)'\"" _n
    file write mainfile "display as text \"{hline 70}\"" _n
    file write mainfile "display as text \"\"" _n
    file write mainfile "" _n
    file write mainfile "****************************************************" _n
    file write mainfile "* SEQUENTIAL EXECUTION" _n
    file write mainfile "****************************************************" _n
    file write mainfile "" _n
    file write mainfile "* Add your scripts here in order:" _n
    file write mainfile "" _n
    file write mainfile "* Example:" _n
    file write mainfile "* do \"\$scripts/01_clean.do\"" _n
    file write mainfile "* do \"\$scripts/02_analysis.do\"" _n
    file write mainfile "* do \"\$scripts/03_tables.do\"" _n
    file write mainfile "* do \"\$scripts/04_figures.do\"" _n
    file write mainfile "" _n
    file write mainfile "****************************************************" _n
    file write mainfile "* COMPLETION" _n
    file write mainfile "****************************************************" _n
    file write mainfile "" _n
    file write mainfile "display as text \"\"" _n
    file write mainfile "display as text \"{hline 70}\"" _n
    file write mainfile "display as text \"PROJECT COMPLETED\"" _n
    file write mainfile "display as text \"Finished: \`c(current_date)' \`c(current_time)'\"" _n
    file write mainfile "display as text \"{hline 70}\"" _n
    file write mainfile "" _n
    file write mainfile "log close mainlog" _n

    file close mainfile

    di as txt "  ✅ Created: main.do"
end

********************************************************************************
* Subprogram: Generate .gitignore
********************************************************************************
program define projectinit_v2_gitignore
    syntax, PATH(string) LAtex(string)

    file open gitfile using `"`path'/.gitignore"', write replace

    file write gitfile "# Stata Project .gitignore" _n
    file write gitfile "" _n
    file write gitfile "# Data files (raw data should not be tracked)" _n
    file write gitfile "*.dta" _n
    file write gitfile "*.csv" _n
    file write gitfile "*.xlsx" _n
    file write gitfile "*.xls" _n
    file write gitfile "data/raw/" _n
    file write gitfile "" _n
    file write gitfile "# Stata temporary/log files" _n
    file write gitfile "*.smcl" _n
    file write gitfile "*.log" _n
    file write gitfile "*.dta~" _n
    file write gitfile "*.do~" _n
    file write gitfile "*.gph" _n
    file write gitfile "" _n
    file write gitfile "# Temporary files" _n
    file write gitfile "temp/" _n
    file write gitfile "*.tmp" _n
    file write gitfile "" _n

    if "`latex'" != "none" {
        file write gitfile "# LaTeX auxiliary files" _n
        file write gitfile "*.aux" _n
        file write gitfile "*.out" _n
        file write gitfile "*.log" _n
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
        file write gitfile "" _n
    }

    file write gitfile "# OS generated files" _n
    file write gitfile ".DS_Store" _n
    file write gitfile "Thumbs.db" _n
    file write gitfile "ehthumbs.db" _n
    file write gitfile "" _n
    file write gitfile "# IDE files" _n
    file write gitfile ".vscode/" _n
    file write gitfile ".idea/" _n
    file write gitfile "" _n
    file write gitfile "# Keep final outputs" _n
    file write gitfile "!results/tables/*.tex" _n
    file write gitfile "!results/figures/*.pdf" _n
    file write gitfile "!results/figures/*.png" _n

    file close gitfile

    di as txt "  ✅ Created: .gitignore"
end

********************************************************************************
* Subprogram: Generate README.md
********************************************************************************
program define projectinit_v2_readme
    syntax, PATH(string) PROJname(string) LAng(string) AUthor(string) ///
        LAtex(string) GIThub(string)

    file open readmefile using `"`path'/README.md"', write replace

    if "`lang'" == "en" {
        file write readmefile "# `projname'" _n
        file write readmefile "" _n
        file write readmefile "**Author**: `author'" _n
        file write readmefile "**Created**: `c(current_date)'" _n
        file write readmefile "**Generated by**: projectinit v2.0" _n
        file write readmefile "" _n
        file write readmefile "## Overview" _n
        file write readmefile "" _n
        file write readmefile "This project follows reproducible research standards (AEA/JPAL/MIT)." _n
        file write readmefile "" _n
        file write readmefile "## Data Sources" _n
        file write readmefile "" _n
        file write readmefile "This project uses microdata from:" _n
        file write readmefile "- Chilean household surveys (CASEN)" _n
        file write readmefile "- Peruvian household surveys (ENAHO)" _n
        file write readmefile "" _n
        file write readmefile "Helper packages used:" _n
        file write readmefile "- `usecasen` - CASEN data loader" _n
        file write readmefile "- `enahodata` - ENAHO data loader" _n
        file write readmefile "- `usebcrp` - Central Bank of Peru data" _n
        file write readmefile "- `fixencoding` - Character encoding fixes" _n
        file write readmefile "- `datadex` - Data exploration" _n
        file write readmefile "" _n
        file write readmefile "## Project Structure" _n
        file write readmefile "" _n
        file write readmefile "\`\`\`" _n
        file write readmefile "`projname'/" _n
        file write readmefile "├── main.do                # Master script" _n
        file write readmefile "├── data/" _n
        file write readmefile "│   ├── raw/              # Original data (read-only)" _n
        file write readmefile "│   └── processed/        # Cleaned data" _n
        file write readmefile "├── scripts/              # Analysis scripts" _n
        file write readmefile "├── results/" _n
        file write readmefile "│   ├── tables/           # Generated tables" _n
        file write readmefile "│   └── figures/          # Generated figures" _n
    }
    else {
        file write readmefile "# `projname'" _n
        file write readmefile "" _n
        file write readmefile "**Autor**: `author'" _n
        file write readmefile "**Creado**: `c(current_date)'" _n
        file write readmefile "**Generado por**: projectinit v2.0" _n
        file write readmefile "" _n
        file write readmefile "## Descripción" _n
        file write readmefile "" _n
        file write readmefile "Este proyecto sigue estándares de investigación reproducible (AEA/JPAL/MIT)." _n
        file write readmefile "" _n
        file write readmefile "## Fuentes de Datos" _n
        file write readmefile "" _n
        file write readmefile "Este proyecto utiliza microdatos de:" _n
        file write readmefile "- Encuestas de hogares chilenas (CASEN)" _n
        file write readmefile "- Encuestas de hogares peruanas (ENAHO)" _n
        file write readmefile "" _n
        file write readmefile "Paquetes auxiliares utilizados:" _n
        file write readmefile "- `usecasen` - Cargador de datos CASEN" _n
        file write readmefile "- `enahodata` - Cargador de datos ENAHO" _n
        file write readmefile "- `usebcrp` - Datos del Banco Central de Perú" _n
        file write readmefile "- `fixencoding` - Corrección de codificación de caracteres" _n
        file write readmefile "- `datadex` - Exploración de datos" _n
        file write readmefile "" _n
        file write readmefile "## Estructura del Proyecto" _n
        file write readmefile "" _n
        file write readmefile "\`\`\`" _n
        file write readmefile "`projname'/" _n
        file write readmefile "├── main.do                # Script maestro" _n
        file write readmefile "├── data/" _n
        file write readmefile "│   ├── raw/              # Datos originales (solo lectura)" _n
        file write readmefile "│   └── processed/        # Datos procesados" _n
        file write readmefile "├── scripts/              # Scripts de análisis" _n
        file write readmefile "├── results/" _n
        file write readmefile "│   ├── tables/           # Tablas generadas" _n
        file write readmefile "│   └── figures/          # Figuras generadas" _n
    }

    if "`latex'" != "none" {
        file write readmefile "├── writing/              # LaTeX manuscript" _n
        file write readmefile "│   ├── main.tex          # Main document" _n
        file write readmefile "│   ├── sections/         # Paper sections" _n
        file write readmefile "│   └── macros.tex        # Auto-updated from Stata" _n
    }

    file write readmefile "└── temp/                 # Temporary files" _n
    file write readmefile "\`\`\`" _n
    file write readmefile "" _n

    if "`lang'" == "en" {
        file write readmefile "## Replication Instructions" _n
        file write readmefile "" _n
        file write readmefile "To replicate all results:" _n
        file write readmefile "" _n
        file write readmefile "1. Ensure Stata 14+ is installed" _n
        file write readmefile "2. Navigate to project directory" _n
        file write readmefile "3. Run: `do main.do`" _n
        file write readmefile "" _n
        file write readmefile "The master script will:" _n
        file write readmefile "- Check and install required packages" _n
        file write readmefile "- Execute all analysis scripts in order" _n
        file write readmefile "- Generate all tables and figures" _n
    }
    else {
        file write readmefile "## Instrucciones de Replicación" _n
        file write readmefile "" _n
        file write readmefile "Para replicar todos los resultados:" _n
        file write readmefile "" _n
        file write readmefile "1. Asegúrese de tener Stata 14+ instalado" _n
        file write readmefile "2. Navegue al directorio del proyecto" _n
        file write readmefile "3. Ejecute: `do main.do`" _n
        file write readmefile "" _n
        file write readmefile "El script maestro:" _n
        file write readmefile "- Verificará e instalará paquetes necesarios" _n
        file write readmefile "- Ejecutará todos los scripts de análisis en orden" _n
        file write readmefile "- Generará todas las tablas y figuras" _n
    }

    file write readmefile "" _n

    if "`latex'" != "none" {
        if "`lang'" == "en" {
            file write readmefile "## LaTeX Manuscript" _n
            file write readmefile "" _n
            file write readmefile "The paper is written in LaTeX using a modular structure." _n
            file write readmefile "" _n
            file write readmefile "To compile:" _n
            file write readmefile "1. Import `writing/` folder to Overleaf: https://www.overleaf.com/project" _n
            file write readmefile "2. Or compile locally: `pdflatex main.tex` (from writing/ folder)" _n
        }
        else {
            file write readmefile "## Manuscrito LaTeX" _n
            file write readmefile "" _n
            file write readmefile "El paper está escrito en LaTeX con estructura modular." _n
            file write readmefile "" _n
            file write readmefile "Para compilar:" _n
            file write readmefile "1. Importar carpeta `writing/` a Overleaf: https://www.overleaf.com/project" _n
            file write readmefile "2. O compilar localmente: `pdflatex main.tex` (desde carpeta writing/)" _n
        }
        file write readmefile "" _n
    }

    file close readmefile

    di as txt "  ✅ Created: README.md"
end

********************************************************************************
* Subprogram: Generate LaTeX Structure
********************************************************************************
program define projectinit_v2_latex
    syntax, PATH(string) PROJname(string) TEMplate(string) LAng(string) AUthor(string)

    * Generate main.tex
    file open maintex using `"`path'/writing/main.tex"', write replace

    file write maintex "\documentclass[12pt,a4paper]{article}" _n
    file write maintex "" _n
    file write maintex "% Load preamble" _n
    file write maintex "\input{preamble.tex}" _n
    file write maintex "" _n
    file write maintex "% Auto-generated macros from Stata" _n
    file write maintex "\input{macros.tex}" _n
    file write maintex "" _n
    file write maintex "\begin{document}" _n
    file write maintex "" _n

    if "`template'" == "puc" {
        file write maintex "% PUC Thesis Format" _n
        file write maintex "\begin{titlepage}" _n
        file write maintex "    \centering" _n
        file write maintex "    {\LARGE\bfseries `projname' \par}" _n
        file write maintex "    \vspace{2cm}" _n
        file write maintex "    {\Large `author' \par}" _n
        file write maintex "    \vfill" _n
        file write maintex "    {Pontificia Universidad Cat\'olica de Chile \par}" _n
        file write maintex "    {\`c(current_date)' \par}" _n
        file write maintex "\end{titlepage}" _n
    }
    else {
        file write maintex "% Title Page" _n
        file write maintex "\title{`projname'}" _n
        file write maintex "\author{`author'}" _n
        file write maintex "\date{\today}" _n
        file write maintex "\maketitle" _n
    }

    file write maintex "" _n
    file write maintex "\begin{abstract}" _n
    file write maintex "Your abstract here." _n
    file write maintex "\end{abstract}" _n
    file write maintex "" _n
    file write maintex "% Sections" _n
    file write maintex "\input{sections/intro.tex}" _n
    file write maintex "\input{sections/data.tex}" _n
    file write maintex "\input{sections/methods.tex}" _n
    file write maintex "\input{sections/results.tex}" _n
    file write maintex "\input{sections/conclusion.tex}" _n
    file write maintex "" _n
    file write maintex "\bibliography{references}" _n
    file write maintex "" _n
    file write maintex "\end{document}" _n

    file close maintex

    * Generate preamble.tex
    file open preamble using `"`path'/writing/preamble.tex"', write replace

    file write preamble "% PREAMBLE - LaTeX Packages and Settings" _n
    file write preamble "" _n
    file write preamble "% Essential packages" _n
    file write preamble "\usepackage[utf8]{inputenc}" _n
    file write preamble "\usepackage[T1]{fontenc}" _n
    file write preamble "\usepackage[english]{babel}" _n
    file write preamble "" _n
    file write preamble "% Math" _n
    file write preamble "\usepackage{amsmath,amssymb,amsthm}" _n
    file write preamble "" _n
    file write preamble "% Tables" _n
    file write preamble "\usepackage{booktabs}" _n
    file write preamble "\usepackage{threeparttable}" _n
    file write preamble "\usepackage{siunitx}  % Decimal alignment" _n
    file write preamble "\usepackage{caption}" _n
    file write preamble "" _n
    file write preamble "% Figures" _n
    file write preamble "\usepackage{graphicx}" _n
    file write preamble "\usepackage{float}" _n
    file write preamble "" _n
    file write preamble "% Page layout" _n
    file write preamble "\usepackage[margin=1in]{geometry}" _n
    file write preamble "\usepackage{setspace}" _n
    file write preamble "\doublespacing" _n
    file write preamble "" _n
    file write preamble "% Links and references" _n
    file write preamble "\usepackage{hyperref}" _n
    file write preamble "\hypersetup{" _n
    file write preamble "    colorlinks=true," _n
    file write preamble "    linkcolor=blue," _n
    file write preamble "    citecolor=blue," _n
    file write preamble "    urlcolor=blue" _n
    file write preamble "}" _n
    file write preamble "" _n
    file write preamble "% Bibliography" _n
    file write preamble "\usepackage[authoryear]{natbib}" _n
    file write preamble "\bibliographystyle{apalike}" _n
    file write preamble "" _n
    file write preamble "% Custom commands" _n
    file write preamble "\newcommand{\cmark}{\ding{51}}" _n
    file write preamble "\newcommand{\xmark}{\ding{55}}" _n

    file close preamble

    * Generate macros.tex (for Stata-generated values)
    file open macros using `"`path'/writing/macros.tex"', write replace

    file write macros "% AUTO-GENERATED MACROS FROM STATA" _n
    file write macros "% Do not edit manually - regenerate from Stata" _n
    file write macros "" _n
    file write macros "% Example usage in Stata:" _n
    file write macros "% file write macrofile \"\newcommand{\samplesize}{`N'}\" _n" _n
    file write macros "% Then use in LaTeX: The sample has \samplesize observations." _n
    file write macros "" _n
    file write macros "% Your macros will appear here" _n

    file close macros

    * Generate section templates
    local sections "intro data methods results conclusion"
    foreach sec of local sections {
        file open secfile using `"`path'/writing/sections/`sec'.tex"', write replace

        if "`sec'" == "intro" {
            file write secfile "\section{Introduction}" _n
            file write secfile "" _n
            file write secfile "Your introduction here." _n
        }
        else if "`sec'" == "data" {
            file write secfile "\section{Data}" _n
            file write secfile "" _n
            file write secfile "Description of your data sources." _n
        }
        else if "`sec'" == "methods" {
            file write secfile "\section{Methodology}" _n
            file write secfile "" _n
            file write secfile "Your econometric methods." _n
        }
        else if "`sec'" == "results" {
            file write secfile "\section{Results}" _n
            file write secfile "" _n
            file write secfile "% Include tables from Stata" _n
            file write secfile "% \input{tables/table1.tex}" _n
            file write secfile "" _n
            file write secfile "% Include figures" _n
            file write secfile "% \begin{figure}[H]" _n
            file write secfile "% \centering" _n
            file write secfile "% \includegraphics[width=0.8\textwidth]{figures/figure1.pdf}" _n
            file write secfile "% \caption{Your caption}" _n
            file write secfile "% \label{fig:fig1}" _n
            file write secfile "% \end{figure}" _n
        }
        else if "`sec'" == "conclusion" {
            file write secfile "\section{Conclusion}" _n
            file write secfile "" _n
            file write secfile "Your conclusions here." _n
        }

        file close secfile
    }

    * Generate references.bib
    file open bibfile using `"`path'/writing/references.bib"', write replace

    file write bibfile "@article{example2020," _n
    file write bibfile "    author = {Author, A. and Author, B.}," _n
    file write bibfile "    title = {Example Article}," _n
    file write bibfile "    journal = {Journal Name}," _n
    file write bibfile "    year = {2020}," _n
    file write bibfile "    volume = {1}," _n
    file write bibfile "    pages = {1--20}" _n
    file write bibfile "}" _n

    file close bibfile

    di as txt "  ✅ Created: LaTeX structure"
end

********************************************************************************
* Subprogram: Initialize GitHub Repository
********************************************************************************
program define projectinit_v2_github
    syntax, PATH(string) PROJname(string) VISibility(string) AUthor(string)

    * Check if gh CLI is available
    capture shell gh --version
    if _rc {
        di as error "  ⚠ GitHub CLI (gh) not found"
        di as error "  Install from: https://cli.github.com/"
        di as error "  Skipping GitHub initialization"
        return
    }

    * Save current directory
    local olddir "`c(pwd)'"

    * Navigate to project
    quietly cd "`path'"

    * Initialize git
    di as txt "  • Initializing git repository..."
    shell git init

    * Create GitHub repository
    di as txt "  • Creating GitHub repository (`visibility')..."
    if "`visibility'" == "public" {
        shell gh repo create "`projname'" --public --source=. --remote=origin
    }
    else {
        shell gh repo create "`projname'" --private --source=. --remote=origin
    }

    * Add all files
    di as txt "  • Adding files to repository..."
    shell git add .

    * Initial commit
    di as txt "  • Creating initial commit..."
    shell git commit -m "Initial project structure by projectinit v2.0"

    * Push to GitHub
    di as txt "  • Pushing to GitHub..."
    shell git push -u origin main

    * Get repository URL
    di as txt ""
    di as result "  ✅ GitHub repository created!"
    di as txt ""
    di as txt "  Repository URL: https://github.com/`author'/`projname'"
    di as txt "  View online: {bf:gh repo view --web}"

    * Return to original directory
    quietly cd "`olddir'"
end

********************************************************************************
* Subprogram: Generate Template Scripts
********************************************************************************
program define projectinit_v2_scripts
    syntax, PATH(string) LAng(string)

    * 01_clean.do
    file open cleanfile using `"`path'/scripts/01_clean.do"', write replace

    if "`lang'" == "en" {
        file write cleanfile "****************************************************" _n
        file write cleanfile "* DATA CLEANING" _n
        file write cleanfile "* Purpose: Clean and prepare raw data" _n
        file write cleanfile "****************************************************" _n
        file write cleanfile "" _n
        file write cleanfile "* Load raw data" _n
        file write cleanfile "* use \"\$raw/data.dta\", clear" _n
        file write cleanfile "" _n
        file write cleanfile "* Cleaning steps" _n
        file write cleanfile "* - Drop duplicates" _n
        file write cleanfile "* - Handle missing values" _n
        file write cleanfile "* - Create variables" _n
        file write cleanfile "* - Label variables" _n
        file write cleanfile "" _n
        file write cleanfile "* Save cleaned data" _n
        file write cleanfile "* save \"\$processed/data_clean.dta\", replace" _n
    }
    else {
        file write cleanfile "****************************************************" _n
        file write cleanfile "* LIMPIEZA DE DATOS" _n
        file write cleanfile "* Propósito: Limpiar y preparar datos crudos" _n
        file write cleanfile "****************************************************" _n
        file write cleanfile "" _n
        file write cleanfile "* Cargar datos crudos" _n
        file write cleanfile "* use \"\$raw/data.dta\", clear" _n
        file write cleanfile "" _n
        file write cleanfile "* Pasos de limpieza" _n
        file write cleanfile "* - Eliminar duplicados" _n
        file write cleanfile "* - Manejar valores perdidos" _n
        file write cleanfile "* - Crear variables" _n
        file write cleanfile "* - Etiquetar variables" _n
        file write cleanfile "" _n
        file write cleanfile "* Guardar datos limpios" _n
        file write cleanfile "* save \"\$processed/data_clean.dta\", replace" _n
    }

    file close cleanfile

    * 02_analysis.do
    file open analysisfile using `"`path'/scripts/02_analysis.do"', write replace

    if "`lang'" == "en" {
        file write analysisfile "****************************************************" _n
        file write analysisfile "* STATISTICAL ANALYSIS" _n
        file write analysisfile "****************************************************" _n
        file write analysisfile "" _n
        file write analysisfile "* Load processed data" _n
        file write analysisfile "* use \"\$processed/data_clean.dta\", clear" _n
        file write analysisfile "" _n
        file write analysisfile "* Main analysis" _n
        file write analysisfile "* regress y x1 x2, robust" _n
    }
    else {
        file write analysisfile "****************************************************" _n
        file write analysisfile "* ANÁLISIS ESTADÍSTICO" _n
        file write analysisfile "****************************************************" _n
        file write analysisfile "" _n
        file write analysisfile "* Cargar datos procesados" _n
        file write analysisfile "* use \"\$processed/data_clean.dta\", clear" _n
        file write analysisfile "" _n
        file write analysisfile "* Análisis principal" _n
        file write analysisfile "* regress y x1 x2, robust" _n
    }

    file close analysisfile

    * 03_tables.do
    file open tablesfile using `"`path'/scripts/03_tables.do"', write replace

    if "`lang'" == "en" {
        file write tablesfile "****************************************************" _n
        file write tablesfile "* TABLE GENERATION" _n
        file write tablesfile "****************************************************" _n
        file write tablesfile "" _n
        file write tablesfile "* Example: Export regression table" _n
        file write tablesfile "* esttab using \"\$tables/table1.tex\", replace" _n
    }
    else {
        file write tablesfile "****************************************************" _n
        file write tablesfile "* GENERACIÓN DE TABLAS" _n
        file write tablesfile "****************************************************" _n
        file write tablesfile "" _n
        file write tablesfile "* Ejemplo: Exportar tabla de regresión" _n
        file write tablesfile "* esttab using \"\$tables/table1.tex\", replace" _n
    }

    file close tablesfile

    * 04_figures.do
    file open figuresfile using `"`path'/scripts/04_figures.do"', write replace

    if "`lang'" == "en" {
        file write figuresfile "****************************************************" _n
        file write figuresfile "* FIGURE GENERATION" _n
        file write figuresfile "****************************************************" _n
        file write figuresfile "" _n
        file write figuresfile "* Example: Create scatter plot" _n
        file write figuresfile "* twoway scatter y x, scheme(s2color)" _n
        file write figuresfile "* graph export \"\$figures/figure1.pdf\", replace" _n
    }
    else {
        file write figuresfile "****************************************************" _n
        file write figuresfile "* GENERACIÓN DE FIGURAS" _n
        file write figuresfile "****************************************************" _n
        file write figuresfile "" _n
        file write figuresfile "* Ejemplo: Crear gráfico de dispersión" _n
        file write figuresfile "* twoway scatter y x, scheme(s2color)" _n
        file write figuresfile "* graph export \"\$figures/figure1.pdf\", replace" _n
    }

    file close figuresfile

    di as txt "  ✅ Created: Template scripts"
end

********************************************************************************
* Subprogram: Generate Replication Package
********************************************************************************
program define projectinit_v2_replication
    syntax, PATH(string) PROJname(string) LAng(string) AUthor(string)

    * Generate replication.do
    file open replfile using `"`path'/replication/replication.do"', write replace

    if "`lang'" == "en" {
        file write replfile "****************************************************" _n
        file write replfile "* REPLICATION PACKAGE" _n
        file write replfile "* Project: `projname'" _n
        file write replfile "* Author: `author'" _n
        file write replfile "****************************************************" _n
        file write replfile "" _n
        file write replfile "clear all" _n
        file write replfile "set more off" _n
        file write replfile "" _n
        file write replfile "* Set root path (UPDATE THIS)" _n
        file write replfile "global root \"\`c(pwd)\'\"" _n
        file write replfile "" _n
        file write replfile "* Run all scripts" _n
        file write replfile "* do \"\$root/code/01_clean.do\"" _n
        file write replfile "* do \"\$root/code/02_analysis.do\"" _n
        file write replfile "* do \"\$root/code/03_tables.do\"" _n
        file write replfile "* do \"\$root/code/04_figures.do\"" _n
    }
    else {
        file write replfile "****************************************************" _n
        file write replfile "* PAQUETE DE REPLICACIÓN" _n
        file write replfile "* Proyecto: `projname'" _n
        file write replfile "* Autor: `author'" _n
        file write replfile "****************************************************" _n
        file write replfile "" _n
        file write replfile "clear all" _n
        file write replfile "set more off" _n
        file write replfile "" _n
        file write replfile "* Definir ruta raíz (ACTUALIZAR ESTO)" _n
        file write replfile "global root \"\`c(pwd)\'\"" _n
        file write replfile "" _n
        file write replfile "* Ejecutar todos los scripts" _n
        file write replfile "* do \"\$root/code/01_clean.do\"" _n
        file write replfile "* do \"\$root/code/02_analysis.do\"" _n
        file write replfile "* do \"\$root/code/03_tables.do\"" _n
        file write replfile "* do \"\$root/code/04_figures.do\"" _n
    }

    file close replfile

    di as txt "  ✅ Created: Replication package"
end
