CREATE OR REPLACE FUNCTION generate_fibonacci_series(p_start IN NUMBER, p_end IN NUMBER) 
RETURN SYS.ODCINUMBERLIST IS
    -- Declare variables to hold Fibonacci numbers
    a NUMBER := 0;
    b NUMBER := 1;
    fibonacci_series SYS.ODCINUMBERLIST := SYS.ODCINUMBERLIST();
    idx NUMBER := 1;
BEGIN
    -- Generate Fibonacci numbers until the largest number is greater than 'p_end'
    WHILE a <= p_end LOOP
        -- Only add the number to the series if it is within the specified range
        IF a >= p_start THEN
            fibonacci_series.EXTEND;
            fibonacci_series(idx) := a;
            idx := idx + 1;
        END IF;
        -- Move to the next Fibonacci number
        a := b;
        b := a + b;
    END LOOP;

    RETURN fibonacci_series;
END generate_fibonacci_series;
/

DECLARE
    -- Define the range for the Fibonacci series
    v_start NUMBER := 50;
    v_end NUMBER := 550;
    v_fibonacci_series SYS.ODCINUMBERLIST;
BEGIN
    -- Generate the Fibonacci series within the specified range
    v_fibonacci_series := generate_fibonacci_series(v_start, v_end);

    -- Print the Fibonacci series
    FOR i IN 1 .. v_fibonacci_series.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(v_fibonacci_series(i));
    END LOOP;
END;
/
```