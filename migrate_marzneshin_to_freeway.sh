#!/usr/bin/env bash
set -e

# Migration script from Marzneshin to FreeWay
# This script helps migrate existing marzneshin installations to freeway

OLD_CONFIG_DIR="/etc/opt/marzneshin"
OLD_DATA_DIR="/var/lib/marzneshin"
NEW_CONFIG_DIR="/etc/opt/freeway"
NEW_DATA_DIR="/var/lib/freeway"

colorized_echo() {
    local color=$1
    local text=$2
    case $color in
        "red") printf "\e[91m${text}\e[0m\n";;
        "green") printf "\e[92m${text}\e[0m\n";;
        "yellow") printf "\e[93m${text}\e[0m\n";;
        "blue") printf "\e[94m${text}\e[0m\n";;
        "magenta") printf "\e[95m${text}\e[0m\n";;
        "cyan") printf "\e[96m${text}\e[0m\n";;
        *) echo "${text}";;
    esac
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        colorized_echo red "This script must be run as root"
        exit 1
    fi
}

backup_marzneshin() {
    if [ -d "$OLD_DATA_DIR" ]; then
        colorized_echo blue "Creating backup of marzneshin data..."
        mkdir -p "/tmp/marzneshin_backup_$(date +%Y%m%d_%H%M%S)"
        cp -r "$OLD_DATA_DIR" "/tmp/marzneshin_backup_$(date +%Y%m%d_%H%M%S)/"
        colorized_echo green "Backup created in /tmp/marzneshin_backup_$(date +%Y%m%d_%H%M%S)/"
    fi
}

migrate_configuration() {
    if [ -d "$OLD_CONFIG_DIR" ]; then
        colorized_echo blue "Migrating configuration from $OLD_CONFIG_DIR to $NEW_CONFIG_DIR..."
        
        # Create new config directory
        mkdir -p "$NEW_CONFIG_DIR"
        
        # Copy configuration files
        if [ -f "$OLD_CONFIG_DIR/.env" ]; then
            cp "$OLD_CONFIG_DIR/.env" "$NEW_CONFIG_DIR/.env"
            # Update paths in .env file
            sed -i 's|/var/lib/marzneshin|/var/lib/freeway|g' "$NEW_CONFIG_DIR/.env"
            sed -i 's|marzneshin\.socket|freeway.socket|g' "$NEW_CONFIG_DIR/.env"
            colorized_echo green "Environment file migrated and updated"
        fi
        
        # Copy docker-compose.yml and update it
        if [ -f "$OLD_CONFIG_DIR/docker-compose.yml" ]; then
            cp "$OLD_CONFIG_DIR/docker-compose.yml" "$NEW_CONFIG_DIR/docker-compose.yml"
            # Update service names and volume paths
            sed -i 's/marzneshin:/freeway:/' "$NEW_CONFIG_DIR/docker-compose.yml"
            sed -i 's|/var/lib/marzneshin|/var/lib/freeway|g' "$NEW_CONFIG_DIR/docker-compose.yml"
            colorized_echo green "Docker compose file migrated and updated"
        fi
        
        colorized_echo green "Configuration migration completed"
    else
        colorized_echo yellow "No marzneshin configuration found at $OLD_CONFIG_DIR"
    fi
}

migrate_data() {
    if [ -d "$OLD_DATA_DIR" ]; then
        colorized_echo blue "Migrating data from $OLD_DATA_DIR to $NEW_DATA_DIR..."
        
        # Create new data directory
        mkdir -p "$NEW_DATA_DIR"
        
        # Copy all data
        cp -r "$OLD_DATA_DIR"/* "$NEW_DATA_DIR"/ 2>/dev/null || true
        
        # Set proper permissions
        chown -R root:root "$NEW_DATA_DIR"
        
        colorized_echo green "Data migration completed"
    else
        colorized_echo yellow "No marzneshin data found at $OLD_DATA_DIR"
    fi
}

update_freeway_script() {
    colorized_echo blue "Installing/updating freeway script..."
    # Download the latest freeway script
    curl -sSL https://raw.githubusercontent.com/SheykhDavid/FreeWay/master/script.sh | install -m 755 /dev/stdin /usr/local/bin/freeway
    colorized_echo green "FreeWay script installed successfully"
}

main() {
    colorized_echo cyan "=== Marzneshin to FreeWay Migration Tool ==="
    colorized_echo cyan "This tool will migrate your existing marzneshin installation to freeway"
    echo
    
    check_root
    
    # Check if marzneshin exists
    if [ ! -d "$OLD_CONFIG_DIR" ] && [ ! -d "$OLD_DATA_DIR" ]; then
        colorized_echo red "No marzneshin installation found!"
        colorized_echo yellow "If you want a fresh FreeWay installation, run: freeway install"
        exit 1
    fi
    
    # Check if freeway already exists
    if [ -d "$NEW_CONFIG_DIR" ] || [ -d "$NEW_DATA_DIR" ]; then
        colorized_echo red "FreeWay installation already exists!"
        colorized_echo yellow "Please remove $NEW_CONFIG_DIR and $NEW_DATA_DIR first, or run 'freeway uninstall'"
        exit 1
    fi
    
    colorized_echo yellow "WARNING: This will:"
    colorized_echo yellow "1. Create backup of your marzneshin data"
    colorized_echo yellow "2. Copy configuration and data to freeway directories"
    colorized_echo yellow "3. Update paths and service names"
    colorized_echo yellow "4. Install freeway management script"
    echo
    
    read -p "Do you want to continue? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        colorized_echo red "Migration cancelled"
        exit 1
    fi
    
    backup_marzneshin
    migrate_configuration
    migrate_data
    update_freeway_script
    
    colorized_echo green "=== Migration Completed Successfully! ==="
    colorized_echo green "Your marzneshin installation has been migrated to freeway"
    echo
    colorized_echo cyan "Next steps:"
    colorized_echo cyan "1. Check your service: freeway status"
    colorized_echo cyan "2. Start FreeWay: freeway up"
    colorized_echo cyan "3. View logs: freeway logs"
    colorized_echo cyan "4. Use CLI: freeway cli admin create"
    echo
    colorized_echo yellow "Note: Your old marzneshin files are still in $OLD_CONFIG_DIR and $OLD_DATA_DIR"
    colorized_echo yellow "You can remove them after confirming everything works: rm -rf $OLD_CONFIG_DIR $OLD_DATA_DIR"
}

main "$@"