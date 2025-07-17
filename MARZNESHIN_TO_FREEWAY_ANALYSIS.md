# Marzneshin to FreeWay Renaming Analysis

## Overview
This analysis categorizes all occurrences of "marzneshin" in the repository to determine what can be safely renamed to "freeway" without breaking the system.

## ✅ SAFE TO RENAME (Display Names, Documentation, Comments)

### 1. Documentation and Comments
- `CLI_COMMANDS_ANALYSIS.md` - All references (documentation)
- `README.md` - Already shows "FreeWay" 
- `.github/ISSUE_TEMPLATE/bug_report.yml` - Description text
- `.github/workflows/package.yml` - Release names and descriptions
- `app/db/migrations/versions/20240115_20faa9f18c0a_init.py` - Comment
- `tools/service-install.sh` - Service description

### 2. User Interface Text
- `dashboard/index.html` - Page title
- `dashboard/.storybook/preview-head.html` - Page title 
- `dashboard/public/locales/en.json` - User-facing descriptions
- `dashboard/public/locales/ru.json` - User-facing descriptions
- `app/marzneshin.py` line 52 - API title "MarzneshinAPI"

### 3. User Messages in Scripts
- `script.sh` - All `colorized_echo` messages and user prompts
- All status messages, confirmation prompts, and help text

## ⚠️ RENAME WITH CAUTION (System Configuration)

### 1. File and Directory Names
- `marzneshin-cli.py` → Should become `freeway-cli.py`
- `app/marzneshin.py` → Should become `app/freeway.py`
- `/var/lib/marzneshin` paths in Docker configs

### 2. Docker Configuration
- `docker-compose.yml` - Service name and volume paths
- `docker-compose.dev.yml` - Service name and volume paths
- Docker image references need coordination with upstream

### 3. Script Variables and Function Names
- `script.sh` - `APP_NAME="marzneshin"` (line 3)
- All function names containing "marzneshin" in `script.sh`
- Binary installation path `/usr/local/bin/marzneshin`

### 4. Module Imports and Aliases
- `main.py` - `from app.marzneshin import main`
- `dashboard/` - All `@marzneshin/*` import aliases in TypeScript files
- Frontend module path configurations

## ❌ DO NOT RENAME (External Dependencies)

### 1. External Repository References
- `script.sh` - `FETCH_REPO="marzneshin/marzneshin"` (line 10)
- `script.sh` - GitHub URLs for downloading files
- `.github/ISSUE_TEMPLATE/` - GitHub issue links
- `dashboard/src/common/utils/project-info.ts` - GitHub links

### 2. External Docker Images
- `docker-compose.yml` - `image: dawsh/marzneshin:latest`
- Docker registry references

### 3. CLI Error Messages Referencing Commands
- `app/routes/admin.py` - References to "marzneshin-cli" in error messages

## 📋 RENAME PLAN

### Phase 1: Safe Renames (No System Impact)
1. Update all display names, titles, and user messages
2. Update documentation and comments
3. Update localization files

### Phase 2: System Configuration (Requires Testing)
1. Rename `marzneshin-cli.py` → `freeway-cli.py`
2. Rename `app/marzneshin.py` → `app/freeway.py`
3. Update import in `main.py`
4. Update Docker service names and volume paths
5. Update script variables and function names
6. Update frontend module aliases

### Phase 3: External Dependencies (Coordination Required)
1. Fork/rename external repositories
2. Build and publish new Docker images
3. Update all external references

## 🚨 CRITICAL WARNINGS

1. **External URLs**: Many references point to `github.com/marzneshin/marzneshin` - these need new repositories
2. **Docker Images**: `dawsh/marzneshin:latest` needs to be republished as new image
3. **Script Installation**: The script downloads from external URLs that won't exist after renaming
4. **Module Aliases**: Frontend has extensive `@marzneshin/*` imports that need systematic replacement

## ✅ RECOMMENDED SAFE START

Begin with Phase 1 only - rename all display text, documentation, and user messages. This will give you a "FreeWay" branded experience without breaking any functionality.

The system-critical renames (Phase 2 & 3) require:
- Comprehensive testing
- New Docker images
- New GitHub repositories
- Updated external references

## Files Requiring Manual Review

1. `script.sh` - Contains mix of safe (messages) and critical (URLs, functions) references
2. `app/routes/admin.py` - Error messages mentioning CLI command names
3. All frontend TypeScript files with `@marzneshin` imports
4. Docker compose files - service names affect container networking

## Summary

**Safe to rename immediately**: ~60% of occurrences (display text, docs, comments)
**Requires system changes**: ~30% of occurrences (filenames, imports, config)
**Requires external coordination**: ~10% of occurrences (repos, docker images)