#  Atividade 2 - ASA 

**Microserviço HTTP com Docker Compose**

![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)
![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white)

Este projeto implementa uma infraestrutura web completa utilizando Docker Compose, simulando um ambiente real com um servidor DNS (BIND9) gerenciando a zona asa.br, um proxy reverso Nginx com SSL, e múltiplos servidores web (Web1 e Web2) que servem conteúdo personalizado e são roteados pelo proxy.

---

# 📂 Estrutura do Projeto

```plaintext
├── docker-compose.yml
├── dns/
│   ├── db.asa.br
│   ├── Dockerfile
│   └── named.conf.local
├── proxy/
│   ├── certs
│   │   ├── cert.pem
│   │   └── privkey.pem
│   ├── default.conf
│   └── Dockerfile
├── web1/
│   ├── Dockerfile
│   └── index.html
└── web2/
    ├── Dockerfile
    └── index.html
```

# 🛠️ Serviços Implementados


###  DNS (BIND9)

  ```plaintext
  Zona: asa.br
  Portas: 53 (TCP/UDP)
  ```

### Proxy Reverso (Nginx) 
  
  ```plaintext
  Portas: 80 (HTTP), 443 (HTTPS)
  Certificado SSL Autoassinado
  Redirecionamento HTTP para HTTPS
  ```

### Servidor Web

  ```plaintext
  2 Servidores Web com paginas personalizadas 
  ```

# Como implementar

## 1. Criar um rede externa para ser utilizada para acessar o container utilizando o comando:
  ```bash
  docker network create <nome_da_network>
  ```
No nosso caso, a rede "rede-externa" foi criada e utilizada pelo nosso proxy.

## 2. Configuração de servidor DNS padrão
Para que nosso navegar consiga resolver o nome dos nossos servidores web, precisamos alterar qual o servidor DNS padrão que o host está a utilizar. Esse processo varia de acordo com o sistema operacional, aqui estão algun deles:

### Windows

### Debian (Linux)
1. Abra o terminal e utilize o comando para acessar o arquivo de configuração de resolução de nomes:
 ```plaintext
  vim /etc/resolv.conf 
  ```
2. Altere o nameserver e coloque o ip do seu servidor DNS
3. salve o arquivo e reinicie o serviço de rede utilizando:
 ```plaintext
  /etc/init.d/networking restart 
  ```


