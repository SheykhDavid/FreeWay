# Marzneshin CLI Commands Analysis

This document lists all available CLI commands in the Marzneshin project organized by category.

## 1. Main Installation & Management Script (`script.sh`)

The main installation and management script provides the following commands:

### Core Service Commands
- **`up`** - Start services
- **`down`** - Stop services  
- **`restart`** - Restart services
- **`status`** - Show status
- **`logs`** - Show logs

### Installation & Updates
- **`install`** - Install Marzneshin
- **`update`** - Update to latest version
- **`uninstall`** - Uninstall Marzneshin
- **`install-script`** - Install Marzneshin script

### CLI Access
- **`cli`** - Access Marzneshin command-line interface

## 2. Python CLI Interface (`marzneshin-cli.py`)

The Python CLI interface provides structured commands organized into modules:

### Admin Management (`admin` subcommand)
- **`admin list`** - Display table of admins
  - Options: `--offset`, `--limit`, `--username`
- **`admin create`** - Create a new admin
  - Options: `--username`, `--is-sudo`, `--password`
- **`admin update`** - Update existing admin (interactive)
  - Options: `--username`
- **`admin delete`** - Delete specified admin
  - Options: `--username`, `--yes/-y`
- **`admin import-from-env`** - Import sudo admin from environment variables
  - Options: `--yes/-y`

### User Management (`user` subcommand)
- **`user list`** - Display table of users
  - Options: `--offset`, `--limit`, `--username`, `--status`, `--admin`
- **`user set-owner`** - Transfer user ownership
  - Options: `--username`, `--admin`, `--yes/-y`

### Subscription Management (`subscription` subcommand)
- **`subscription get-link`** - Print user's subscription link
  - Options: `--username`
- **`subscription get-config`** - Generate subscription config
  - Options: `--username`, `--format` (v2ray/clash), `--output-file`, `--base64`

### Shell Completion (Hidden)
- **`completion show`** - Show completion for specified shell
- **`completion install`** - Install completion for specified shell

## 3. Make Commands (`makefile`)

Development and build commands:

### Application
- **`make start`** - Run database migrations and start main application

### Dashboard Development
- **`make dashboard-deps`** - Install dashboard dependencies
- **`make dashboard-build`** - Build dashboard for production
- **`make dashboard-dev`** - Start dashboard in development mode
- **`make dashboard-preview`** - Preview dashboard build
- **`make dashboard-cleanup`** - Remove dashboard node_modules

## 4. NPM Scripts (`dashboard/package.json`)

Frontend development commands:

### Development
- **`npm run dev`** - Start development server
- **`npm run preview`** - Preview production build

### Building
- **`npm run build`** - Build for production (TypeScript + Vite)
- **`npm run lint`** - Run ESLint

### Testing
- **`npm run test`** - Run tests with Vitest
- **`npm run test:ui`** - Run tests with UI
- **`npm run test:ui:coverage`** - Run tests with UI and coverage
- **`npm run test:watch`** - Run tests in watch mode
- **`npm run test:coverage`** - Run tests with coverage report

### Storybook
- **`npm run storybook`** - Start Storybook development server
- **`npm run build-storybook`** - Build Storybook
- **`npm run test-storybook`** - Test Storybook
- **`npm run chromatic`** - Run Chromatic visual testing

## Command Categories Summary

1. **System Management**: `up`, `down`, `restart`, `status`, `logs`, `install`, `update`, `uninstall`
2. **Admin Operations**: `admin list/create/update/delete/import-from-env`
3. **User Operations**: `user list/set-owner`
4. **Subscription Operations**: `subscription get-link/get-config`
5. **Development**: `dashboard-*` make targets, npm scripts for frontend
6. **Testing**: Various npm test scripts and Storybook commands

## Recommendations for Review

Consider reviewing these command aspects:
- **Naming consistency**: Some commands use dashes (`install-script`), others don't
- **Command grouping**: Whether the current module organization (admin/user/subscription) is optimal
- **Option naming**: Consistency in flag names across different commands
- **Help text**: Ensure all commands have clear, consistent help documentation