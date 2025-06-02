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

### Proxy (Nginx) 
  
  ```plaintext
  Portas: 80 (HTTP), 443 (HTTPS)
  Certificado SSL Autoassinado
  Redirecionamento HTTP para HTTPS
  ```

### Servidor Web

  ```bash
  2 Servidores Web com paginas personalizadas 
  ```

