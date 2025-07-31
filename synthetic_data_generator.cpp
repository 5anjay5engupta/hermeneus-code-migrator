Below is the translated C++ code from the provided Python script. This translation maintains the same functionality and logic while adapting to C++ conventions and idioms.

```cpp
#include <iostream>
#include <string>
#include <vector>
#include <set>
#include <random>
#include <ctime>
#include <iomanip>
#include <sstream>
#include <sqlite3.h>

// Function to generate a unique, pronounceable name
std::string generate_unique_name(std::set<std::string>& existing_names, int length = 6) {
    const std::string vowels = "aeiou";
    const std::string consonants = "bcdfghjklmnpqrstvwxyz";
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> vowel_dist(0, vowels.size() - 1);
    std::uniform_int_distribution<> consonant_dist(0, consonants.size() - 1);

    while (true) {
        std::string name;
        for (int i = 0; i < length; ++i) {
            if (i % 2 == 0) {
                name += consonants[consonant_dist(gen)];
            } else {
                name += vowels[vowel_dist(gen)];
            }
        }
        name[0] = toupper(name[0]);
        if (existing_names.find(name) == existing_names.end()) {
            existing_names.insert(name);
            return name;
        }
    }
}

// Function to generate a set of unique first and last name pairs
std::vector<std::pair<std::string, std::string>> generate_names(int num_names) {
    std::set<std::string> existing_names;
    std::vector<std::pair<std::string, std::string>> first_last_names;
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> length_dist(4, 8);

    for (int i = 0; i < num_names; ++i) {
        std::string first_name = generate_unique_name(existing_names, length_dist(gen));
        std::string last_name = generate_unique_name(existing_names, length_dist(gen));
        first_last_names.emplace_back(first_name, last_name);
    }
    return first_last_names;
}

// Function to create a table if it does not exist
void create_table(const std::string& db_path, const std::string& table_name) {
    sqlite3* db;
    char* err_msg = nullptr;
    int rc = sqlite3_open(db_path.c_str(), &db);

    if (rc != SQLITE_OK) {
        std::cerr << "Cannot open database: " << sqlite3_errmsg(db) << std::endl;
        sqlite3_close(db);
        return;
    }

    std::string sql = "CREATE TABLE IF NOT EXISTS " + table_name + " ("
                      "id INTEGER PRIMARY KEY AUTOINCREMENT, "
                      "name TEXT, "
                      "age INTEGER, "
                      "salary TEXT, "
                      "hire_date TEXT);";

    rc = sqlite3_exec(db, sql.c_str(), 0, 0, &err_msg);

    if (rc != SQLITE_OK) {
        std::cerr << "SQL error: " << err_msg << std::endl;
        sqlite3_free(err_msg);
    } else {
        std::cout << "Table '" << table_name << "' is ready." << std::endl;
    }

    sqlite3_close(db);
}

// Function to generate a random hire date
std::string generate_random_hire_date(const std::string& start_date = "2000-01-01", const std::string& end_date = "") {
    std::tm start_tm = {};
    std::tm end_tm = {};
    std::istringstream ss_start(start_date);
    ss_start >> std::get_time(&start_tm, "%Y-%m-%d");

    std::time_t start_time = std::mktime(&start_tm);
    std::time_t end_time;

    if (end_date.empty()) {
        end_time = std::time(nullptr);
    } else {
        std::istringstream ss_end(end_date);
        ss_end >> std::get_time(&end_tm, "%Y-%m-%d");
        end_time = std::mktime(&end_tm);
    }

    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dist(0, std::difftime(end_time, start_time) / (60 * 60 * 24));

    std::time_t random_time = start_time + dist(gen) * (60 * 60 * 24);
    std::tm* random_tm = std::localtime(&random_time);

    char buffer[11];
    std::strftime(buffer, sizeof(buffer), "%m/%d/%Y", random_tm);
    return std::string(buffer);
}

// Function to generate synthetic data for the given table
void generate_data(const std::string& db_path, const std::string& table_name, int num_records = 100, bool wipe_data = false) {
    sqlite3* db;
    char* err_msg = nullptr;
    int rc = sqlite3_open(db_path.c_str(), &db);

    if (rc != SQLITE_OK) {
        std::cerr << "Cannot open database: " << sqlite3_errmsg(db) << std::endl;
        sqlite3_close(db);
        return;
    }

    if (wipe_data) {
        std::string sql_delete = "DELETE FROM " + table_name + ";";
        rc = sqlite3_exec(db, sql_delete.c_str(), 0, 0, &err_msg);

        if (rc != SQLITE_OK) {
            std::cerr << "SQL error: " << err_msg << std::endl;
            sqlite3_free(err_msg);
        } else {
            std::cout << "Existing data in table '" << table_name << "' has been wiped." << std::endl;
        }

        std::string sql_reset = "DELETE FROM sqlite_sequence WHERE name='" + table_name + "';";
        rc = sqlite3_exec(db, sql_reset.c_str(), 0, 0, &err_msg);

        if (rc != SQLITE_OK) {
            std::cerr << "SQL error: " << err_msg << std::endl;
            sqlite3_free(err_msg);
        } else {
            std::cout << "Identity column for table '" << table_name << "' has been reset." << std::endl;
        }
    }

    auto names = generate_names(num_records);
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> age_dist(18, 65);
    std::uniform_int_distribution<> salary_dist(30000, 150000);

    for (const auto& [first_name, last_name] : names) {
        std::string name = first_name + " " + last_name;
        int age = age_dist(gen);
        std::ostringstream salary_stream;
        salary_stream.imbue(std::locale(""));
        salary_stream << std::showbase << std::put_money(salary_dist(gen));
        std::string salary = salary_stream.str();
        std::string hire_date = generate_random_hire_date();

        std::string sql_insert = "INSERT INTO " + table_name + " (name, age, salary, hire_date) VALUES ('" +
                                 name + "', " + std::to_string(age) + ", '" + salary + "', '" + hire_date + "');";

        rc = sqlite3_exec(db, sql_insert.c_str(), 0, 0, &err_msg);

        if (rc != SQLITE_OK) {
            std::cerr << "SQL error: " << err_msg << std::endl;
            sqlite3_free(err_msg);
        }
    }

    std::cout << num_records << " records inserted into table '" << table_name << "'." << std::endl;

    std::string sql_select = "SELECT * FROM " + table_name + ";";
    sqlite3_stmt* stmt;
    rc = sqlite3_prepare_v2(db, sql_select.c_str(), -1, &stmt, nullptr);

    if (rc != SQLITE_OK) {
        std::cerr << "Failed to fetch data: " << sqlite3_errmsg(db) << std::endl;
    } else {
        int cols = sqlite3_column_count(stmt);
        std::vector<std::string> column_names;
        for (int i = 0; i < cols; ++i) {
            column_names.push_back(sqlite3_column_name(stmt, i));
        }

        std::vector<std::vector<std::string>> rows;
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            std::vector<std::string> row;
            for (int i = 0; i < cols; ++i) {
                const char* text = reinterpret_cast<const char*>(sqlite3_column_text(stmt, i));
                row.push_back(text ? text : "NULL");
            }
            rows.push_back(row);
        }

        std::cout << "\nData in table '" << table_name << "':" << std::endl;
        if (!rows.empty()) {
            std::cout << format_table(column_names, rows) << std::endl;
        } else {
            std::cout << "No data found in the table." << std::endl;
        }
    }

    sqlite3_finalize(stmt);
    sqlite3_close(db);
}

// Function to format the table output with aligned columns
std::string format_table(const std::vector<std::string>& column_names, const std::vector<std::vector<std::string>>& rows) {
    std::vector<size_t> col_widths(column_names.size(), 0);
    for (size_t i = 0; i < column_names.size(); ++i) {
        col_widths[i] = column_names[i].size();
    }

    for (const auto& row : rows) {
        for (size_t i = 0; i < row.size(); ++i) {
            col_widths[i] = std::max(col_widths[i], row[i].size());
        }
    }

    std::ostringstream oss;
    for (size_t i = 0; i < column_names.size(); ++i) {
        oss << std::setw(col_widths[i]) << std::left << column_names[i];
        if (i < column_names.size() - 1) {
            oss << " | ";
        }
    }
    oss << "\n";

    for (size_t i = 0; i < column_names.size(); ++i) {
        oss << std::string(col_widths[i], '-');
        if (i < column_names.size() - 1) {
            oss << "-+-";
        }
    }
    oss << "\n";

    for (const auto& row : rows) {
        for (size_t i = 0; i < row.size(); ++i) {
            oss << std::setw(col_widths[i]) << std::left << row[i];
            if (i < row.size() - 1) {
                oss << " | ";
            }
        }
        oss << "\n";
    }

    return oss.str();
}

int main() {
    std::string db_path = "C:\\GitHub\\SS-Azure-PoC-Project-Repo-Functions-Python\\example.db";
    std::string table_name = "employees";

    // Ask user for the number of records to generate
    int num_records = 100;
    std::cout << "Enter the number of records to generate (default 100): ";
    std::string user_input;
    std::getline(std::cin, user_input);
    if (!user_input.empty()) {
        try {
            num_records = std::stoi(user_input);
        } catch (const std::invalid_argument&) {
            std::cout << "Invalid input, defaulting to 100 records." << std::endl;
            num_records = 100;
        }
    }

    bool wipe_data = true;

    create_table(db_path, table_name);
    generate_data(db_path, table_name, num_records, wipe_data);

    return 0;
}
```

**