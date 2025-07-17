<h1 align="center"/>FreeWay</h1>

<p align="center">
    A Scalable and Comprehensive Proxy Engine management panel.
</p>

<br/>
<p align="center">
    <a href="https://github.com/freeway-project/freeway/actions/workflows/dashboard-ci.yml">
        <img src="https://github.com/freeway-project/freeway/actions/workflows/dashboard-ci.yml/badge.svg" />
    </a>
    <a href="https://github.com/freeway-project/freeway/actions/workflows/package.yml" target="_blank">
        <img src="https://github.com/freeway-project/freeway/actions/workflows/package.yml/badge.svg" />
    </a>
    <a href="https://hub.docker.com/r/freeway/freeway" target="_blank">
        <img src="https://img.shields.io/docker/pulls/freeway/freeway?style=flat-square&logo=docker" />
    </a>
    <br>
    <a href="#">
        <img src="https://img.shields.io/github/license/freeway-project/freeway?style=flat-square" />
    </a>
    <a href="https://t.me/freeway_proxy" target="_blank">
        <img src="https://img.shields.io/badge/telegram-group-blue?style=flat-square&logo=telegram" />
    </a>
    <a href="#">
        <img src="https://img.shields.io/badge/twitter-commiunity-blue?style=flat-square&logo=twitter" />
    </a>
    <a href="#">
        <img src="https://img.shields.io/github/stars/freeway-project/freeway?style=social" />
    </a>
</p>

<p align="center">
  <a href="https://github.com/freeway-project/freeway" target="_blank" rel="noopener noreferrer" >
    <img src="https://github.com/freeway-project/freeway/raw/master/docs/assets/Desktop-full.png" alt="screenshots" width="600" height="auto">
  </a>
</p>

## Table of Contents

- [Overview](#overview)
  - [Features](#features)
  - [Supported Languages](#supported-languages)
- [Installation](#installation)
  - [Quick Install (Recommended)](#quick-install-recommended)
  - [Docker Installation](#docker-installation)
  - [Manual Installation](#manual-installation)
- [Usage](#usage)
  - [Starting the Application](#starting-the-application)
  - [Accessing the Dashboard](#accessing-the-dashboard)
- [Configuration](#configuration)
- [FreeNode](#freenode)
- [Contributing](#contributing)
- [Donation](#donation)
- [License](#license)
- [Contributors](#contributors)

# Overview

FreeWay is a censorship circumvention tool utilizing other censorship circumvention tools.

FreeWay controls the proxy nodes connected to it; monitoring/disabling/enabling users on node instances while nodes manage and interact with VPN backends (such as xray).

### Features

- **Web UI** Dashboard
- **Multi Nodes** support for traffic distribution, scalability, and fault tolerance
- Supports protocols **Vmess**, **VLESS**, **Trojan** and **Shadowsocks** as provided by xray
- **Multi-protocol** for a single user
- Manage users' access to inbounds separately using **services**
- **Multi-user** on a single inbound
- Limit users' data and set expire dates
- Reset traffic periodically (daily, weekly,...)
- **Subscription link** compatible with **V2ray** (e.g. V2RayNG, OneClick, Nekoray, etc.), **Clash** and **ClashMeta**
- Automated **Share link** and **QRcode** generator
- System, nodes, traffic statistics, users monitoring
- Integrated **Command Line Interface (CLI)**
- **Multi-admin** support
- FreeWay is decoupled from VPN backends
- Resilient and fault tolerant node management

**Deployment and Developer Kit:**

- REST-full API
- Kubernetes and multiple deployment strategy and options
- Docker support for easy deployment

### Supported Languages

- Russian
- English
- Kurdish (Soranî, Kurmancî)
- Persian

# Installation

## Quick Install (Recommended)

The easiest way to install FreeWay is using our installation script:

```bash
sudo bash -c "$(curl -sL https://github.com/SheykhDavid/FreeWay/raw/master/script.sh)" @ install
```

This script will:
- Install Docker and Docker Compose if not already installed
- Download and configure FreeWay
- Set up the database
- Start all services

## Docker Installation

### Prerequisites

- Docker
- Docker Compose

### Installation Steps

1. **Clone the repository:**
```bash
git clone https://github.com/freeway-project/freeway.git
cd freeway
```

2. **Create environment file:**
```bash
cp .env.example .env
```

3. **Edit the environment file:**
```bash
nano .env
```

Configure your settings including:
- Database credentials
- JWT secret key
- Admin credentials
- Other configuration options

4. **Start services:**
```bash
docker-compose up -d
```

## Manual Installation

### Prerequisites

- Python 3.8+
- Node.js 16+ (for dashboard)
- pnpm (for dashboard dependencies)
- A database (SQLite/MySQL/PostgreSQL)

### Installation Steps

1. **Clone the repository:**
```bash
git clone https://github.com/freeway-project/freeway.git
cd freeway
```

2. **Install Python dependencies:**
```bash
pip install -r requirements.txt
```

3. **Install dashboard dependencies:**
```bash
make dashboard-deps
```

4. **Build the dashboard:**
```bash
make dashboard-build
```

5. **Set up the database:**
```bash
alembic upgrade head
```

6. **Configure the application:**
Create a `.env` file with your configuration or use environment variables.

# Usage

## Starting the Application

### Using Docker:
```bash
docker-compose up -d
```

### Using Make (Manual Installation):
```bash
make start
```

### Using Python directly:
```bash
python main.py
```

## Accessing the Dashboard

Once FreeWay is running, you can access the web dashboard at:
- **Default URL:** `http://localhost:8000`
- **Admin Panel:** `http://localhost:8000/dashboard`

### Default Credentials
- **Username:** admin
- **Password:** admin

⚠️ **Important:** Change the default credentials immediately after first login.

# Configuration

FreeWay can be configured using environment variables or a `.env` file. Key configuration options include:

- `DATABASE_URL`: Database connection string
- `SQLALCHEMY_DATABASE_URL`: SQLAlchemy database URL
- `UVICORN_HOST`: Host to bind the server (default: 0.0.0.0)
- `UVICORN_PORT`: Port to bind the server (default: 8000)
- `JWT_ACCESS_TOKEN_EXPIRE_MINUTES`: Access token expiration time
- `DOCS`: Enable/disable API documentation
- `DEBUG`: Enable debug mode

For a complete list of configuration options, refer to the `.env.example` file.

# FreeNode

[FreeNode](https://github.com/freeway-project/freenode) is the backend component needed to run proxy servers and manage VPN connections.

# Contributing

We ❤️‍🔥 contributors! If you'd like to contribute, please check out our [Contributing Guidelines](https://docs.freeway-project.org/docs/contribution-guideline) and feel free to submit a pull request or open an issue. We also welcome you to join our [Telegram](https://t.me/freeway_proxy) group for either support or contributing guidance.

Check [open issues](https://github.com/freeway-project/freeway/issues) to help the progress of this project.

## Development

### Running in Development Mode

1. **Start the backend:**
```bash
python main.py
```

2. **Start the dashboard in development mode:**
```bash
make dashboard-dev
```

### Running Tests

```bash
python -m pytest tests/
```

# Donation

If you found FreeWay useful and would like to support its development, you can make a donation in one of the following crypto networks:

- Bitcoin network: 13ZDhE5KHGsfjM4A22eLTUgW98WpXhQTuF
- TRON network (TRC20): TYxFCiRqJ3SiV6rAQAmJUd3DgVmJvEAfz4
- TON network: EQB_VYiU73U1_wk-01I_MLg9-hx953VOf9Y36t2Z04WyUapD

Part of the donations would be tipped to contributors, the rest to collaborators.

May developers be rich.

# License

Published under [AGPL-3.0](./LICENSE).

# Contributors

<p align="center">
Thanks to all contributors who have helped FreeWay:
</p>
<p align="center">
<a href="https://github.com/freeway-project/freeway/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=freeway-project/freeway" />
</a>
</p>
<p align="center">
  Made with <a rel="noopener noreferrer" target="_blank" href="https://contrib.rocks">contrib.rocks</a>
</p>
