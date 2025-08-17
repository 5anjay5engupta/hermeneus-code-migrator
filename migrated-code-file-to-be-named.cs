To translate the given SQL query into C#, we need to understand that the SQL query is designed to return no results because the condition `1 = 2` is always false. In C#, we can simulate this by creating a method that returns an empty collection, as there is no direct equivalent of a SQL query that returns no results.

Here's how you can translate the SQL query into C#:

```csharp
using System;
using System.Collections.Generic;
using System.Data;

class Program
{
    static void Main()
    {
        // Simulate the SQL query: select * from tbl where 1 = 2
        var results = GetEmptyResults();

        // Output the results
        Console.WriteLine("Query Results:");
        foreach (var row in results)
        {
            Console.WriteLine(row);
        }
    }

    static List<DataRow> GetEmptyResults()
    {
        // This method simulates a query that returns no results
        return new List<DataRow>();
    }
}
```

### Explanation:
- **GetEmptyResults Method**: This method simulates the SQL query by returning an empty list of `DataRow`, which represents no results.
- **Main Method**: Calls `GetEmptyResults` and attempts to print the results, which will result in no output since the list is empty.