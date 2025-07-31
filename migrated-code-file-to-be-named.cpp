To translate the given SQL query into C++, we need to simulate the database operations using C++ constructs. This involves creating a data structure to represent the employees and implementing the logic to filter and display the names based on the condition. Here's a complete C++ translation:

```cpp
#include <iostream>
#include <vector>
#include <string>
#include <algorithm>

// Define a structure to represent an employee
struct Employee {
    std::string name;
    std::string grade;
};

// Function to filter employees based on grade
std::vector<std::string> filterEmployeesByGrade(const std::vector<Employee>& employees, const std::string& gradeCriteria) {
    std::vector<std::string> filteredNames;
    for (const auto& employee : employees) {
        // Check if the employee's grade contains the gradeCriteria
        if (employee.grade.find(gradeCriteria) != std::string::npos) {
            filteredNames.push_back(employee.name);
        }
    }
    return filteredNames;
}

int main() {
    // Sample data representing employees
    std::vector<Employee> employees = {
        {"Alice", "VP"},
        {"Bob", "Manager"},
        {"Charlie", "VP"},
        {"David", "Senior VP"},
        {"Eve", "Junior VP"}
    };

    // Define the grade criteria
    std::string gradeCriteria = "VP";

    // Get the filtered list of employee names
    std::vector<std::string> filteredNames = filterEmployeesByGrade(employees, gradeCriteria);

    // Display the names of employees who meet the criteria
    std::cout << "Employees with grade containing \"" << gradeCriteria << "\":" << std::endl;
    for (const auto& name : filteredNames) {
        std::cout << name << std::endl;
    }

    return 0;
}
```

### Explanation:
- **Data Structure**: We use a `struct` to represent an employee with `name` and `grade` fields.
- **Filtering Logic**: The function `filterEmployeesByGrade` iterates over the list of employees and checks if the `grade` contains the substring "VP". If it does, the employee's name is added to the `filteredNames` vector.
- **Main Function**: We create a sample list of employees, define the grade criteria, and call the filtering function. The results are then printed to the console.