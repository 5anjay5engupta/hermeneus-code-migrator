Below is the translated Perl code from the provided Python script. This Perl script maintains the same functionality and logic, using Perl conventions and idioms.

```perl
use strict;
use warnings;
use DBI;
use POSIX qw(strftime);
use Time::Piece;
use Time::Seconds;
use List::Util qw(shuffle);

sub generate_unique_name {
    my ($existing_names, $length) = @_;
    $length ||= 6;
    my @vowels = qw(a e i o u);
    my @consonants = qw(b c d f g h j k l m n p q r s t v w x y z);

    while (1) {
        my $name = '';
        for my $i (0 .. $length - 1) {
            $name .= $i % 2 == 0 ? $consonants[int(rand(@consonants))] : $vowels[int(rand(@vowels))];
        }
        $name = ucfirst($name);
        unless (exists $existing_names->{$name}) {
            $existing_names->{$name} = 1;
            return $name;
        }
    }
}

sub generate_names {
    my ($num_names) = @_;
    my %existing_names;
    my @first_last_names;

    for (1 .. $num_names) {
        my $first_name = generate_unique_name(\%existing_names, int(rand(5)) + 4);
        my $last_name = generate_unique_name(\%existing_names, int(rand(5)) + 4);
        push @first_last_names, [$first_name, $last_name];
    }
    return @first_last_names;
}

sub create_table {
    my ($db_path, $table_name) = @_;
    my $dbh = DBI->connect("dbi:SQLite:dbname=$db_path", "", "", { RaiseError => 1, AutoCommit => 1 });

    $dbh->do(qq{
        CREATE TABLE IF NOT EXISTS $table_name (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            age INTEGER,
            salary TEXT,
            hire_date TEXT
        )
    });

    $dbh->disconnect();
    print "Table '$table_name' is ready.\n";
}

sub generate_random_hire_date {
    my ($start_date, $end_date) = @_;
    $start_date ||= '2000-01-01';
    $end_date ||= strftime("%Y-%m-%d", localtime);

    my $start = Time::Piece->strptime($start_date, "%Y-%m-%d");
    my $end = Time::Piece->strptime($end_date, "%Y-%m-%d");
    my $random_days = int(rand(($end - $start)->days));
    my $random_date = $start + ONE_DAY * $random_days;

    return $random_date->strftime("%m/%d/%Y");
}

sub generate_data {
    my ($db_path, $table_name, $num_records, $wipe_data) = @_;
    $num_records ||= 100;
    my $dbh = DBI->connect("dbi:SQLite:dbname=$db_path", "", "", { RaiseError => 1, AutoCommit => 1 });

    if ($wipe_data) {
        $dbh->do("DELETE FROM $table_name");
        print "Existing data in table '$table_name' has been wiped.\n";
        $dbh->do("DELETE FROM sqlite_sequence WHERE name='$table_name'");
        print "Identity column for table '$table_name' has been reset.\n";
    }

    my @names = generate_names($num_records);

    for my $name_pair (@names) {
        my ($first_name, $last_name) = @$name_pair;
        my $name = "$first_name $last_name";
        my $age = int(rand(48)) + 18;
        my $salary = sprintf("\$%s", (int(rand(120000)) + 30000));
        my $hire_date = generate_random_hire_date();

        $dbh->do("INSERT INTO $table_name (name, age, salary, hire_date) VALUES (?, ?, ?, ?)",
            undef, $name, $age, $salary, $hire_date);
    }

    print "$num_records records inserted into table '$table_name'.\n";

    my $sth = $dbh->prepare("SELECT * FROM $table_name");
    $sth->execute();
    my $rows = $sth->fetchall_arrayref();
    my @column_names = @{$sth->{NAME}};

    print "\nData in table '$table_name':\n";
    if (@$rows) {
        print format_table(\@column_names, $rows);
    } else {
        print "No data found in the table.\n";
    }

    $dbh->disconnect();
}

sub format_table {
    my ($column_names, $rows) = @_;
    my @col_widths = map { length($_) } @$column_names;
    for my $row (@$rows) {
        for my $i (0 .. $#$row) {
            $col_widths[$i] = length($row->[$i]) if length($row->[$i]) > $col_widths[$i];
        }
    }

    my $row_format = join(" | ", map { sprintf("%%-%ds", $_) } @col_widths);
    my $separator = join("-+-", map { '-' x $_ } @col_widths);

    my $formatted_output = sprintf($row_format, @$column_names) . "\n" . $separator . "\n";
    for my $row (@$rows) {
        $formatted_output .= sprintf($row_format, @$row) . "\n";
    }
    return $formatted_output;
}

# Usage Example
my $db_path = "C:\\GitHub\\SS-Azure-PoC-Project-Repo-Functions-Python\\example.db";
my $table_name = "employees";

print "Enter the number of records to generate (default 100): ";
chomp(my $user_input = <STDIN>);
my $num_records = $user_input =~ /^\d+$/ ? $user_input : 100;
print "Invalid input, defaulting to 100 records.\n" if $user_input !~ /^\d+$/;

my $wipe_data = 1;

create_table($db_path, $table_name);
generate_data($db_path, $table_name, $num_records, $wipe_data);
```