#include <iostream>
#include <string>
#include <iomanip>

int main() {
    // Payroll Calculation System
    std::string employeeName;
    double hoursWorked, hourlyRate;
    double regularPay, overtimePay, grossPay, tax, netPay;
    double overtimeHours = 0.0;

    // Input employee details
    std::cout << "Enter employee name: ";
    std::getline(std::cin, employeeName);
    std::cout << "Enter hours worked: ";
    std::cin >> hoursWorked;
    std::cout << "Enter hourly rate: ";
    std::cin >> hourlyRate;

    // Calculate regular and overtime pay
    if (hoursWorked > 40) {
        overtimeHours = hoursWorked - 40;
        regularPay = 40 * hourlyRate;
        overtimePay = overtimeHours * hourlyRate * 1.5;
    } else {
        regularPay = hoursWorked * hourlyRate;
        overtimePay = 0.0;
    }

    grossPay = regularPay + overtimePay;
    tax = grossPay * 0.15;
    netPay = grossPay - tax;

    // Output payroll details
    std::cout << std::fixed << std::setprecision(2);
    std::cout << "Employee: " << employeeName << std::endl;
    std::cout << "Hours worked: " << hoursWorked << std::endl;
    std::cout << "Regular pay: $" << regularPay << std::endl;
    std::cout << "Overtime pay: $" << overtimePay << std::endl;
    std::cout << "Gross pay: $" << grossPay << std::endl;
    std::cout << "Tax deduction: $" << tax << std::endl;
    std::cout << "Net pay: $" << netPay << std::endl;

    return 0;
}
```