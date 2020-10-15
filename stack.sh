#!/bin/bash
##############################################
#  Playbook Ansible pour déploiement Docker  #
##############################################

source includes/functions.sh
source includes/variables.sh
clear
if [[ ! -d "$CONFDIR" ]]; then
echo -e "${CCYAN}
######################################################################################################################
#                                                                                                                    #
#     #    #     #  #####  ### ######  #       #######    #     #    ######  #######  #####  #    # ####### ######   #
#    # #   ##    # #     #  #  #     # #       #           #   #     #     # #     # #     # #   #  #       #     #  #
#   #   #  # #   # #        #  #     # #       #            # #      #     # #     # #       #  #   #       #     #  #
#  #     # #  #  #  #####   #  ######  #       #####         #       #     # #     # #       ###    #####   ######   #
#  ####### #   # #       #  #  #     # #       #            # #      #     # #     # #       #  #   #       #   #    #
#  #     # #    ## #     #  #  #     # #       #           #   #     #     # #     # #     # #   #  #       #    #   #
#  #     # #     #  #####  ### ######  ####### #######    #     #    ######  #######  #####  #    # ####### #     #  #                                                                                                                  
#                                                                                                                    #
######################################################################################################################
${CEND}"

echo ""
echo -e "${CCYAN}---------------------------------------${{CEND}"
echo -e "${CCYAN}[     INSTALLATION DES PRÉ-REQUIS     ]${{CEND}"
echo -e "${CCYAN}---------------------------------------${{CEND}"
echo ""
echo -e "\n${CGREEN}Appuyer sur ${CEND}${CCYAN}[ENTREE]${CEND}${CGREEN} pour lancer le script${CEND}"
read -r

## Constantes
readonly PIP="20.2.3"
readonly ANSIBLE="2.10.2"

## Variable d'environnement pour bloquer les dialogues de Debian
export DEBIAN_FRONTEND=noninteractive

## Désactivation de l'IPv6
if [ -f /etc/sysctl.d/99-sysctl.conf ]; then
    grep -q -F 'net.ipv6.conf.all.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || \
        echo 'net.ipv6.conf.all.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
    grep -q -F 'net.ipv6.conf.default.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || \
        echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
    grep -q -F 'net.ipv6.conf.lo.disable_ipv6 = 1' /etc/sysctl.d/99-sysctl.conf || \
        echo 'net.ipv6.conf.lo.disable_ipv6 = 1' >> /etc/sysctl.d/99-sysctl.conf
    sysctl -p
fi

## Installation des pré-dépendances
apt-get install -y --reinstall \
    software-properties-common \
    apt-transport-https \
    lsb-release
apt-get update

## Ajout des repositories apt
osname=$(lsb_release -si)

if echo $osname "Debian" &>/dev/null; then
	add-apt-repository main 2>&1 >> /dev/null
	add-apt-repository non-free 2>&1 >> /dev/null
	add-apt-repository contrib 2>&1 >> /dev/null
elif echo $osname "Ubuntu" &>/dev/null; then
	add-apt-repository main 2>&1 >> /dev/null
	add-apt-repository universe 2>&1 >> /dev/null
	add-apt-repository restricted 2>&1 >> /dev/null
	add-apt-repository multiverse 2>&1 >> /dev/null
fi
apt-get update

## Installation des dépendances apt
apt-get install -y --reinstall \
    nano \
    git \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev \
    python3-pip \
    python-dev \
    python-pip \
    python-apt

## Installation des dépendances pip3
python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall \
    pip==${PIP}
python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall \
    setuptools
python3 -m pip install --disable-pip-version-check --upgrade --force-reinstall \
    pyOpenSSL \
    requests \
    netaddr

## Installation des dépendances pip2
python -m pip install --disable-pip-version-check --upgrade --force-reinstall \
    pip==${PIP}
python -m pip install --disable-pip-version-check --upgrade --force-reinstall \
    setuptools
python -m pip install --disable-pip-version-check --upgrade --force-reinstall \
    pyOpenSSL \
    requests \
    netaddr \
    jmespath \
    ansible==${1-$ANSIBLE}

## Configuration Ansible
mkdir -p /etc/ansible/inventories/ 1>/dev/null 2>&1
echo "[local]" > /etc/ansible/inventories/local
echo "127.0.0.1 ansible_connection=local" >> /etc/ansible/inventories/local

## Référence : https://docs.ansible.com/ansible/2.4/intro_configuration.html
echo "[defaults]" > /etc/ansible/ansible.cfg
echo "command_warnings = False" >> /etc/ansible/ansible.cfg
echo "callback_whitelist = profile_tasks" >> /etc/ansible/ansible.cfg
echo "deprecation_warnings=False" >> /etc/ansible/ansible.cfg
echo "inventory = /etc/ansible/inventories/local" >> /etc/ansible/ansible.cfg
echo "interpreter_python=/usr/bin/python" >> /etc/ansible/ansible.cfg

## Copie de pip vers le dossier /usr/bin
cp /usr/local/bin/pip /usr/bin/pip
cp /usr/local/bin/pip3 /usr/bin/pip3
fi

clear
if [[ ! -d "$CONFDIR" ]]; then
echo -e "${CCYAN}INSTALLATION DE LA STACK${CEND}"
echo -e "${CGREEN}${CEND}"