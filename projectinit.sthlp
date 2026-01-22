{smcl}
{* *! version 1.0.0  11dec2025}{...}
{vieweralsosee "" "--"}{...}
{viewerjumpto "Syntax" "projectinit##syntax"}{...}
{viewerjumpto "Description" "projectinit##description"}{...}
{viewerjumpto "Options" "projectinit##options"}{...}
{viewerjumpto "Examples" "projectinit##examples"}{...}
{viewerjumpto "Stored results" "projectinit##results"}{...}
{viewerjumpto "Author" "projectinit##author"}{...}
{title:Title}

{phang}
{bf:projectinit} {hline 2} Professional Stata project structure initializer (AEA/JPAL/MIT standard)


{marker syntax}{...}
{title:Syntax}

{p 8 17 2}
{cmd:projectinit}
{it:projectname}
{cmd:,}
{opt root(string)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
{synopt:{opt root(string)}}parent directory where project will be created{p_end}

{syntab:Optional}
{synopt:{opt over:write}}overwrite existing project folder if it exists{p_end}
{synopt:{opt rep:licate}}create replication package structure and files{p_end}
{synopt:{opt tem:plate(string)}}use custom template (not yet implemented){p_end}
{synopt:{opt ver:bose}}display detailed output during creation{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:projectinit} creates a complete, professional research project structure following
AEA (American Economic Association), JPAL (Abdul Latif Jameel Poverty Action Lab), and MIT
reproducibility standards.

{pstd}
The command generates:

{phang2}• A standardized folder structure for data, code, and output{p_end}
{phang2}• Configuration files with global path definitions{p_end}
{phang2}• Template do-files for each stage of analysis{p_end}
{phang2}• Master execution scripts{p_end}
{phang2}• Documentation templates (README, .gitignore){p_end}
{phang2}• Optional replication package structure{p_end}

{pstd}
This ensures reproducibility, facilitates collaboration, and meets journal requirements
for data and code availability.


{marker options}{...}
{title:Options}

{dlgtab:Required}

{phang}
{opt root(string)} specifies the parent directory where the project folder will be created.
The full project path will be {it:root/projectname}. This should be an existing directory.

{dlgtab:Optional}

{phang}
{opt overwrite} allows overwriting an existing project folder. Without this option,
{cmd:projectinit} will abort if a folder with the same name already exists. Use with caution
as this will recreate the entire structure.

{phang}
{opt replicate} creates an additional replication package structure in {it:04_replication/}
with subdirectories for code, data, and output, plus template replication documentation
following AEA guidelines.

{phang}
{opt template(string)} allows specifying a custom template (feature reserved for future implementation).

{phang}
{opt verbose} displays detailed information about each folder and file created during
the initialization process. By default, only summary information is shown.


{marker examples}{...}
{title:Examples}

{pstd}Basic usage - create a project named "MyResearch":{p_end}
{phang2}{cmd:. projectinit "MyResearch", root("C:/Users/Username/Documents")}{p_end}

{pstd}Create project with replication package:{p_end}
{phang2}{cmd:. projectinit "PolicyEvaluation", root("C:/Research") replicate}{p_end}

{pstd}Overwrite existing project with verbose output:{p_end}
{phang2}{cmd:. projectinit "ExistingProject", root("D:/Projects") overwrite verbose}{p_end}

{pstd}Linux/Mac usage:{p_end}
{phang2}{cmd:. projectinit "ImpactStudy", root("/home/user/research")}{p_end}

{pstd}Complete workflow example:{p_end}
{phang2}{cmd:. projectinit "MiningSurvey", root("C:/Research") replicate}{p_end}
{phang2}{cmd:. cd "C:/Research/MiningSurvey"}{p_end}
{phang2}{cmd:. do master.do}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:projectinit} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(projname)}}project name{p_end}
{synopt:{cmd:r(mainpath)}}full path to created project{p_end}
{synopt:{cmd:r(created)}}status ("success" if completed){p_end}


{marker structure}{...}
{title:Project structure}

{pstd}
{cmd:projectinit} creates the following structure:

{phang2}ProjectName/{p_end}
{phang3}├── _config.do              (Path configuration file){p_end}
{phang3}├── master.do               (Main execution file){p_end}
{phang3}├── run_all.do              (Automated execution){p_end}
{phang3}├── README.md               (Project documentation){p_end}
{phang3}├── .gitignore              (Git configuration){p_end}
{phang3}│{p_end}
{phang3}├── 00_docs/                (Documentation and papers){p_end}
{phang3}│{p_end}
{phang3}├── 01_data/{p_end}
{phang3}│   ├── raw/                (Original, immutable data){p_end}
{phang3}│   ├── external/           (External datasets){p_end}
{phang3}│   ├── intermediate/       (Processed data){p_end}
{phang3}│   └── final/              (Final analysis datasets){p_end}
{phang3}│{p_end}
{phang3}├── 02_code/{p_end}
{phang3}│   ├── 00_setup/           (Setup scripts){p_end}
{phang3}│   ├── 01_cleaning/        (Data cleaning){p_end}
{phang3}│   ├── 02_analysis/        (Statistical analysis){p_end}
{phang3}│   ├── 03_figures/         (Figure generation){p_end}
{phang3}│   └── 04_tables/          (Table generation){p_end}
{phang3}│{p_end}
{phang3}├── 03_output/{p_end}
{phang3}│   ├── figures/            (Generated figures){p_end}
{phang3}│   ├── tables/             (Generated tables){p_end}
{phang3}│   └── logs/               (Execution logs){p_end}
{phang3}│{p_end}
{phang3}├── 04_replication/         (Optional: replication package){p_end}
{phang3}├── temp/                   (Temporary files){p_end}
{phang3}└── data_backup/            (Backup location){p_end}


{marker practices}{...}
{title:Best practices for reproducible research}

{pstd}
Following AEA/JPAL/MIT standards:

{phang2}1. {bf:Never modify raw data} - Keep 01_data/raw/ unchanged{p_end}
{phang2}2. {bf:Use relative paths} - All paths use globals from _config.do{p_end}
{phang2}3. {bf:Set random seeds} - Ensures reproducibility of simulations{p_end}
{phang2}4. {bf:Document dependencies} - List all required packages in 00_setup.do{p_end}
{phang2}5. {bf:Save execution logs} - All scripts automatically log output{p_end}
{phang2}6. {bf:Version control} - Use git to track all code changes{p_end}
{phang2}7. {bf:Separate code and output} - Code generates all tables/figures{p_end}
{phang2}8. {bf:Linear workflow} - Code executes sequentially from 00 to 04{p_end}


{marker replication}{...}
{title:Replication package guidelines}

{pstd}
When using the {opt replicate} option, additional files are created for AEA compliance:

{phang2}• {bf:replication.do} - Master replication script{p_end}
{phang2}• {bf:README_REPLICATION.md} - Detailed replication instructions{p_end}
{phang2}• {bf:04_replication/} - Self-contained replication folder{p_end}

{pstd}
AEA Data and Code Availability Policy checklist:

{phang2}✓ README with clear instructions{p_end}
{phang2}✓ Master script that runs all code in order{p_end}
{phang2}✓ All required packages documented{p_end}
{phang2}✓ Data availability statement{p_end}
{phang2}✓ Expected runtime documented{p_end}
{phang2}✓ System requirements specified{p_end}
{phang2}✓ Random seeds set for reproducibility{p_end}


{marker author}{...}
{title:Author}

{pstd}
projectinit was developed following AEA, JPAL, and MIT reproducibility standards.

{pstd}
For bug reports, feature requests, or contributions, please visit:
{browse "https://github.com/yourusername/projectinit"}


{marker references}{...}
{title:References}

{pstd}
AEA Data and Code Availability Policy:{break}
{browse "https://www.aeaweb.org/journals/data/data-code-policy"}

{pstd}
JPAL Research Resources:{break}
{browse "https://www.povertyactionlab.org/research-resources"}

{pstd}
Gentzkow, M., & Shapiro, J. M. (2014). Code and Data for the Social Sciences: A Practitioner's Guide.
{browse "https://web.stanford.edu/~gentzkow/research/CodeAndData.pdf"}


{marker also_see}{...}
{title:Also see}

{psee}
Online: {help mkdir}, {help cd}, {help do}
