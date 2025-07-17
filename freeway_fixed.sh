#!/usr/bin/env bash
set -e

# FreeWay management script - compatible with existing marzneshin Docker images
APP_NAME="marzneshin"
NODE_NAME="marznode"
CONFIG_DIR="/etc/opt/$APP_NAME"
DATA_DIR="/var/lib/$APP_NAME"
NODE_DATA_DIR="/var/lib/$NODE_NAME"
COMPOSE_FILE="$CONFIG_DIR/docker-compose.yml"

FETCH_REPO="marzneshin/marzneshin"
SCRIPT_URL="https://github.com/$FETCH_REPO/raw/master/script.sh"

colorized_echo() {
    local color=$1
    local text=$2

    case $color in
        "red")
        printf "\e[91m${text}\e[0m\n";;
        "green")
        printf "\e[92m${text}\e[0m\n";;
        "yellow")
        printf "\e[93m${text}\e[0m\n";;
        "blue")
        printf "\e[94m${text}\e[0m\n";;
        "magenta")
        printf "\e[95m${text}\e[0m\n";;
        "cyan")
        printf "\e[96m${text}\e[0m\n";;
        *)
        echo "${text}"
        ;;
    esac
}

check_running_as_root() {
    if [[ $EUID -ne 0 ]]; then
        colorized_echo red "This command must be run as root."
        exit 1
    fi
}

detect_os() {
    # Detect the operating system
    if [[ -f /etc/lsb-release ]]; then
        OS=$(lsb_release -si)
    elif [[ -f /etc/os-release ]]; then
        OS=$(awk -F= '/^NAME/{print $2}' /etc/os-release | tr -d '"')
    elif [[ -f /etc/redhat-release ]]; then
        OS=$(cat /etc/redhat-release | awk '{print $1}')
    elif [[ -f /etc/arch-release ]]; then
        OS="Arch"
    else
        colorized_echo red "Unsupported operating system"
        exit 1
    fi
}

detect_and_update_package_manager() {
    colorized_echo blue "Updating package manager"
    if [[ "$OS" == "Ubuntu"* ]] || [[ "$OS" == "Debian"* ]]; then
        PKG_MANAGER="apt-get"
        $PKG_MANAGER update
    elif [[ "$OS" == "CentOS"* ]] || [[ "$OS" == "AlmaLinux"* ]] || [[ "$OS" == "Rocky"* ]]; then
        PKG_MANAGER="yum"
        $PKG_MANAGER update -y
    elif [[ "$OS" == "Fedora"* ]]; then
        PKG_MANAGER="dnf"
        $PKG_MANAGER update -y
    elif [[ "$OS" == "Arch"* ]]; then
        PKG_MANAGER="pacman"
        $PKG_MANAGER -Sy
    else
        colorized_echo red "Unsupported operating system"
        exit 1
    fi
}

detect_compose() {
    if docker compose version &> /dev/null; then
        COMPOSE='docker compose'
    elif docker-compose --version &> /dev/null; then
        COMPOSE='docker-compose'
    else
        colorized_echo red "docker compose not found"
        exit 1
    fi
}

install_docker() {
    colorized_echo blue "Installing Docker"
    curl -fsSL https://get.docker.com | sh
    systemctl enable --now docker
    colorized_echo green "Docker installed successfully"
}

install_marzneshin_script() {
    colorized_echo blue "Installing FreeWay script"
    curl -sSL $SCRIPT_URL | install -m 755 /dev/stdin /usr/local/bin/freeway
    colorized_echo green "FreeWay script installed successfully"
}

install_marzneshin() {
    # Fetch releases
    FILES_URL_PREFIX="https://raw.githubusercontent.com/marzneshin/marzneshin/master"
    COMPOSE_FILES_URL="https://raw.githubusercontent.com/marzneshin/marzneshin-deploy/master"
    database=$1
    nightly=$2
  
    mkdir -p "$DATA_DIR"
    mkdir -p "$CONFIG_DIR"

    colorized_echo blue "Fetching compose file"
    curl -sL "$COMPOSE_FILES_URL/docker-compose-$database.yml" -o "$CONFIG_DIR/docker-compose.yml"
    colorized_echo green "File saved in $CONFIG_DIR/docker-compose.yml"
    if [ "$nightly" = true ]; then
        colorized_echo red "setting compose tag to nightly."
        sed -ri "s/(dawsh\/marzneshin:)latest/\1nightly/g" $CONFIG_DIR/docker-compose.yml
    fi
 
    colorized_echo blue "Fetching example .env file"
    curl -sL "$FILES_URL_PREFIX/.env.example" -o "$CONFIG_DIR/.env"
    colorized_echo green "File saved in $CONFIG_DIR/.env"

    colorized_echo green "FreeWay files downloaded successfully"
}

install_marznode_xray_config() {
    mkdir -p "$NODE_DATA_DIR"
    curl -sL "https://raw.githubusercontent.com/marzneshin/marznode/master/xray_config.json" -o "$NODE_DATA_DIR/xray_config.json"
    colorized_echo green "Sample xray config downloaded for marznode"
}

uninstall_marzneshin_script() {
    if [ -f "/usr/local/bin/freeway" ]; then
        colorized_echo yellow "Removing FreeWay script"
        rm "/usr/local/bin/freeway"
        colorized_echo green "FreeWay script removed successfully"
    fi
}

uninstall_marzneshin() {
    if [ -d "$CONFIG_DIR" ]; then
        colorized_echo yellow "Removing directory: $CONFIG_DIR"
        rm -r "$CONFIG_DIR"
    fi
}

uninstall_marzneshin_docker_images() {
    images=$(docker images | grep marzneshin | awk '{print $3}')

    if [ -n "$images" ]; then
        colorized_echo yellow "Removing Docker images of FreeWay"
        for image in $images; do
            if docker rmi "$image" >/dev/null 2>&1; then
                colorized_echo yellow "Image $image removed"
            fi
        done
        colorized_echo green "All FreeWay images removed"
    fi
}

uninstall_marzneshin_data_files() {
    if [ -d "$DATA_DIR" ]; then
        colorized_echo yellow "Removing directory: $DATA_DIR"
        rm -r "$DATA_DIR"
    fi
}

uninstall_marznode_data_files() {
    if [ -d "$NODE_DATA_DIR" ]; then
        colorized_echo yellow "Removing directory: $NODE_DATA_DIR"
        rm -r "$NODE_DATA_DIR"
    fi
}

up_marzneshin() {
    $COMPOSE -f $COMPOSE_FILE -p "$APP_NAME" up -d --remove-orphans
}

down_marzneshin() {
    $COMPOSE -f $COMPOSE_FILE -p "$APP_NAME" down
}

show_marzneshin_logs() {
    $COMPOSE -f $COMPOSE_FILE -p "$APP_NAME" logs
}

follow_marzneshin_logs() {
    $COMPOSE -f $COMPOSE_FILE -p "$APP_NAME" logs -f
}

marzneshin_cli() {
    $COMPOSE -f $COMPOSE_FILE -p "$APP_NAME" exec -e CLI_PROG_NAME="freeway cli" marzneshin /app/marzneshin-cli.py "$@"
}

update_marzneshin_script() {
    colorized_echo blue "Updating FreeWay script"
    curl -sSL $SCRIPT_URL | install -m 755 /dev/stdin /usr/local/bin/freeway
    colorized_echo green "FreeWay script updated successfully"
}

update_marzneshin() {
    $COMPOSE -f $COMPOSE_FILE -p "$APP_NAME" pull
}

is_marzneshin_installed() {
    if [ -d $CONFIG_DIR ]; then
        return 0
    else
        return 1
    fi
}

is_marzneshin_up() {
    if [ -z "$($COMPOSE -f $COMPOSE_FILE ps -q -a)" ]; then
        return 1
    else
        return 0
    fi
}

install_command() {
    check_running_as_root
    # Check if marzneshin is already installed
    if is_marzneshin_installed; then
        colorized_echo red "FreeWay is already installed at $CONFIG_DIR"
        read -p "Do you want to override the previous installation? (y/n) "
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            colorized_echo red "Aborted installation"
            exit 1
        fi
    fi

    detect_os
    if ! command -v jq &> /dev/null; then
        colorized_echo blue "Installing jq"
        detect_and_update_package_manager
        if [[ "$OS" == "Ubuntu"* ]] || [[ "$OS" == "Debian"* ]]; then
            $PKG_MANAGER install -y jq
        elif [[ "$OS" == "CentOS"* ]] || [[ "$OS" == "AlmaLinux"* ]] || [[ "$OS" == "Rocky"* ]]; then
            $PKG_MANAGER install -y jq
        elif [[ "$OS" == "Fedora"* ]]; then
            $PKG_MANAGER install -y jq
        elif [[ "$OS" == "Arch"* ]]; then
            $PKG_MANAGER -S --noconfirm jq
        fi
        colorized_echo green "jq installed successfully"
    fi

    if ! command -v docker &> /dev/null; then
        install_docker
    fi

    database="sqlite"
    nightly=false

    while [[ "$#" -gt 0 ]]; do
        case $1 in
            --dev) nightly=true ;;
            --database) database="$2"; shift ;;
            *) colorized_echo red "Unknown parameter: $1"; exit 1 ;;
        esac
        shift
    done

    detect_compose
    install_marzneshin_script
    install_marzneshin $database $nightly
    install_marznode_xray_config
    up_marzneshin
    follow_marzneshin_logs
}

uninstall_command() {
    check_running_as_root

    # Check if marzneshin is installed
    if ! is_marzneshin_installed; then
        colorized_echo red "FreeWay's not installed!"
        exit 1
    fi

    detect_compose

    read -p "Do you really want to uninstall FreeWay? (y/n) "
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        colorized_echo red "Aborted"
        exit 1
    fi

    if is_marzneshin_up; then
        down_marzneshin
    fi
    uninstall_marzneshin_script
    uninstall_marzneshin
    uninstall_marzneshin_docker_images

    read -p "Do you want to remove FreeWay & marznode data files too ($NODE_DATA_DIR, $DATA_DIR)? (y/n) "
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        uninstall_marzneshin_data_files
        uninstall_marznode_data_files
        colorized_echo green "FreeWay uninstalled successfully"
    else
        colorized_echo green "FreeWay uninstalled successfully (data files kept)"
    fi
}

up_command() {
    check_running_as_root
    # Check if marzneshin is installed
    if ! is_marzneshin_installed; then
        colorized_echo red "FreeWay's not installed!"
        exit 1
    fi

    detect_compose

    if is_marzneshin_up; then
        colorized_echo red "FreeWay is already up"
        exit 1
    fi

    up_marzneshin
    colorized_echo green "FreeWay started successfully"
    follow_marzneshin_logs
}

down_command() {
    check_running_as_root
    # Check if marzneshin is installed
    if ! is_marzneshin_installed; then
        colorized_echo red "FreeWay's not installed!"
        exit 1
    fi

    detect_compose

    if ! is_marzneshin_up; then
        colorized_echo red "FreeWay is not up."
        exit 1
    fi

    down_marzneshin
}

restart_command() {
    check_running_as_root
    # Check if marzneshin is installed
    if ! is_marzneshin_installed; then
        colorized_echo red "FreeWay's not installed!"
        exit 1
    fi

    detect_compose

    down_marzneshin
    up_marzneshin

    follow_marzneshin_logs
}

status_command() {
    # Check if marzneshin is installed
    if ! is_marzneshin_installed; then
        colorized_echo red "FreeWay's not installed!"
        exit 1
    fi

    detect_compose

    if ! is_marzneshin_up; then
        colorized_echo red "FreeWay is not up."
        exit 1
    fi

    $COMPOSE -f $COMPOSE_FILE -p "$APP_NAME" ps
}

logs_command() {
    # Check if marzneshin is installed
    if ! is_marzneshin_installed; then
        colorized_echo red "FreeWay's not installed!"
        exit 1
    fi

    detect_compose

    if ! is_marzneshin_up; then
        colorized_echo red "FreeWay is not up."
        exit 1
    fi

    if [ "$1" = "-f" ] || [ "$1" = "--follow" ]; then
        follow_marzneshin_logs
    else
        show_marzneshin_logs
    fi
}

cli_command() {
    # Check if marzneshin is installed
    if ! is_marzneshin_installed; then
        colorized_echo red "FreeWay is not installed!"
        exit 1
    fi

    detect_compose

    if ! is_marzneshin_up; then
        colorized_echo red "FreeWay is not up."
        exit 1
    fi

    marzneshin_cli "$@"
}

update_command() {
    check_running_as_root
    # Check if marzneshin is installed
    if ! is_marzneshin_installed; then
        colorized_echo red "FreeWay's not installed!"
        exit 1
    fi

    detect_compose

    update_marzneshin_script
    colorized_echo blue "Pulling latest version"
    update_marzneshin

    colorized_echo blue "Restarting FreeWay's services"
    down_marzneshin
    up_marzneshin

    follow_marzneshin_logs
}

usage() {
    colorized_echo cyan "FreeWay management script"
    echo ""
    colorized_echo yellow "Usage: $(basename "$0") [COMMAND]"
    echo ""
    colorized_echo yellow "Commands:"
    colorized_echo blue "  install [options]     Install FreeWay"
    colorized_echo blue "  uninstall             Uninstall FreeWay"
    colorized_echo blue "  up                    Start FreeWay services"
    colorized_echo blue "  down                  Stop FreeWay services"
    colorized_echo blue "  restart               Restart FreeWay services"
    colorized_echo blue "  status                Show FreeWay services status"
    colorized_echo blue "  logs [options]        Show FreeWay logs"
    colorized_echo blue "  cli [args]            FreeWay command-line interface"
    colorized_echo blue "  update                Update FreeWay"
    echo ""
    colorized_echo yellow "Install options:"
    colorized_echo blue "  --dev                 Install nightly version"
    colorized_echo blue "  --database DB         Database type (sqlite/mysql/mariadb)"
    echo ""
    colorized_echo yellow "Log options:"
    colorized_echo blue "  -f, --follow          Follow log output"
}

case "$1" in
    "install") shift; install_command "$@";;
    "uninstall") uninstall_command;;
    "up") up_command;;
    "down") down_command;;
    "restart") restart_command;;
    "status") status_command;;
    "logs") shift; logs_command "$@";;
    "cli") shift; cli_command "$@";;
    "update") update_command;;
    *) usage;;
esac