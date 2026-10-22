# CMAP 1815: Introduction to Modern SQL — Student Lab Sandbox

Welcome to the hands-on student repository for **CMAP 1815: Introduction to Modern SQL**. This sandbox is pre-configured with a live **PostgreSQL 16** server and interactive development tools so you can run queries, complete labs, and explore datasets directly in your web browser.

---

## 🚀 1-Click Quick Start (GitHub Codespaces)

Click the button below to launch your personal, cloud-hosted SQL development environment:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/tswarmLCCC/CMAP-1815-Student-Sandbox?quickstart=1)

*Wait ~90 seconds for your container to spin up. Once the terminal displays `>>> CMAP 1815 Sandbox Ready!`, your database is live and pre-seeded!*

---

## 🛠️ Two Ways to Query PostgreSQL

### Option A: The Visual GUI (SQLTools Sidebar)
1. Click the **Database (plug/server) icon** in the left sidebar of VS Code.
2. Under **CONNECTIONS**, click **CMAP 1815 Local PostgreSQL** $ightarrow$ **Connect**.
3. Expand **cmap1815** $ightarrow$ **public** $ightarrow$ **Tables** to see your live tables (`employees`, `orders`, `products`, `locations`).
4. Click any table name to inspect columns and click **Show Table Records** to view data in a spreadsheet grid!

### Option B: The Terminal CLI (`psql`)
1. Open a terminal in VS Code (`Ctrl + ~` or `Cmd + ~`).
2. Type:
   ```bash
   psql
   ```
3. Run a query:
   ```sql
   SELECT * FROM employees LIMIT 5;
   ```
4. Type `\q` to exit the SQL prompt.

---

## 🔄 Disaster Recovery: Screwed up your data?
If you make a destructive mistake during DML (Unit 5) or Schema Design (Unit 7) experiments (like accidentally deleting records or dropping a table), you can restore your database to pristine condition anytime:
```bash
./reset_database.sh
```
*Note: This re-runs the initial seed script. It does NOT touch or delete your `.sql` lab query files in `units/`.*

---

## 📁 Repository Structure

```
.
├── .devcontainer/             # Automated PostgreSQL 16 server configuration
├── .vscode/                   # Pre-configured SQLTools database connection
├── datasets/                  # Core seed scripts (setup_chap1.sql)
├── reset_database.sh          # 1-click database recovery script
└── units/                     # Weekly Guided Learning & Lab Challenges
    ├── unit_01_selection_and_fundamentals/
    ├── unit_02_filtering_and_logic/
    ├── unit_03_joins_and_relations/
    ├── unit_04_aggregation_and_pivoting/
    ├── unit_05_safe_dml_and_modifications/
    ├── unit_06_subqueries_and_window_functions/
    ├── unit_07_schema_design_and_integrity/
    └── unit_08_performance_indexing_and_capstone/
```

Inside each unit folder, you will find:
* `lab_guide.md`: Detailed business scenario, challenge questions, and grading criteria.
* `lab_rubric.md`: The 100-point grading rubric used in Canvas SpeedGrader.
* `inclass_challenges.sql`: Guided exercises for our synchronous class sessions.
* `study_guide.md`: Asynchronous prep, readings, and focus questions.
* `self_check_drills.md`: Quick self-assessment questions before attending class.
* `lab_starter.sql`: Clean starter template for writing and saving your solutions.

---

## 📝 How to Complete and Submit Weekly Labs

1. Open the unit folder for the current week (e.g. `units/unit_01_selection_and_fundamentals/`).
2. Review the prompts in `lab_guide.md`.
3. Open `lab_starter.sql` and write your SQL queries under each challenge section.
4. **Test your code:** Run every query in PostgreSQL to confirm zero syntax errors.
5. Save a copy of your completed file as `lab{N}_{yourlastname}.sql` (e.g., `lab1_smith.sql`).
6. Upload your `.sql` file to the corresponding **Lab Assignment in Canvas**.
