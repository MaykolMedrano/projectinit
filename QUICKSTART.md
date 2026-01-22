# Quick Start Guide - projectinit

Get up and running with **projectinit** in 5 minutes.

---

## ⚡ Installation (1 minute)

### Windows

```stata
* Download files to a folder, then:
cd "C:/path/to/projectinit"
do projectinit_install.do
```

### Mac/Linux

```stata
cd "/path/to/projectinit"
do projectinit_install.do
```

### Verify Installation

```stata
which projectinit
help projectinit
```

---

## 🚀 Create Your First Project (2 minutes)

### Step 1: Create Project

```stata
projectinit "MyFirstProject", root("C:/Research")
```

**Mac/Linux:**
```stata
projectinit "MyFirstProject", root("~/research")
```

### Step 2: Navigate to Project

```stata
cd "C:/Research/MyFirstProject"
```

### Step 3: Verify Structure

```stata
dir
```

You should see:
```
_config.do
master.do
run_all.do
README.md
.gitignore
00_docs/
01_data/
02_code/
03_output/
temp/
data_backup/
```

---

## 🔧 Configure Your Project (2 minutes)

### Step 1: Check Paths

```stata
do _config.do
```

Paths are automatically configured! Just verify:
```stata
display "$ROOT"
display "$data"
display "$code"
display "$output"
```

### Step 2: Add Required Packages (Optional)

Edit `02_code/00_setup/00_setup.do`:

```stata
doedit 02_code/00_setup/00_setup.do
```

Add packages you need:
```stata
* Find this section:
local packages ""

* Change to:
local packages "estout reghdfe ftools"
```

### Step 3: Run Setup

```stata
do 02_code/00_setup/00_setup.do
```

Packages are installed automatically!

---

## 📊 Start Working

### Add Your Data

Place raw data files in:
```
01_data/raw/
```

Example:
```stata
copy "C:/MyData/survey.dta" "$raw/survey.dta"
```

### Write Your Code

Edit the template files:

```stata
* Data cleaning
doedit 02_code/01_cleaning/00_clean.do

* Analysis
doedit 02_code/02_analysis/00_analysis.do

* Figures
doedit 02_code/03_figures/00_figures.do

* Tables
doedit 02_code/04_tables/00_tables.do
```

### Run Everything

**Option A: Manual control**
```stata
do master.do
```

**Option B: Automated execution**
```stata
do run_all.do
```

---

## 📁 Understanding the Structure

### Data Flow

```
raw/ → cleaning scripts → intermediate/ → analysis → final/
```

### Code Flow

```
00_setup → 01_cleaning → 02_analysis → 03_figures → 04_tables
```

### Key Directories

| Directory | What Goes Here |
|-----------|----------------|
| `01_data/raw/` | Original data (never modified!) |
| `01_data/intermediate/` | Cleaned data |
| `01_data/final/` | Final analysis datasets |
| `02_code/` | All your Stata scripts |
| `03_output/figures/` | Generated graphs/charts |
| `03_output/tables/` | Generated tables |
| `03_output/logs/` | Execution logs |

---

## 💡 Common Tasks

### Task 1: Clean Your Data

Edit `02_code/01_cleaning/00_clean.do`:

```stata
use "$raw/mydata.dta", clear

* Your cleaning code here
drop if age < 0
gen log_income = log(income)

save "$intermediate/mydata_clean.dta", replace
```

Run it:
```stata
do 02_code/01_cleaning/00_clean.do
```

### Task 2: Run a Regression

Edit `02_code/02_analysis/00_analysis.do`:

```stata
use "$intermediate/mydata_clean.dta", clear

regress outcome treatment controls, robust
estimates store model1

* Save results for tables
estimates save "$temp/regression.ster", replace
```

Run it:
```stata
do 02_code/02_analysis/00_analysis.do
```

### Task 3: Make a Figure

Edit `02_code/03_figures/00_figures.do`:

```stata
use "$intermediate/mydata_clean.dta", clear

twoway scatter y x, ///
    title("My First Figure") ///
    scheme(s2color)

graph export "$figures/scatter.png", replace width(3000)
graph export "$figures/scatter.pdf", replace
```

Run it:
```stata
do 02_code/03_figures/00_figures.do
```

### Task 4: Make a Table

Edit `02_code/04_tables/00_tables.do`:

```stata
use "$intermediate/mydata_clean.dta", clear

* Summary statistics
estpost summarize var1 var2 var3
esttab using "$tables/summary.tex", ///
    cells("mean sd min max") replace

* Regression table
estimates use "$temp/regression.ster"
esttab using "$tables/regression.tex", ///
    b(3) se(3) star(* 0.10 ** 0.05 *** 0.01) replace
```

Run it:
```stata
do 02_code/04_tables/00_tables.do
```

---

## 🎯 Best Practices

### ✅ DO

- **Use globals for all paths**: `"$raw/data.dta"` not `"C:/data.dta"`
- **Never modify raw data**: Keep originals unchanged
- **Comment your code**: Future you will thank you
- **Run scripts sequentially**: 00 → 01 → 02 → 03 → 04
- **Save logs**: Already automated for you!
- **Set random seed**: In `00_setup.do` for reproducibility

### ❌ DON'T

- Don't use absolute paths (except in `_config.do`)
- Don't edit raw data files
- Don't save output in data folders
- Don't skip the setup file
- Don't forget to update README.md

---

## 🔄 Typical Workflow

1. **Morning**: Check what you did yesterday
   ```stata
   cd "C:/Research/MyProject"
   view 03_output/logs/  * Check latest log
   ```

2. **Work**: Edit and test your code
   ```stata
   doedit 02_code/02_analysis/00_analysis.do
   do 02_code/02_analysis/00_analysis.do  * Test
   ```

3. **Before leaving**: Run everything
   ```stata
   do run_all.do  * Full replication
   ```

4. **Before sharing**: Check outputs
   ```stata
   dir 03_output/figures
   dir 03_output/tables
   ```

---

## 🆘 Quick Troubleshooting

### "file not found"
→ Check your paths in `_config.do`

### "command not found"
→ Add packages to `00_setup.do` and run it

### "folder already exists"
→ Use `overwrite` option: `projectinit "Name", root("C:/") overwrite`

### "permission denied"
→ Check folder permissions or use different location

---

## 📚 Next Steps

Now that you're set up:

1. **Read full documentation**: `README.md`
2. **See examples**: `EXAMPLES.md`
3. **Learn testing**: `TESTING_GUIDE.md`
4. **Prepare for submission**: Add `replicate` option

---

## 🎓 Tutorial: Complete Example

Let's create a simple project from start to finish.

### 1. Create Project

```stata
projectinit "Tutorial", root("C:/Temp") verbose
cd "C:/Temp/Tutorial"
```

### 2. Create Fake Data

```stata
clear
set obs 100
gen id = _n
gen treatment = (id <= 50)
gen outcome = 10 + 5*treatment + rnormal(0, 2)
save "01_data/raw/tutorial_data.dta", replace
```

### 3. Clean Data

Edit `02_code/01_cleaning/00_clean.do`:
```stata
use "$raw/tutorial_data.dta", clear
label variable treatment "Treatment group"
label variable outcome "Outcome variable"
save "$intermediate/tutorial_clean.dta", replace
```

### 4. Analyze

Edit `02_code/02_analysis/00_analysis.do`:
```stata
use "$intermediate/tutorial_clean.dta", clear
regress outcome treatment, robust
estimates store model1
estimates save "$temp/tutorial_est.ster", replace
```

### 5. Make Figure

Edit `02_code/03_figures/00_figures.do`:
```stata
use "$intermediate/tutorial_clean.dta", clear
graph box outcome, over(treatment) ///
    scheme(s2color)
graph export "$figures/boxplot.png", replace
```

### 6. Make Table

Edit `02_code/04_tables/00_tables.do`:
```stata
estimates use "$temp/tutorial_est.ster"
esttab using "$tables/regression.tex", ///
    b(3) se(3) replace
```

### 7. Run Everything

```stata
do run_all.do
```

### 8. Check Results

```stata
dir 03_output/figures
dir 03_output/tables
dir 03_output/logs
```

Done! You've completed your first **projectinit** project! 🎉

---

## 🚀 Advanced: With Replication Package

For journal submission:

```stata
projectinit "MyPaper", root("C:/Research") replicate

cd "C:/Research/MyPaper"

* ... do your work ...

* When ready to submit:
cd 04_replication
doedit README_REPLICATION.md  * Complete documentation
doedit replication.do  * Update with your scripts

* Test replication
do replication.do

* Package for submission
* ZIP the 04_replication folder and submit
```

---

**You're ready to go! Start your reproducible research journey with projectinit! 🎯**

For detailed documentation, run `help projectinit` or see [README.md](README.md).
