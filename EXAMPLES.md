# Examples - projectinit

This document provides complete, real-world examples of using **projectinit** for different types of research projects.

---

## 📚 Table of Contents

1. [Basic Impact Evaluation](#1-basic-impact-evaluation)
2. [RCT Analysis](#2-rct-analysis)
3. [Regression Discontinuity Design](#3-regression-discontinuity-design)
4. [Panel Data Analysis](#4-panel-data-analysis)
5. [Replication Package for Journal Submission](#5-replication-package-for-journal-submission)
6. [Multi-Project Portfolio](#6-multi-project-portfolio)

---

## 1. Basic Impact Evaluation

### Scenario
Evaluating the impact of a job training program using difference-in-differences.

### Setup

```stata
* Create project
projectinit "JobTraining_DiD", root("C:/Research") replicate verbose

* Navigate to project
cd "C:/Research/JobTraining_DiD"
```

### Configure Paths

Edit `_config.do` (already correct, just verify):
```stata
global ROOT "C:/Research/JobTraining_DiD"
* All other paths are automatically configured
```

### Add Required Packages

Edit `02_code/00_setup/00_setup.do`:
```stata
* Add required packages
local packages "estout reghdfe ftools coefplot"
```

### Data Cleaning

Edit `02_code/01_cleaning/00_clean.do`:
```stata
****************************************************
* DATA CLEANING - Job Training Impact Evaluation
****************************************************

use "$raw/training_data.dta", clear

* Keep relevant variables
keep id year treated outcome age education employed

* Create treatment indicators
gen post = (year >= 2020)
gen did = treated * post

* Label variables
label variable treated "Received job training"
label variable post "Post-treatment period"
label variable did "DiD treatment effect"
label variable outcome "Employment status"

* Handle missing values
mvdecode age education, mv(-99)

* Save cleaned data
compress
save "$intermediate/training_cleaned.dta", replace
```

### Analysis

Edit `02_code/02_analysis/00_analysis.do`:
```stata
****************************************************
* ANALYSIS - Difference-in-Differences
****************************************************

use "$intermediate/training_cleaned.dta", clear

* Descriptive statistics by treatment group
estpost tabstat outcome age education, ///
    by(treated) statistics(mean sd n)
esttab using "$tables/table1_descriptives.tex", ///
    cells("mean(fmt(2)) sd(fmt(2)) count(fmt(0))") replace

* Main DiD regression
reghdfe outcome did treated post, ///
    absorb(id year) ///
    cluster(id)
estimates store did_main

* With controls
reghdfe outcome did treated post age education, ///
    absorb(id year) ///
    cluster(id)
estimates store did_controls

* Export results
esttab did_main did_controls ///
    using "$tables/table2_did_results.tex", ///
    b(3) se(3) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    label replace ///
    mtitles("Baseline" "With Controls")

* Save estimates for figures
estimates save "$temp/did_estimates.ster", replace
```

### Run Everything

```stata
do master.do
```

Or use automated execution:
```stata
do run_all.do
```

---

## 2. RCT Analysis

### Scenario
Analyzing results from a randomized controlled trial of a health intervention.

### Setup

```stata
projectinit "HealthRCT", root("D:/Projects") replicate
cd "D:/Projects/HealthRCT"
```

### Package Configuration

Edit `02_code/00_setup/00_setup.do`:
```stata
local packages "estout ritest randomizr"
```

### Analysis Example

Edit `02_code/02_analysis/00_analysis.do`:
```stata
****************************************************
* RCT ANALYSIS
****************************************************

use "$intermediate/rct_cleaned.dta", clear

* Check randomization balance
local balance_vars "age gender education income"

foreach var of local balance_vars {
    reg `var' treatment, robust
    estimates store balance_`var'
}

esttab balance_* using "$tables/table1_balance.tex", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) replace

* Main treatment effects
reg health_outcome treatment, robust
estimates store main

* With controls
reg health_outcome treatment age gender education income, robust
estimates store controls

* Heterogeneous effects by gender
reg health_outcome treatment##i.gender age education income, robust
estimates store hetero_gender

* Export all results
esttab main controls hetero_gender ///
    using "$tables/table2_main_results.tex", ///
    b(3) se(3) ///
    star(* 0.10 ** 0.05 *** 0.01) ///
    label replace

* Randomization inference (if needed)
* ritest treatment _b[treatment], reps(1000): ///
*     reg health_outcome treatment age gender education income
```

---

## 3. Regression Discontinuity Design

### Scenario
Analyzing the impact of a scholarship program with a cutoff score.

### Setup

```stata
projectinit "Scholarship_RDD", root("C:/Research") replicate
cd "C:/Research/Scholarship_RDD"
```

### Packages

Edit `02_code/00_setup/00_setup.do`:
```stata
local packages "estout rdrobust rddensity rdlocrand"
```

### Analysis

Edit `02_code/02_analysis/00_analysis.do`:
```stata
****************************************************
* RDD ANALYSIS
****************************************************

use "$intermediate/scholarship_cleaned.dta", clear

* Running variable: test_score
* Cutoff: 70
* Outcome: college_enrollment

* Center running variable at cutoff
gen score_centered = test_score - 70

* Manipulation test
rddensity score_centered
matrix density_test = e(results)

* Main RD estimate
rdrobust college_enrollment test_score, c(70)
outreg2 using "$tables/table_rd_main.tex", replace

* Different bandwidths
rdrobust college_enrollment test_score, c(70) h(5)
estimates store bw_5

rdrobust college_enrollment test_score, c(70) h(10)
estimates store bw_10

rdrobust college_enrollment test_score, c(70) h(15)
estimates store bw_15

* Placebo test at different cutoffs
rdrobust college_enrollment test_score, c(65)
estimates store placebo_65

rdrobust college_enrollment test_score, c(75)
estimates store placebo_75
```

### Figures

Edit `02_code/03_figures/00_figures.do`:
```stata
****************************************************
* RDD FIGURES
****************************************************

use "$intermediate/scholarship_cleaned.dta", clear

* RD plot
rdplot college_enrollment test_score, c(70) ///
    graph_options(title("RD Plot: Scholarship Impact") ///
                  xtitle("Test Score") ///
                  ytitle("College Enrollment Rate") ///
                  scheme(s2color))
graph export "$figures/figure1_rdplot.png", replace width(3000)
graph export "$figures/figure1_rdplot.pdf", replace

* Density plot
twoway (histogram test_score if test_score < 70, width(2) color(blue%50)) ///
       (histogram test_score if test_score >= 70, width(2) color(red%50)), ///
       xline(70, lcolor(black) lwidth(medium)) ///
       legend(label(1 "Below Cutoff") label(2 "Above Cutoff")) ///
       title("Distribution of Test Scores") ///
       xtitle("Test Score") ytitle("Frequency") ///
       scheme(s2color)
graph export "$figures/figure2_density.png", replace width(3000)
```

---

## 4. Panel Data Analysis

### Scenario
Analyzing the impact of minimum wage changes using state-level panel data.

### Setup

```stata
projectinit "MinWage_Panel", root("C:/Research") replicate
cd "C:/Research/MinWage_Panel"
```

### Packages

```stata
* In 02_code/00_setup/00_setup.do
local packages "estout reghdfe ftools event_plot"
```

### Analysis

```stata
****************************************************
* PANEL DATA ANALYSIS
****************************************************

use "$intermediate/minwage_panel.dta", clear

* Declare panel structure
xtset state_id year

* Two-way fixed effects
reghdfe employment min_wage, absorb(state_id year) cluster(state_id)
estimates store twfe

* Event study
gen event_time = year - treatment_year
gen pre_treat = (event_time < 0)

* Create event time dummies
forvalues i = 1/5 {
    gen pre`i' = (event_time == -`i')
    gen post`i' = (event_time == `i')
}

* Event study regression (omit -1 as base)
reghdfe employment pre5 pre4 pre3 pre2 post1-post5, ///
    absorb(state_id year) cluster(state_id)
estimates store event_study

* Export results
esttab twfe event_study using "$tables/table_panel.tex", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) ///
    label replace
```

### Event Study Plot

```stata
* In 02_code/03_figures/00_figures.do

* Coefficient plot for event study
coefplot event_study, ///
    keep(pre5 pre4 pre3 pre2 post1 post2 post3 post4 post5) ///
    vertical ///
    yline(0, lcolor(black)) ///
    xline(4.5, lpattern(dash) lcolor(gray)) ///
    ylabel(, angle(0)) ///
    title("Event Study: Minimum Wage Impact") ///
    xtitle("Years Relative to Treatment") ///
    ytitle("Effect on Employment") ///
    scheme(s2color)
graph export "$figures/figure_event_study.png", replace width(3000)
```

---

## 5. Replication Package for Journal Submission

### Scenario
Preparing a complete replication package for AEA submission.

### Setup

```stata
projectinit "Paper_Replication", root("C:/Submission") replicate verbose
cd "C:/Submission/Paper_Replication"
```

### Organize Replication Folder

1. **Copy final code to replication folder**

```stata
* Copy all do-files
copy "02_code/00_setup/00_setup.do" "04_replication/code/00_setup.do"
copy "02_code/01_cleaning/00_clean.do" "04_replication/code/01_clean.do"
copy "02_code/02_analysis/00_analysis.do" "04_replication/code/02_analysis.do"
copy "02_code/03_figures/00_figures.do" "04_replication/code/03_figures.do"
copy "02_code/04_tables/00_tables.do" "04_replication/code/04_tables.do"
```

2. **Copy final/external data** (if allowed by data agreement)

```stata
copy "01_data/final/analysis_data.dta" "04_replication/data/analysis_data.dta"
```

3. **Update replication.do**

Edit `04_replication/replication.do`:
```stata
****************************************************
* REPLICATION PACKAGE
* Paper: "Title of Your Paper"
* Authors: Maykol Medrano
* Journal: Journal Name
****************************************************

clear all
set more off
version 17.0

* UPDATE THIS PATH
global ROOT "C:/Submission/Paper_Replication"
global repl "$ROOT/04_replication"

* Install required packages
local packages "estout reghdfe ftools"
foreach pkg of local packages {
    capture which `pkg'
    if _rc {
        ssc install `pkg', replace
    }
}

* Set seed for reproducibility
set seed 123456789

* Start log
log using "$repl/output/logs/replication.log", replace text

* Run all scripts in order
do "$repl/code/00_setup.do"
do "$repl/code/01_clean.do"
do "$repl/code/02_analysis.do"
do "$repl/code/03_figures.do"
do "$repl/code/04_tables.do"

* Summary
display ""
display "Replication completed successfully!"
display "Check output folder for all results"

log close
```

4. **Complete README_REPLICATION.md**

Edit `04_replication/README_REPLICATION.md` with:
- Data sources and access instructions
- Software requirements (Stata version, packages)
- Hardware requirements (RAM, expected runtime)
- Step-by-step instructions
- Table of correspondence between paper and output files

5. **Test replication on clean machine**

```stata
* Delete all intermediate files
* Run from scratch
cd "C:/Submission/Paper_Replication/04_replication"
do replication.do
```

6. **Create ZIP for submission**

```
04_replication.zip containing:
├── README_REPLICATION.md
├── replication.do
├── code/
│   ├── 00_setup.do
│   ├── 01_clean.do
│   ├── 02_analysis.do
│   ├── 03_figures.do
│   └── 04_tables.do
├── data/
│   └── analysis_data.dta
└── output/ (empty folders)
    ├── figures/
    ├── tables/
    └── logs/
```

---

## 6. Multi-Project Portfolio

### Scenario
Managing multiple related projects with consistent structure.

### Setup

```stata
* Create parent directory
mkdir "C:/Research/MinimumWage_Portfolio"

* Create sub-projects
projectinit "01_DataConstruction", root("C:/Research/MinimumWage_Portfolio")
projectinit "02_MainAnalysis", root("C:/Research/MinimumWage_Portfolio")
projectinit "03_Robustness", root("C:/Research/MinimumWage_Portfolio")
projectinit "04_Mechanisms", root("C:/Research/MinimumWage_Portfolio")
```

### Shared Configuration

Create a master config file: `C:/Research/MinimumWage_Portfolio/shared_config.do`

```stata
****************************************************
* SHARED CONFIGURATION FOR PROJECT PORTFOLIO
****************************************************

* Portfolio root
global PORTFOLIO "C:/Research/MinimumWage_Portfolio"

* Individual project roots
global PROJ1 "$PORTFOLIO/01_DataConstruction"
global PROJ2 "$PORTFOLIO/02_MainAnalysis"
global PROJ3 "$PORTFOLIO/03_Robustness"
global PROJ4 "$PORTFOLIO/04_Mechanisms"

* Shared data location
global SHARED_DATA "$PORTFOLIO/shared_data"
mkdir "$SHARED_DATA"

* Common packages
local packages "estout reghdfe ftools ivreg2"
foreach pkg of local packages {
    capture which `pkg'
    if _rc {
        ssc install `pkg', replace
    }
}

display "Portfolio configuration loaded"
display "Projects: 01_DataConstruction, 02_MainAnalysis, 03_Robustness, 04_Mechanisms"
```

### Link Projects

In each project's `_config.do`, add at the beginning:
```stata
* Load shared configuration
do "C:/Research/MinimumWage_Portfolio/shared_config.do"

* Then load project-specific config
global ROOT "$PROJ2"  * Adjust number for each project
* ... rest of config
```

---

## 🎯 Quick Reference

### Command Templates

```stata
* Basic
projectinit "ProjectName", root("Path/To/Parent")

* With replication
projectinit "ProjectName", root("Path/To/Parent") replicate

* Verbose output
projectinit "ProjectName", root("Path/To/Parent") verbose

* Overwrite existing
projectinit "ProjectName", root("Path/To/Parent") overwrite

* All options
projectinit "ProjectName", root("Path/To/Parent") replicate verbose overwrite
```

### Common Workflows

```stata
* 1. Create
projectinit "MyProject", root("C:/Research")

* 2. Configure
cd "C:/Research/MyProject"
doedit _config.do

* 3. Setup packages
doedit 02_code/00_setup/00_setup.do

* 4. Run
do master.do
```

---

**For more examples and use cases, see the main [README.md](README.md) and [TESTING_GUIDE.md](TESTING_GUIDE.md).**
