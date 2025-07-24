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

1. Git clone this repo:

```
git clone https://github.com/dime-scheduler/bc-connector-examples.git
```

2. Open in VS Code: 
```
code bc-connector-examples
```

3. Update .vscode/launch.json to point to your BC instance

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            // ...            
            "name": "BC26",
            "server": "http://BC26/BC",
            "serverInstance": "BC",
            "authentication": "UserPassword"
            // ...            
        }
    ]
}
```

4. Download the symbols: `CTRL + SHIFT + P` -> `AL: Download Symbols`
5. Hit F5 to start debugging

## Prerequisites

The Dime.Scheduler base app must be deployed and configured.

## How to use this example

### Setting up source types

Before all else, check whether the `Install.codeunit.al` code unit has run. You can verify this by going to the `Dime.Scheduler Source Types` list, where you should see an entry for the `Opportunity` table and the `Salesperson/Purchaser` tables:

<img src="/assets/sourcetypes.png" height="200px" />

The source type table is used to tell Dime.Scheduler which table should be used when planning comes back into BC (specifically - the `Dime.Scheduler Appointments` table). Two moving parts are in play: the sales person, and the planned opportunity. 

When planning arrives in Dime.Scheduler, the code unit `codeunit 2088002 "DS Handle Opportunity Demo"` is executed, since that's the correlated handling unit as specified in the source types column. The resources assigned to the appointments can be bountiful, although the salesperson entity is probably the only entity worth considering in this example.

<img src="/assets/sourcetypes-appointments.png" height="800px" />

## Send sales persons

In the salespersons list, go to actions -> Dime.Scheduler -> Send all. This sends 

<img src="/assets/sales-all.png" height="200px" />

This creates a list of resources in Dime.Scheduler with a new resource type 

<img src="/assets/resources.png" height="300px" />

## Send opportunity

Navigate to the opportunity card. Here you can choose - at the bottom - to plan the opportunity as 1 task, or plan the sales cycle stages as tasks in Dime.Scheduler. Whichever option you choose, to go Actions -> Dime.Scheduler -> Send to Dime.Scheduler

<img src="/assets/opportunity.png" height="500px" />

The item(s) now arrive in the open tasks list, which can now assign to a sales person.

## Plan opportunity

Drag the item to the planning board. This triggers an update to BC.

<img src="/assets/planning.png" height="200px" />

Right click the appointment, navigate to Links, and click on the opportunity card item. This takes you back to BC.

## Process opportunity

In BC, the `DS Handle Opportunity Demo` is executed. This code creates a task with the planning data, being the assignment of a task to a resource on a certain date and time.

<img src="/assets/bc.png" height="400px" />

Besides creating a task in BC, Dime.Scheduler also creates a link entry between the Dime.Scheduler appointment and the task. Subsequent updates to the planning in Dime.Scheduler - or updates made in BC - will be propogated to the connected entries (this, effectively, enables the bidirectional flow between Dime.Scheduler and BC).

## Project Structure

```
root/
├── app.json                          # Application manifest
├── Install.codeunit.al               # Installation and setup initialization
├── Opportunity/
│   ├── SendOpportunity.codeunit.al   # Main opportunity sending logic
│   ├── HandleOpportunity.codeunit.al # Opportunity handling and processing
│   ├── OpportunityCardExt.PageExt.al # Opportunity card page extension
│   ├── OpportunityExt.TableExt.al    # Opportunity table extension
│   └── ToDoExt.TableExt.al           # ToDo table extension
├── Salespersons/
│   ├── SendSalesPerson.codeunit.al   # Salesperson resource sending logic
│   ├── SalespersonCardExt.PageExt.al # Salesperson card page extension
│   └── SalespersonExt.PageExt.al     # Salesperson list page extension
```

## Dependencies

- **Dime.Scheduler**: Version 2.6.0.0 or higher
- **Microsoft Dynamics 365 Business Central**: Version 26.0.0.0 or higher
- **Platform**: 16.0.0.0
- **Application**: 16.0.0.0
- **Runtime**: 14.0

