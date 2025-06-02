🌐 Infraestrutura Web com Docker Compose
Este repositório contém uma infraestrutura web básica para fins de atividade acadêmica, utilizando Docker e Docker Compose.

🎯 Componentes Principais
Servidor DNS (BIND9): Gerencia a zona asa.br.
Proxy Reverso (Nginx): Ponto de entrada HTTP/HTTPS com SSL.
Servidores Web (Nginx): web1.asa.br, web2.asa.br e uma página inicial em www.asa.br/portal.asa.br.
📂 Estrutura do Projeto
.
├── docker-compose.yml
├── setup_docker_infra.sh
├── dns/
│   ├── Dockerfile
│   ├── named.conf.local
│   ├── named.conf.options
│   └── db.asa.br
├── proxy/
│   ├── Dockerfile
│   ├── generate_certs.sh
│   └── nginx.conf
├── web1/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── index.html
├── web2/
│   ├── Dockerfile
│   ├── nginx.conf
│   └── index.html
└── web-home/
    ├── Dockerfile
    ├── nginx.conf
    └── index.html
🚀 Como Iniciar
Pré-requisitos
Docker
Docker Compose (ou docker compose)
Execução
Clone o repositório.
Execute o script de setup para configurar e iniciar a infraestrutura:
Bash

chmod +x setup_docker_infra.sh
./setup_docker_infra.sh
Este script obterá o IP do host, atualizará a configuração DNS e iniciará todos os containers.
Configuração do DNS no Host
Após o script, configure o DNS do seu sistema operacional para usar o IP da sua máquina host como servidor DNS principal. O script exibirá o IP detectado.

Exemplo Linux (/etc/resolv.conf):
nameserver <IP_DO_SEU_HOST>
🧪 Como Testar
Verifique a resolução DNS (no seu host):

Bash

dig www.asa.br
dig web1.asa.br
Acesse no Navegador:

https://www.asa.br 
https://web1.asa.br
https://web2.asa.br

Note: Você verá avisos de certificado SSL, pois são autoassinados. Prossiga para o site.

🛠️ Solução de Problemas Rápidos
Conexão Recusada: Verifique se todos os containers estão rodando (docker ps) e se as portas 53, 80 e 443 estão abertas no firewall do seu host.
Navegador não carrega: Verifique os logs dos containers (docker logs <nome_do_container>) e limpe o cache do navegador.
