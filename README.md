# PowerShell Deployment Agent

PSDA is an Excel/VBA application for managing bulk inputs of 
PowerShell scripts for deployment to remote targets.
It's core function is the clean and reliable export/import of flat (.CSV)
text files to/from Excel Tables.

## How To Use
You need a launch script that you reference from the Control sheet in the workbook
and (grudgingly optionally) one or more scripts that contain functions. You then build
out your data worksheets to feed the functions of the same name.
I will be releasing "libraries" of these functions grouped by remotely accessible technology
stack (starting with SharePoint Online). 

## PowerShell Script Design
The core base functionality is built on by partnering it with
a two-tier PowerShell script pattern:
1. Launch script - triggered from the Excel workbook, this shells out
to a PS cmd prompt and kicks off the deployment. This script accepts 
a number of standard parameters that allows it to know what
folder to find the CSVs in and how to connect to the target environment.
2. Functions script - one or more .ps1 files, invoked from the Launch 
script, that contain only functions with a single parameter: '$rows'.

### Convention over Configuration
By making the name of each data worksheet match the name of the exported CSV
file, match the corresponding function, the amount of boilerplate code is significantly
reduced. For example, the Launch script doesn't need to know the name of any of
the functions. It can just invoke them based on the array of function names 
passed in and hand over the identically named CSV file.

### Splatting
Splatting is used extensively (and augmented using the fabulous Invoke-Splat function)
to prevent the need to explicitly name the parameters for cmdlets we are passing data to
from the CSV (in many cases). As long as we name the Table column the same as the
parameter name in the lower level cmdlet/function then we are keeping the code as DRY
as possible. This is not always possible, due to some side effects/errors when using
the Invoke-Splat method on some cmdlets, but on the whole the codebase is cleaner because
of using this approach.

## Excel Model Design
The approach for the Excel VBA model is trying to strike the right balance between
complete separation of code from data (done this before as an add-in and it's hard to maintain
and overly complex to do with VBA) and keeping the VBA footprint small and tight (at the expense 
of separation).

In the interests of expediency and maintainability, I've decided to keep the model in an all-in-one
macro-enabled workbook (PSDA.xlsm). The majority of the VBA code in the model is to facilitate the
sanitizing (exporting with full fidelity) and rehydrating (re-importing with full fidelity) the data
in the workbook. This allows customer data to be ejected and sample/test data to be reimported, 
in order to run E2E tests of all functions and commit that sanitized version of the workbook back to
the master repo, ready for use on the next project. As more use cases are required, the number of sheets
in the workbook will grow, but this is very much a work in progress. Please submit any bugs through github issues and
I'll get to them as soon as possible.

### Exportable Excel Features
As the maintainability of this model is completely dependent on the ability to serialise the contents
of the tables in the workbook, there are many features of Excel which cannot be persisted into CSV format
and therefore should not be used. Rather than list them all, here are the key ones that *can* be used:
+ Formulas - formulas are exported only when sanitising (otherwise the resulting value of the formula is
 exported) and are writtenm back in on rehydration.
+ Comments (only on column headers) - these are serialised using tokens and extracted from the header cell
value upon rehydration. These are important to describe what values should go in the column.
+ Conditional formats - these are helpful to highlight conditionally mandatory columns, or to highlight when
inputed values are the incorrect format, etc
+ Data validation - this allows in-cell dropdowns to reference tables (in the Reference sheet) 

All contributions welcome! Please create a branch and submit via PR, not directly to the master branch. Thanks!
