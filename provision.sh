#!/bin/bash
# provision.sh - Script de provisionamento para os nós do laboratório RHCSA RHEL 10

# Variáveis
HOSTNAME=$1
PACKAGES="vim-enhanced bash-completion tree wget curl lvm2 firewalld nfs-utils tuned cockpit htop ncdu iotop nmon"
LAB_DIR="/home/vagrant/rhcsa-labs"

echo "--- Iniciando provisionamento para o nó: $HOSTNAME ---"

# 1. Configuração de Timezone e Locale
echo "Configurando Timezone e Locale..."
timedatectl set-timezone America/Sao_Paulo
localectl set-locale LANG=en_US.UTF-8

# 2. Instalação de pacotes
echo "Instalando pacotes essenciais e de exame..."
# Nota: Podman foi removido do EX200, mas é um tópico obrigatório do RHEL 10 (linha 81),
# e o usuário listou explicitamente. Vamos incluí-lo para fins de laboratório.
PACKAGES="$PACKAGES podman"
dnf install -y $PACKAGES

# 3. Configuração de serviços essenciais
echo "Habilitando e iniciando serviços essenciais..."
systemctl enable --now firewalld
systemctl enable --now tuned

# 4. Configuração de ambiente (bashrc, aliases, vimrc)
echo "Configurando ambiente de usuário (vagrant)..."
BASHRC_CUSTOM="
# Custom RHCSA Lab Aliases and Prompt
alias ll='ls -alF'
alias rhcsa-lab='cd $LAB_DIR'
alias dnf-update='sudo dnf update -y'
export PS1='\[\e[1;36m\][\u@\h \W]\$\[\e[0m\] '
"
echo "$BASHRC_CUSTOM" >> /home/vagrant/.bashrc

# Configuração básica do vim
VIMRC_CUSTOM="
set nu
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
"
echo "$VIMRC_CUSTOM" > /home/vagrant/.vimrc

# 5. Criação da estrutura de diretórios para labs
echo "Criando estrutura de diretórios para labs em $LAB_DIR..."
mkdir -p $LAB_DIR
chown vagrant:vagrant $LAB_DIR

# 6. Configuração específica do Cockpit (apenas no master)
if [ "$HOSTNAME" == "master" ]; then
    echo "Configurando Cockpit no nó master..."
    systemctl enable --now cockpit.socket
    # Permitir acesso ao Cockpit (porta 9090)
    firewall-cmd --zone=public --add-port=9090/tcp --permanent
    firewall-cmd --reload
fi

# 7. Nota sobre Registro do Sistema
echo "
================================================================================
NOTA IMPORTANTE:
O registro do sistema (subscription-manager register) não pode ser automatizado
neste script. O usuário deve realizar o registro manualmente se for necessário
acesso ao Red Hat Content Delivery Network.
================================================================================
"

echo "--- Provisionamento do nó $HOSTNAME concluído. ---"
