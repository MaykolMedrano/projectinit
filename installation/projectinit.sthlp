{smcl}
{* *! version 2.1.0  22jan2026}{...}
{vieweralsosee "[P] mkdir" "help mkdir"}{...}
{vieweralsosee "[P] project" "help project"}{...}
{viewerjumpto "Syntax" "projectinit##syntax"}{...}
{viewerjumpto "Description" "projectinit##description"}{...}
{viewerjumpto "Options" "projectinit##options"}{...}
{viewerjumpto "Examples" "projectinit##examples"}{...}
{viewerjumpto "Stored results" "projectinit##results"}{...}
{viewerjumpto "References" "projectinit##references"}{...}
{viewerjumpto "Author" "projectinit##author"}{...}
{title:Title}

{p2colset 5 20 22 2}{...}
{p2col:{cmd:projectinit} {hline 2}}Professional Research Project Initializer (Enterprise){p_end}
{p2colreset}{...}


{marker syntax}{...}
{title:Syntax}

{p 8 16 2}
{cmd:projectinit}
{it:projname}
{cmd:,}
{opt root(path)}
[{it:options}]

{synoptset 25 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Required}
{synopt:{opt root(path)}}parent directory for the project{p_end}

{syntab:Main}
{synopt:{opt lang:uage(string)}}language for templates; {cmd:en} or {cmd:es}; default is {cmd:en}{p_end}
{synopt:{opt author(string)}}author name; default is current username{p_end}
{synopt:{opt email(string)}}email address{p_end}

{syntab:Templates}
{synopt:{opt latex(string)}}LaTeX environment; {cmd:none}, {cmd:puc}, or {cmd:standard}; default is {cmd:none}{p_end}
{synopt:{opt github(string)}}GitHub integration; {cmd:none}, {cmd:public}, or {cmd:private}; default is {cmd:none}{p_end}
{synopt:{opt replicate}}generate AEA-compliant replication package{p_end}

{syntab:Advanced}
{synopt:{opt overwrite}}overwrite existing project directory{p_end}
{synopt:{opt verbose}}display detailed progress information{p_end}
{synoptline}
{p2colreset}{...}


{marker description}{...}
{title:Description}

{pstd}
{cmd:projectinit} creates professional, reproducible research project structures
following international best practices from J-PAL (MIT), DIME (World Bank),
the AEA Data Editor, and NBER.

{pstd}
The command generates a complete project infrastructure including:

{phang2}• Standardized folder structure (01_Data, 02_Scripts, 03_Outputs, etc.){p_end}
{phang2}• Master execution script (run.do) with environment isolation{p_end}
{phang2}• Setup and configuration scripts (00_setup.do){p_end}
{phang2}• Elite .gitignore for version control{p_end}
{phang2}• AEA-compliant README.md with replication instructions{p_end}
{phang2}• Optional LaTeX environment (PUC thesis or standard article){p_end}
{phang2}• Optional GitHub repository initialization{p_end}
{phang2}• Optional AEA replication package (06_Replication/){p_end}

{pstd}
The project structure ensures:

{phang2}• {bf:Reproducibility}: One-click execution via run.do{p_end}
{phang2}• {bf:Portability}: Dynamic paths work on any machine{p_end}
{phang2}• {bf:Isolation}: Project-specific ado files avoid conflicts{p_end}
{phang2}• {bf:Documentation}: Comprehensive README and inline comments{p_end}
{phang2}• {bf:Version Control}: Git-ready with professional .gitignore{p_end}
{phang2}• {bf:Compliance}: Meets AEA, J-PAL, DIME, and NBER standards{p_end}


{marker options}{...}
{title:Options}

{dlgtab:Required}

{phang}
{opt root(path)} specifies the parent directory where the project will be created.
The path must exist and be writable. Can be absolute (e.g., {cmd:"C:/Research"})
or relative (e.g., {cmd:"."} for current directory).

{dlgtab:Main}

{phang}
{opt lang:uage(string)} sets the language for generated templates and comments.
Options are {cmd:en} (English) or {cmd:es} (Spanish). Default is {cmd:en}.
This affects script comments, README language, and section headings.

{phang}
{opt author(string)} specifies the author name for documentation and git configuration.
If not specified, uses the current system username. Used in README, git commits,
and LaTeX documents.

{phang}
{opt email(string)} specifies the author's email address for documentation and
git configuration. Required for GitHub integration. Used in README and git commits.

{dlgtab:Templates}

{phang}
{opt latex(string)} generates a LaTeX writing environment in {cmd:04_Writing/}.
Options are:

{phang2}• {cmd:none} (default): No LaTeX files generated{p_end}
{phang2}• {cmd:puc}: Pontificia Universidad Católica de Chile thesis template
with institutional formatting, 9pt font, a4paper, complete preamble{p_end}
{phang2}• {cmd:standard}: Standard academic article template with common packages{p_end}

{pmore}
LaTeX templates include {cmd:main.tex}, {cmd:preamble.tex}, {cmd:macros.tex}
(for Stata-generated macros), section files, and {cmd:references.bib}.

{phang}
{opt github(string)} initializes a git repository and creates a GitHub repository.
Options are:

{phang2}• {cmd:none} (default): No git/GitHub initialization{p_end}
{phang2}• {cmd:public}: Create public GitHub repository{p_end}
{phang2}• {cmd:private}: Create private GitHub repository{p_end}

{pmore}
Requires {cmd:git} and {cmd:gh} (GitHub CLI) to be installed and authenticated.
Creates initial commit and pushes to GitHub. Configures git with author name and email.

{phang}
{opt replicate} generates an AEA Data Editor-compliant replication package in
{cmd:06_Replication/} including README_REPLICATION.md with data availability
statement, computational requirements, and replication instructions.

{dlgtab:Advanced}

{phang}
{opt overwrite} allows overwriting an existing project directory. Use with caution
as this will delete all existing files in the project folder.

{phang}
{opt verbose} displays detailed progress information during project creation,
including system information, folder creation status, and file generation confirmation.


{marker examples}{...}
{title:Examples}

{pstd}Basic project with default settings{p_end}
{phang2}{cmd:. projectinit "MyResearch", root("C:/Projects")}{p_end}

{pstd}Complete setup with LaTeX, GitHub, and replication package{p_end}
{phang2}{cmd:. projectinit "Impact-Evaluation", ///}{p_end}
{phang2}{cmd:    root("C:/Research") ///}{p_end}
{phang2}{cmd:    latex(standard) ///}{p_end}
{phang2}{cmd:    github(private) ///}{p_end}
{phang2}{cmd:    replicate ///}{p_end}
{phang2}{cmd:    author("John Doe") ///}{p_end}
{phang2}{cmd:    email("jdoe@university.edu") ///}{p_end}
{phang2}{cmd:    verbose}{p_end}

{pstd}PUC thesis project in Spanish{p_end}
{phang2}{cmd:. projectinit "Tesis-Maestria", ///}{p_end}
{phang2}{cmd:    root("C:/Documentos") ///}{p_end}
{phang2}{cmd:    latex(puc) ///}{p_end}
{phang2}{cmd:    language(es) ///}{p_end}
{phang2}{cmd:    author("María González") ///}{p_end}
{phang2}{cmd:    email("mgonzalez@uc.cl")}{p_end}

{pstd}Quick project in current directory{p_end}
{phang2}{cmd:. projectinit "QuickAnalysis", root(".")}{p_end}

{pstd}Overwrite existing project (use with caution){p_end}
{phang2}{cmd:. projectinit "OldProject", root("C:/Projects") overwrite}{p_end}


{marker results}{...}
{title:Stored results}

{pstd}
{cmd:projectinit} stores the following in {cmd:r()}:

{synoptset 20 tabbed}{...}
{p2col 5 20 24 2: Scalars}{p_end}
{synopt:{cmd:r(N_folders)}}number of folders created{p_end}
{synopt:{cmd:r(N_files)}}number of files created{p_end}

{p2col 5 20 24 2: Macros}{p_end}
{synopt:{cmd:r(project_path)}}full path to created project{p_end}
{synopt:{cmd:r(project_name)}}project name{p_end}
{synopt:{cmd:r(language)}}language used{p_end}
{synopt:{cmd:r(latex_template)}}LaTeX template used (if any){p_end}
{synopt:{cmd:r(github_status)}}GitHub integration status{p_end}
{p2colreset}{...}


{marker references}{...}
{title:References}

{pstd}
This package implements best practices from:

{phang}
Christensen, G., R. Freese, E. Miguel, et al. 2019.
{it:Transparent and Reproducible Social Science Research}.
Berkeley: University of California Press.
{browse "https://www.bitss.org/"}

{phang}
Gentzkow, M. and J. M. Shapiro. 2014.
{it:Code and Data for the Social Sciences: A Practitioner's Guide}.
{browse "https://web.stanford.edu/~gentzkow/research/CodeAndData.pdf"}

{phang}
World Bank DIME Analytics. 2021.
{it:Development Research in Practice: The DIME Analytics Data Handbook}.
Washington, DC: World Bank.
{browse "https://worldbank.github.io/dime-data-handbook/"}

{phang}
J-PAL. 2023.
{it:J-PAL Research Resources}.
Cambridge: Abdul Latif Jameel Poverty Action Lab.
{browse "https://www.povertyactionlab.org/research-resources"}

{phang}
American Economic Association. 2023.
{it:AEA Data Editor: Guidance for Data and Code Preparation}.
{browse "https://aeadataeditor.github.io/"}


{marker author}{...}
{title:Author}

{pstd}Maykol Medrano{p_end}
{pstd}Instituto de Economía{p_end}
{pstd}Pontificia Universidad Católica de Chile{p_end}
{pstd}Email: {browse "mailto:mmedrano2@uc.cl":mmedrano2@uc.cl}{p_end}
{pstd}GitHub: {browse "https://github.com/MaykolMedrano"}{p_end}


{title:Also see}

{psee}
Online: {helpb project}, {helpb mkdir}, {helpb adopath}
{p_end}
