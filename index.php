#!/usr/bin/env php
<?php
/**
 * SQL File Analyzer & Tester
 * 
 * Analyzes and tests SQL dump files before importing to production.
 * Identifies syntax errors and structural issues.
 * 
 * Usage: php index.php /path/to/file.sql
 * 
 * @version 2.0.0
 * @license MIT
 */

// ============================================
// CONFIGURATION
// ============================================
$host     = 'localhost';
$port     = 3306;
$username = 'root';
$password = '';
$database = 'test_import';

// ============================================
// INITIALIZATION
// ============================================
$sqlFileName = $argv[1] ?? null;

// Terminal colors
$RED    = "\033[31m";
$GREEN  = "\033[32m";
$YELLOW = "\033[33m";
$BLUE   = "\033[34m";
$RESET  = "\033[0m";

// Disable colors on Windows
if (PHP_OS_FAMILY === 'Windows') {
    $RED = $GREEN = $YELLOW = $BLUE = $RESET = '';
}

// ============================================
// FUNCTIONS
// ============================================

/**
 * Display usage instructions
 */
function showUsage($scriptName) {
    echo "Usage: php {$scriptName} <sql_file>\n\n";
    echo "Example:\n";
    echo "  php {$scriptName} /path/to/database.sql\n";
    echo "  php {$scriptName} backup.sql\n";
    exit(1);
}

/**
 * Split SQL content into individual queries
 * Handles semicolons inside quoted strings correctly
 */
function splitSqlQueries($sql) {
    $queries = [];
    $currentQuery = '';
    $inString = false;
    $stringChar = '';
    $length = strlen($sql);
    
    for ($i = 0; $i < $length; $i++) {
        $char = $sql[$i];
        $prevChar = ($i > 0) ? $sql[$i - 1] : '';
        
        if (($char === "'" || $char === '"') && $prevChar !== '\\') {
            if (!$inString) {
                $inString = true;
                $stringChar = $char;
            } elseif ($char === $stringChar) {
                $nextChar = ($i + 1 < $length) ? $sql[$i + 1] : '';
                if ($nextChar === $char) {
                    $currentQuery .= $char;
                    $i++;
                    $currentQuery .= $sql[$i];
                    continue;
                }
                $inString = false;
                $stringChar = '';
            }
        }
        
        if ($char === ';' && !$inString) {
            $trimmedQuery = trim($currentQuery);
            if (!empty($trimmedQuery)) {
                if (!preg_match('/^--/', $trimmedQuery) && !preg_match('/^\/\*/', $trimmedQuery)) {
                    $queries[] = $trimmedQuery;
                }
            }
            $currentQuery = '';
        } else {
            $currentQuery .= $char;
        }
    }
    
    $trimmedQuery = trim($currentQuery);
    if (!empty($trimmedQuery) && !preg_match('/^--/', $trimmedQuery)) {
        $queries[] = $trimmedQuery;
    }
    
    return $queries;
}

/**
 * Extract table name from query
 */
function extractTableName($query) {
    if (preg_match('/(?:CREATE TABLE|INSERT INTO|ALTER TABLE)\s+(?:IF NOT EXISTS\s+)?`?(\w+)`?/i', $query, $match)) {
        return $match[1];
    }
    return 'N/A';
}

// ============================================
// MAIN SCRIPT
// ============================================

echo "\n{$BLUE}===========================================\n";
echo "   SQL FILE ANALYZER & TESTER (v2)\n";
echo "==========================================={$RESET}\n\n";

// Validate input
if ($sqlFileName === null) {
    echo "{$RED}Error: No SQL file specified.{$RESET}\n\n";
    showUsage($argv[0]);
}

if (!file_exists($sqlFileName)) {
    echo "{$RED}Error: File not found: {$sqlFileName}{$RESET}\n";
    exit(1);
}

// File information
$fileSize = round(filesize($sqlFileName) / 1024, 2);
echo "File: {$sqlFileName}\n";
echo "Size: {$fileSize} KB\n";
echo "Server: {$host}:{$port}\n\n";

// Read and parse SQL file
$sqlContent = file_get_contents($sqlFileName);

// Remove comments
$sqlClean = preg_replace('/\/\*.*?\*\//s', '', $sqlContent);
$sqlClean = preg_replace('/^--.*$/m', '', $sqlClean);

echo "Parsing SQL file...\n";

$queries = splitSqlQueries($sqlClean);
$totalQueries = count($queries);

echo "Total queries found: {$totalQueries}\n\n";

// ============================================
// PHASE 1: STATIC ANALYSIS
// ============================================

echo "{$BLUE}===========================================\n";
echo "   PHASE 1: STATIC ANALYSIS\n";
echo "==========================================={$RESET}\n\n";

$potentialIssues = [];
$validStarts = ['CREATE', 'INSERT', 'UPDATE', 'DELETE', 'ALTER', 'DROP', 'SET', 'USE', 
                'LOCK', 'UNLOCK', 'START', 'COMMIT', 'ROLLBACK', 'TRUNCATE'];

foreach ($queries as $index => $query) {
    $queryNum = $index + 1;
    $isCreateTable = stripos($query, 'CREATE TABLE') !== false;
    
    if ($isCreateTable) {
        preg_match('/CREATE TABLE\s+(?:IF NOT EXISTS\s+)?`?(\w+)`?/i', $query, $tableMatch);
        $tableName = $tableMatch[1] ?? 'unknown';
        
        $autoIncrementCount = substr_count(strtoupper($query), 'AUTO_INCREMENT');
        
        if ($autoIncrementCount > 1) {
            $potentialIssues[] = [
                'query_num' => $queryNum,
                'table' => $tableName,
                'issue' => "Multiple AUTO_INCREMENT columns ({$autoIncrementCount} found)",
                'severity' => 'HIGH'
            ];
        }
    }
    
    $firstWord = strtoupper(preg_replace('/[^A-Z]/i', '', substr($query, 0, 20)));
    
    $isValid = false;
    foreach ($validStarts as $start) {
        if (strpos($firstWord, $start) === 0) {
            $isValid = true;
            break;
        }
    }
    
    if (!$isValid && strlen($query) > 10) {
        $potentialIssues[] = [
            'query_num' => $queryNum,
            'table' => 'N/A',
            'issue' => "Query doesn't start with valid SQL keyword",
            'severity' => 'HIGH',
            'preview' => substr($query, 0, 100)
        ];
    }
}

if (empty($potentialIssues)) {
    echo "{$GREEN}No obvious issues detected.{$RESET}\n\n";
} else {
    echo "{$YELLOW}Found " . count($potentialIssues) . " potential issue(s):{$RESET}\n\n";
    $shown = 0;
    foreach ($potentialIssues as $issue) {
        if ($shown >= 10) {
            echo "... and " . (count($potentialIssues) - 10) . " more issues\n\n";
            break;
        }
        $icon = $issue['severity'] === 'HIGH' ? "{$RED}[HIGH]" : "{$YELLOW}[WARN]";
        echo "{$icon} Query #{$issue['query_num']} - {$issue['issue']}{$RESET}\n";
        if (isset($issue['preview'])) {
            echo "   Preview: {$issue['preview']}...\n";
        }
        echo "\n";
        $shown++;
    }
}

// ============================================
// PHASE 2: EXECUTION TEST
// ============================================

echo "{$BLUE}===========================================\n";
echo "   PHASE 2: EXECUTION TEST\n";
echo "==========================================={$RESET}\n\n";

try {
    $dsn = "mysql:host={$host};port={$port}";
    $pdo = new PDO($dsn, $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    $pdo->exec("DROP DATABASE IF EXISTS `{$database}`");
    $pdo->exec("CREATE DATABASE `{$database}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
    $pdo->exec("USE `{$database}`");
    
    echo "{$GREEN}Connected to MySQL ({$host}:{$port}){$RESET}\n";
    echo "{$GREEN}Using database: {$database}{$RESET}\n\n";
    
} catch (PDOException $e) {
    echo "{$RED}Connection failed: " . $e->getMessage() . "{$RESET}\n";
    exit(1);
}

$successCount = 0;
$errorCount = 0;
$errors = [];

foreach ($queries as $index => $query) {
    $queryNum = $index + 1;
    
    try {
        $pdo->exec($query);
        $successCount++;
        
        if ($queryNum % 50 === 0 || $queryNum === $totalQueries) {
            $percent = round(($queryNum / $totalQueries) * 100);
            echo "\rProgress: {$queryNum} / {$totalQueries} ({$percent}%) - Success: {$successCount} / Failed: {$errorCount}";
        }
        
    } catch (PDOException $e) {
        $errorCount++;
        
        $errors[] = [
            'query_num' => $queryNum,
            'table' => extractTableName($query),
            'error' => $e->getMessage(),
            'query_preview' => substr($query, 0, 500)
        ];
    }
}

echo "\n\n";

// ============================================
// FINAL SUMMARY
// ============================================

echo "{$BLUE}===========================================\n";
echo "   FINAL SUMMARY\n";
echo "==========================================={$RESET}\n\n";

$successRate = $totalQueries > 0 ? round(($successCount / $totalQueries) * 100, 1) : 0;

echo "{$GREEN}Successful: {$successCount} / {$totalQueries} ({$successRate}%){$RESET}\n";
echo "{$RED}Failed: {$errorCount} / {$totalQueries}{$RESET}\n\n";

if ($errorCount > 0) {
    echo "{$BLUE}===========================================\n";
    echo "   ERROR DETAILS\n";
    echo "==========================================={$RESET}\n\n";
    
    $showCount = min(10, count($errors));
    for ($i = 0; $i < $showCount; $i++) {
        $err = $errors[$i];
        echo "{$RED}-------------------------------------------{$RESET}\n";
        echo "{$YELLOW}Error #" . ($i + 1) . " - Query #{$err['query_num']} - Table: {$err['table']}{$RESET}\n";
        echo "Error: {$RED}{$err['error']}{$RESET}\n";
        echo "Query: " . substr($err['query_preview'], 0, 200) . "...\n\n";
    }
    
    if (count($errors) > 10) {
        echo "... and " . (count($errors) - 10) . " more errors\n\n";
    }
    
    // Save error log
    $errorLog = "errors_" . date('Y-m-d_H-i-s') . ".txt";
    $logContent = "SQL Import Errors - " . date('Y-m-d H:i:s') . "\n";
    $logContent .= "File: {$sqlFileName}\n";
    $logContent .= "Total: {$totalQueries} | Success: {$successCount} | Failed: {$errorCount}\n";
    $logContent .= str_repeat("=", 50) . "\n\n";
    
    foreach ($errors as $i => $err) {
        $logContent .= "Error #" . ($i + 1) . "\n";
        $logContent .= "Query #: {$err['query_num']}\n";
        $logContent .= "Table: {$err['table']}\n";
        $logContent .= "Error: {$err['error']}\n";
        $logContent .= "Query:\n{$err['query_preview']}\n";
        $logContent .= str_repeat("-", 50) . "\n\n";
    }
    
    file_put_contents($errorLog, $logContent);
    echo "Error log saved to: {$GREEN}{$errorLog}{$RESET}\n";
}

echo "\n";
exit($errorCount > 0 ? 1 : 0);
