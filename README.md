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

Before anything else, check whether the `Install.codeunit.al` codeunit has run. You can verify this by going to the `Dime.Scheduler Source Types` list, where you should see entries for the `Opportunity` table and the `SalesPeople/Purchasers` table:

<img src="/assets/sourcetypes.png" height="200px" />

The source type table tells Dime.Scheduler which table should be used when planning data is sent back to Business Central (specifically, the `Dime.Scheduler Appointments` table). Two entities are involved here: the salesperson and the planned opportunity.

When planning data arrives in Dime.Scheduler, the codeunit codeunit `2088002 "DS Handle Opportunity Demo"` is executed, as it is the designated handler specified in the `Source Types` column. The appointments may include various assigned resources, although the Salesperson entity is likely the primary one in this context.

<img src="/assets/sourcetypes-appointments.png" height="800px" />

### Send salespersons

In the `Salespersons/Purchasers` list, go to Actions → Dime.Scheduler → Send All. This sends the salespersons to Dime.Scheduler:

<img src="/assets/sales-all.png" height="200px" />

This action creates a list of resources in Dime.Scheduler with a new resource type:

<img src="/assets/resources.png" height="300px" />

### Send opportunity

Navigate to the opportunity card. At the bottom, you can choose to either:

- Plan the opportunity as a single task, or
- Plan the individual sales cycle stages as separate tasks in Dime.Scheduler.

Whichever option you choose, go to Actions → Dime.Scheduler → Send to Dime.Scheduler.

<img src="/assets/opportunity.png" height="500px" />

The item(s) will now appear in the open tasks list, where they can be assigned to a salesperson.

###  Plan Opportunity

Drag the item to the planning board. This triggers an update to Business Central.

<img src="/assets/planning.png" height="200px" />

Right-click the appointment, navigate to Links, and click on the linked opportunity card item. This will bring you back to Business Central.

### Process Opportunity

In Business Central, the `DS Handle Opportunity Demo` codeunit is executed. It creates a task with the relevant planning data - namely, the assignment of a task to a resource on a specific date and time.

<img src="/assets/bc.png" height="400px" />

In addition to creating a task in Business Central, Dime.Scheduler also creates a link between the Dime.Scheduler appointment and the Business Central task. Any subsequent updates, whether made in Dime.Scheduler or in Business Central, will be propagated to the connected entries. This effectively enables a bidirectional synchronization between Dime.Scheduler and Business Central.

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

