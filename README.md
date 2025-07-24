<div align="center">
<img src="https://cdn.dimescheduler.com/dime-scheduler/v2/logo.svg" height="100px" />
</div>


<div align="center">
<h1>BC Connector Examples</h1>
</div>

This demo application provides working examples of how to:
- Send opportunities from Business Central to Dime.Scheduler
- Send salespersons as resources in Dime.Scheduler
- Process planned opportunities in BC as opportunity tasks

## Installation

1. Git clone this repositority
2. Open in VS Code
3. Update .vscode/launch.json to point to your BC instance
4. Download the symbols (CTRL + P > AL: Symbols)
5. Build or run (F5)

## Project Structure

```
root/
├── app.json                          # Application manifest
├── AppSourceCop.json                 # AppSource compliance settings
├── Assets/
│   ├── logo.png                      # Application logo
│   └── PackageDIME.SCHEDULER.rapidstart  # Rapid start package
├── Opportunity/
│   ├── SendOpportunity.codeunit.al   # Main opportunity sending logic
│   ├── HandleOpportunity.codeunit.al # Opportunity handling and processing
│   ├── OpportunityCardExt.PageExt.al # Opportunity page extensions
│   └── ToDoExt.TableExt.al          # ToDo table extensions
├── Salespersons/
│   ├── SendSalesPerson.codeunit.al   # Salesperson resource sending logic
│   ├── SalespersonCardExt.PageExt.al # Salesperson card extensions
│   └── SalespersonExt.PageExt.al    # Salesperson page extensions
└── Translations/
    └── Dime.Scheduler.Demo.g.xlf     # Translation files
```

## Dependencies

- **Dime.Scheduler**: Version 2.6.0.0 or higher
- **Microsoft Dynamics 365 Business Central**: Version 26.0.0.0 or higher
- **Platform**: 16.0.0.0
- **Application**: 16.0.0.0
- **Runtime**: 14.0

## Screenshots

<img src="/assets//screenshot.png" height="800px" />
