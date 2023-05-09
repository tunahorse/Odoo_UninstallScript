# Odoo Removal Script

This Bash script completely removes the Odoo ERP system and its associated components, including the PostgreSQL database, from a Linux-based system. The script will display a warning message and ask the user to confirm before proceeding. If the user agrees, it will execute each step with a green-colored description.

Inspired by [uninstall script #67](https://github.com/Yenthe666/InstallScript/issues/67)

## Usage

1. Save the content of the script provided in the 'remove_odoo.sh' file.
2. Ensure the script has the proper execution permissions by running the following command:


```bash
chmod +x remove_odoo.sh
```



3. Run the script using the following command:
```bash
./remove_odoo.sh
```



The script will display a warning message and prompt you to confirm the action. Type 'y' or 'yes' (case-insensitive) to proceed with the removal process. Type 'n' or 'no', or simply press Enter to cancel the process.

WARNING: This script will delete services, databases, logs, and more. Ensure you have proper backups before proceeding.
