#!/bin/bash
set -e

echo "======================================================================"
echo "  CMAP 1815: Resetting Database to Clean Starter State..."
echo "======================================================================"

echo ">>> Dropping existing tables and rebuilding schema..."
if [ -f "datasets/setup_chap1.sql" ]; then
    PGPASSWORD=password123 psql -h localhost -U postgres -d cmap1815 -f datasets/setup_chap1.sql
    echo ""
    echo "✅ SUCCESS! Database has been reset to clean starter state."
    echo "   All clean tables (locations, employees, products, orders, order_lines) are ready."
    echo "   Your .sql query files in the units/ folders were NOT touched."
else
    echo "❌ Error: datasets/setup_chap1.sql not found!"
    exit 1
fi
