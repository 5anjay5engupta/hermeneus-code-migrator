Below is the translated Perl code from the provided Visual Basic code. The translation maintains the same functionality and logic while adhering to Perl conventions and idioms.

```perl
#!/usr/bin/perl
use strict;
use warnings;

# Process customer data
sub process_customer_data {
    my @customers;
    my $customer_name;
    my $customer_age;
    my $customer_email;

    for my $i (1..10) {
        print "Enter customer name: ";
        chomp($customer_name = <STDIN>);
        
        print "Enter customer age: ";
        chomp($customer_age = <STDIN>);
        $customer_age = int($customer_age); # Convert to integer
        
        print "Enter customer email: ";
        chomp($customer_email = <STDIN>);
        
        # Create customer record
        my $customer_record = "$customer_name,$customer_age,$customer_email";
        push @customers, $customer_record;
        
        # Validate age
        if ($customer_age < 18) {
            print "Customer $customer_name is under 18\n";
        }
    }
    
    # Display total customers processed
    print "Total customers processed: " . scalar(@customers) . "\n";
    
    # Display all customers
    for my $i (0..$#customers) {
        print "Customer " . ($i + 1) . ": $customers[$i]\n";
    }
}

# Call the subroutine to process customer data
process_customer_data();
```

### Explanation:
- **Input Handling**: Used `chomp` to remove newline characters from input, similar to `InputBox` in VB.
- **Array Usage**: Used an array `@customers` to store customer records, similar to the `Collection` in VB.
- **Looping**: Used Perl's range operator `1..10` for the loop, equivalent to `For i = 1 To 10`.
- **String Concatenation**: Used Perl's string interpolation for creating the customer record.
- **Conditional Statements**: Used Perl's `if` for age validation.
- **Output**: Used `print` for displaying messages, similar to `MsgBox` and `Debug.Print` in VB.