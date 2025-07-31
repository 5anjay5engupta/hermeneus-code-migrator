import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

public class CustomerDatabase {

    public static void main(String[] args) {
        new CustomerDatabase().processCustomerData();
    }

    private void processCustomerData() {
        List<String> customers = new ArrayList<>();
        Scanner scanner = new Scanner(System.in);

        for (int i = 0; i < 10; i++) {
            System.out.print("Enter customer name: ");
            String customerName = scanner.nextLine();

            System.out.print("Enter customer age: ");
            int customerAge = Integer.parseInt(scanner.nextLine());

            System.out.print("Enter customer email: ");
            String customerEmail = scanner.nextLine();

            // Create customer record
            String customerRecord = customerName + "," + customerAge + "," + customerEmail;
            customers.add(customerRecord);

            // Validate age
            if (customerAge < 18) {
                System.out.println("Customer " + customerName + " is under 18");
            }
        }

        // Display all customers
        System.out.println("Total customers processed: " + customers.size());

        for (int i = 0; i < customers.size(); i++) {
            System.out.println("Customer " + (i + 1) + ": " + customers.get(i));
        }

        scanner.close();
    }
}
```