****************************************************
* TEST: GitHub Integration Fix Verification
* Purpose: Verify that github() option creates repository correctly
* Date: 22jan2026
****************************************************

clear all
set more off

display as text ""
display as text "{hline 78}"
display as text "{bf:Testing GitHub Integration Fix}"
display as text "{hline 78}"
display as text ""

* Test location
local test_root "C:/Temp/projectinit_github_test"
capture mkdir "`test_root'"

display as text "This test will verify that the GitHub integration now works correctly."
display as text ""
display as text "{bf:Prerequisites:}"
display as text "  1. GitHub CLI (gh) must be installed"
display as text "  2. You must be authenticated: gh auth login"
display as text ""
display as text "Test directory: `test_root'"
display as text ""

* Check if gh is available
display as text "Checking GitHub CLI availability..."
capture shell gh --version
if _rc == 0 {
    display as result "  ✓ GitHub CLI found"

    * Check authentication
    display as text "Checking GitHub CLI authentication..."
    capture shell gh auth status
    if _rc == 0 {
        display as result "  ✓ GitHub CLI authenticated"
        display as text ""
        display as text "Ready to test. This will create a test repository on your GitHub account."
        display as text ""
        display as text "Press Ctrl+C to cancel, or any key to continue..."
        pause

        * Run the test
        display as text ""
        display as result "{hline 78}"
        display as result "Creating test project with GitHub integration..."
        display as result "{hline 78}"
        display as text ""

        projectinit "test-projectinit-github-fix", ///
            root("`test_root'") ///
            github(private) ///
            author("Test User") ///
            email("test@example.com") ///
            verbose

        display as text ""
        display as result "{hline 78}"
        display as result "Test completed!"
        display as result "{hline 78}"
        display as text ""
        display as text "Please verify:"
        display as text "  1. Repository was created on GitHub: https://github.com/YOUR_USERNAME/test-projectinit-github-fix"
        display as text "  2. Initial commit was pushed"
        display as text "  3. Files are visible on GitHub"
        display as text ""
        display as text "To clean up:"
        display as text "  - Delete local folder: `test_root'/test-projectinit-github-fix"
        display as text "  - Delete GitHub repo: gh repo delete test-projectinit-github-fix"
        display as text ""
    }
    else {
        display as error "  ✗ GitHub CLI not authenticated"
        display as text ""
        display as text "Please authenticate first:"
        display as text "  gh auth login"
        display as text ""
        display as text "Then run this test again."
    }
}
else {
    display as error "  ✗ GitHub CLI not found"
    display as text ""
    display as text "Please install GitHub CLI from: https://cli.github.com/"
    display as text ""
    display as text "After installation:"
    display as text "  1. Open a new terminal"
    display as text "  2. Run: gh auth login"
    display as text "  3. Run this test again"
}

display as text ""
display as text "{hline 78}"
