# SQL File Analyzer & Tester

A command-line PHP tool for analyzing and testing SQL dump files before importing them into production databases. Identifies syntax errors, structural issues, and problematic queries without affecting your live data.

## Features

- Parses SQL files with proper handling of semicolons inside string values
- Static analysis to detect common issues (multiple AUTO_INCREMENT columns, invalid SQL keywords)
- Executes queries against a test database to identify runtime errors
- Detailed error reporting with query numbers and previews
- Progress indicator for large files
- Error log export for documentation

## Requirements

- PHP 7.4 or higher with PDO MySQL extension
- MySQL 5.7+ or MariaDB 10.3+

### Verify Installation

```bash
php -v
mysql --version
```

## Installation

```bash
git clone https://github.com/yourusername/sql-analyzer.git
cd sql-analyzer
```

No additional dependencies required.

## Configuration

Edit the configuration section at the top of `index.php`:

```php
$host = 'localhost';
$port = 3306;           // Default MySQL port
$username = 'root';
$password = '';         // Your MySQL password
$database = 'test_import';
```

## Usage

### Basic Usage

```bash
php index.php /path/to/your/file.sql
```

### Examples

**Linux/macOS:**

```bash
php index.php ~/backups/database_dump.sql
php index.php /var/www/exports/tenant.sql
```

**Windows:**

```cmd
php index.php C:\backups\database_dump.sql
php index.php "C:\Users\Name\Documents\export.sql"
```

## Output

The tool runs in two phases:

### Phase 1: Static Analysis

Scans the SQL file for common structural issues without executing queries:

- Multiple AUTO_INCREMENT columns in a single table
- Queries that do not start with valid SQL keywords
- Malformed CREATE TABLE statements

### Phase 2: Execution Test

Executes each query against a test database and reports:

- Success/failure count
- Detailed error messages with query context
- Table names involved in failures

### Sample Output

```
===========================================
   SQL FILE ANALYZER & TESTER (v2)
===========================================

📁 File: /path/to/tenant.sql
📊 Size: 503.69 KB
🔌 MySQL: localhost:3306

⏳ Parsing SQL file (this may take a moment)...
📝 Total queries found: 698

===========================================
   PHASE 1: STATIC ANALYSIS
===========================================

✅ No obvious issues detected.

===========================================
   PHASE 2: EXECUTION TEST
===========================================

✅ Connected to MySQL (localhost:3306)
✅ Using database: test_import

⏳ Progress: 698 / 698 (100%) - ✅ 697 / ❌ 1

===========================================
   FINAL SUMMARY
===========================================

✅ Successful: 697 / 698 (99.9%)
❌ Failed: 1 / 698
```

## Error Log

When errors occur, a timestamped log file is generated:

```
errors_2024-01-28_09-53-26.txt
```

Contains full query text and error details for each failed query.

## Common Issues Detected

| Issue                              | Description                                                                |
| ---------------------------------- | -------------------------------------------------------------------------- |
| AUTO_INCREMENT without PRIMARY KEY | Column marked as AUTO_INCREMENT must be a key                              |
| Multiple AUTO_INCREMENT            | Only one AUTO_INCREMENT column per table allowed                           |
| Missing parentheses                | Syntax errors like `ADD PRIMARY KEY id)` instead of `ADD PRIMARY KEY (id)` |
| Truncated queries                  | Semicolons in HTML/CSS content causing query splits                        |
| Invalid SQL keywords               | Lines that do not start with valid SQL statements                          |

## Troubleshooting

### Connection Refused

Verify MySQL is running and the port is correct:

```bash
# Linux
sudo systemctl status mysql

# Check port
mysql -u root -p -e "SHOW VARIABLES LIKE 'port';"
```

### Permission Denied

Ensure your MySQL user has CREATE/DROP database privileges:

```sql
GRANT ALL PRIVILEGES ON test_import.* TO 'username'@'localhost';
FLUSH PRIVILEGES;
```

### Memory Issues with Large Files

For files larger than 100MB, increase PHP memory limit:

```bash
php -d memory_limit=512M index.php large_file.sql
```

## How It Works

1. Reads the entire SQL file into memory
2. Removes SQL comments (single-line and multi-line)
3. Splits queries using a parser that respects quoted strings
4. Creates a fresh test database
5. Executes each query sequentially
6. Collects and reports all errors

## Security Notes

- The tool creates and drops a test database on each run
- Never use production database credentials
- Database name is configurable to avoid conflicts
- No data is sent externally

## Example Files

The repository includes sample SQL files for testing:

| File                      | Description                                                  |
| ------------------------- | ------------------------------------------------------------ |
| `example.sql`             | Valid SQL dump with realistic data (users, products, orders) |
| `example_with_errors.sql` | SQL dump with intentional errors for testing                 |

### Testing with Example Files

```bash
# Test with valid SQL (should pass 100%)
php index.php example.sql

# Test with errors (will detect 3 errors)
php index.php example_with_errors.sql
```

### Errors in example_with_errors.sql

1. `ALTER TABLE ... AUTO_INCREMENT` executed before `PRIMARY KEY` is defined
2. Missing parenthesis: `ADD PRIMARY KEY id)` instead of `ADD PRIMARY KEY (id)`
3. Missing parenthesis: `INSERT INTO widgets id,` instead of `INSERT INTO widgets (id,`

## License

MIT License

## Contributing

1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## Author

[Your Name]

## Changelog

### v2.0.0

- Improved SQL parser to handle semicolons in string values
- Added static analysis phase
- Color-coded terminal output
- Progress indicator
- Error log export
