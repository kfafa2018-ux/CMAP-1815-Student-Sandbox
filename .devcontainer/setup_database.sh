#!/bin/bash
set -e

echo ">>> Configuring Git directory trust..."
git config --global --add safe.directory '*'

echo ">>> Waiting for PostgreSQL 16 database to accept connections..."
until PGPASSWORD=password123 psql -h localhost -U postgres -d cmap1815 -c '\q' 2>/dev/null; do
    sleep 1
done

echo ">>> Seeding starter dataset (setup_chap1.sql)..."
if [ -f "datasets/setup_chap1.sql" ]; then
    PGPASSWORD=password123 psql -h localhost -U postgres -d cmap1815 -f datasets/setup_chap1.sql
    echo ">>> Database seeded successfully: locations, employees, products, orders, order_lines."
fi

echo "======================================================================"
echo "  CMAP 1815: Modern SQL Student Sandbox Ready!"
echo "  • Terminal: type 'psql' to open the interactive SQL shell."
echo "  • Visual GUI: click Database Client or SQLTools on the left sidebar."
echo "======================================================================"
