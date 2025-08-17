To translate the given C# code into PL/SQL, we need to simulate the behavior of a SQL query that returns no results. In PL/SQL, this can be achieved by creating a procedure that uses a cursor with a condition that always evaluates to false, ensuring no rows are fetched. Here's how you can implement this in PL/SQL:

```plsql
DECLARE
    -- Define a cursor that simulates the SQL query: SELECT * FROM tbl WHERE 1 = 2
    CURSOR empty_cursor IS
        SELECT * FROM tbl WHERE 1 = 2;

    -- Variable to hold fetched row data
    v_row tbl%ROWTYPE;
BEGIN
    -- Open the cursor
    OPEN empty_cursor;

    -- Fetch from the cursor
    FETCH empty_cursor INTO v_row;

    -- Check if any row was fetched
    IF empty_cursor%NOTFOUND THEN
        DBMS_OUTPUT.PUT_LINE('Query Results: No rows returned.');
    ELSE
        -- This block will not execute because the condition 1 = 2 is always false
        LOOP
            DBMS_OUTPUT.PUT_LINE('Row data: ' || v_row.column_name); -- Replace 'column_name' with actual column names
            FETCH empty_cursor INTO v_row;
            EXIT WHEN empty_cursor%NOTFOUND;
        END LOOP;
    END IF;

    -- Close the cursor
    CLOSE empty_cursor;
END;
/
```

### Explanation:
- **Cursor Declaration**: The `empty_cursor` is defined to select from `tbl` where `1 = 2`, which will always return no rows.
- **Row Fetching**: The `FETCH` statement attempts to retrieve a row from the cursor. Since the condition is always false, no rows will be fetched.
- **Output**: The `DBMS_OUTPUT.PUT_LINE` is used to print a message indicating that no rows were returned.
- **Loop**: The loop is included to demonstrate how rows would be processed if any were fetched, but it will not execute in this case.