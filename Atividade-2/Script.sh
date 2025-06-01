#!/bin/bash

# --- Variáveis de Configuração ---
# Caminho para o arquivo db.asa.br
DNS_DB_FILE="./dns/db.asa.br"
# O IP antigo que será substituído no db.asa.br
OLD_PLACEHOLDER_IP="192.168.1.188"
# Nome da rede externa a ser criada
EXTERNAL_NETWORK_NAME="rede-externa"

# --- Funções Auxiliares ---

# Função para verificar se o Docker está rodando e acessível
check_docker_status() {
    echo "Verificando status do Docker..."
    if ! command -v docker &> /dev/null; then
        echo "Erro: Docker não encontrado. Por favor, instale o Docker ou adicione-o ao seu PATH."
        exit 1
    fi
    if ! docker info &> /dev/null; then
        echo "Erro: Docker daemon não está rodando ou o usuário não tem permissão para acessá-lo."
        echo "Tente 'sudo systemctl start docker' ou adicione seu usuário ao grupo docker: 'sudo usermod -aG docker \$USER && newgrp docker' (e reinicie o terminal)."
        exit 1
    fi
    echo "Docker está rodando e acessível."
}

# Função para obter o IP da máquina host
get_host_ip() {
    # Tenta obter o endereço IPv4 da primeira interface de rede que não seja loopback.
    # Pode precisar ser ajustado se você tiver múltiplas interfaces e precisar de uma específica.
    # Ex: para uma interface específica como 'eth0': ip -4 addr show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1
    echo "Tentando obter o IP da máquina host..."
    HOST_IP=$(ip -4 addr show | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | grep -v '127\.0\.0\.1' | head -n 1)
    echo "$HOST_IP"
}

# --- Execução Principal do Script ---

clear # Limpa a tela do terminal

echo "=========================================="
echo "  Script de Configuração de Infraestrutura Docker"
echo "=========================================="

check_docker_status

# 1. Alterar o IP do db.asa.br
echo -e "\n--- PASSO 1: Alterando o IP em '$DNS_DB_FILE' ---"
ACTUAL_HOST_IP=$(get_host_ip)

if [ -z "$ACTUAL_HOST_IP" ]; then
    echo "Erro: Não foi possível obter o IP da máquina host automaticamente."
    echo "Por favor, verifique suas configurações de rede ou defina o IP manualmente no script."
    exit 1
fi

echo "IP da máquina host detectado: $ACTUAL_HOST_IP"

if [ -f "$DNS_DB_FILE" ]; then
    # Cria um backup do arquivo original
    cp "$DNS_DB_FILE" "${DNS_DB_FILE}.bak"
    echo "Backup de '$DNS_DB_FILE' criado em '${DNS_DB_FILE}.bak'."

    # Escapa os pontos dos IPs para o comando sed
    ESCAPED_OLD_IP=$(echo "$OLD_PLACEHOLDER_IP" | sed 's/\./\\./g')
    ESCAPED_NEW_IP=$(echo "$ACTUAL_HOST_IP" | sed 's/\./\\./g')
    
    # Usa sed para substituir todas as ocorrências do IP antigo pelo IP do host
    # A flag 'g' substitui todas as ocorrências na linha
    # A flag 'i' edita o arquivo no local (cria um backup se sed -i.bak)
    sed -i "s/$ESCAPED_OLD_IP/$ESCAPED_NEW_IP/g" "$DNS_DB_FILE"
    
    if [ $? -eq 0 ]; then
        echo "IPs atualizados em '$DNS_DB_FILE' de '$OLD_PLACEHOLDER_IP' para '$ACTUAL_HOST_IP'."
    else
        echo "Erro ao alterar o IP em '$DNS_DB_FILE'. Por favor, verifique."
        exit 1
    fi
else
    echo "Erro: Arquivo '$DNS_DB_FILE' não encontrado. Certifique-se de que a estrutura de diretórios está correta."
    exit 1
fi

# 2. Criar a rede-externa
echo -e "\n--- PASSO 2: Criando a rede Docker '$EXTERNAL_NETWORK_NAME' ---"
if docker network inspect "$EXTERNAL_NETWORK_NAME" &>/dev/null; then
    echo "Rede '$EXTERNAL_NETWORK_NAME' já existe. Ignorando a criação."
else
    docker network create "$EXTERNAL_NETWORK_NAME"
    if [ $? -eq 0 ]; then
        echo "Rede '$EXTERNAL_NETWORK_NAME' criada com sucesso."
    else
        echo "Erro ao criar a rede '$EXTERNAL_NETWORK_NAME'. Por favor, verifique as permissões ou se já existe uma rede com o mesmo nome que não é externa."
        exit 1
    fi
fi

# 3. Iniciar o docker compose
echo -e "\n--- PASSO 3: Iniciando o Docker Compose ---"
echo "Construindo imagens, recriando containers e iniciando em segundo plano..."
docker compose up --build -d --force-recreate

if [ $? -eq 0 ]; then
    echo -e "\n=========================================="
    echo "  Infraestrutura Docker iniciada com sucesso!"
    echo "=========================================="
    echo "Verifique o status dos containers com: docker ps"
    echo "Lembre-se de configurar o DNS do seu sistema host para $ACTUAL_HOST_IP para testar os domínios."
    echo "O arquivo $DNS_DB_FILE.bak contém o backup do db.asa.br original."
else
    echo -e "\nErro: O Docker Compose não conseguiu iniciar. Por favor, verifique os logs para mais detalhes."
    exit 1
fi

echo -e "\nScript concluído."