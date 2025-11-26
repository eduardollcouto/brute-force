# Brute-Force
Simulações de Força Bruta (FTP/SSH) com Medusa e Mitigações de Segurança

# DevSecOps Lab: Ataques de Força Bruta (FTP & SSH) e Controles de Mitigação

Este repositório documenta um projeto prático de auditoria de segurança realizado em um ambiente de laboratório isolado (Kali Linux e Metasploitable 2), focando na metodologia **"Shift-Left"** (mover a segurança para a esquerda) do DevSecOps.

## Objetivo Educacional

O principal objetivo deste projeto é **compreender, simular e propor defesas** contra ataques de **Força Bruta** em serviços de rede comuns (FTP e SSH). O foco está em:

1.  **Uso Ético de Ferramentas:** Utilizar o **Medusa** para automação de *login* em ambientes controlados.
2.  **Desenvolvimento Seguro:** Entender as vulnerabilidades que permitem esses ataques.
3.  **Mitigação Prática:** Documentar e implementar os controles de segurança mais eficazes para prevenir a força bruta.

## Arquitetura do Laboratório

Todos os testes foram realizados em um ambiente de máquinas virtuais (VMs) isolado usando o VirtualBox, configurado com uma rede **Host-Only** para garantir que nenhuma atividade de teste afetasse redes externas ou sistemas de terceiros.

* **Máquina Atacante:** Kali Linux (Contém o Medusa, Python, e Bash scripts)
* **Máquina Alvo:** Metasploitable 2 (Serviços FTP e SSH vulneráveis)
* **Rede:** Host-Only (Ex: 192.168.56.0/24)

## Scripts Implementados

Foram criados e utilizados scripts interativos em **Bash** e **Python** para automatizar o processo de teste, garantindo a criação de *wordlists* de senhas e usuários personalizadas.

| Script | Serviço Alvo | Linguagem | Ação Principal |
| :--- | :--- | :--- | :--- |
| `bruteforce_ftp.sh/py` | FTP (Módulo `ftp` do Medusa) | Bash/Python | Cria listas e tenta autenticação contra a porta 21. |
| `bruteforce_ssh.sh/py` | SSH (Módulo `ssh` do Medusa) | Bash/Python | Cria listas e tenta autenticação contra a porta 22. |

## Principais Recomendações de Mitigação

As credenciais foram descobertas devido à falta de controles de segurança adequados. As seguintes medidas são essenciais para mitigar o risco de Força Bruta em qualquer ambiente de produção:

### Mitigação para SSH (Serviço Crítico)
* **Substituição:** Desativar a autenticação por senha e usar apenas **Chaves SSH (Assinaturas Criptográficas)**.
* **Detecção:** Implementar **Fail2Ban** ou soluções similares para bloquear IPs maliciosos após **3-5 tentativas de *login* fracassadas**.
* **Controles Adicionais:** Usar MFA (Autenticação Multifator) e alterar a porta padrão (22) para reduzir o ruído de varreduras automatizadas.

### Mitigação para FTP (Protocolo Legado)
* **Substituição:** Migrar para o protocolo **SFTP (Secure File Transfer Protocol)**, que se baseia em SSH e usa criptografia forte.
* **Controle de Acesso:** Desativar o *login* anônimo e aplicar o **Princípio do Menor Privilégio** aos diretórios acessíveis.
* **Monitoramento:** Aplicar bloqueio de taxa e monitorar a integridade do servidor de *log*.

## Aviso Legal

**ESTE MATERIAL É APENAS PARA FINS EDUCACIONAIS E DE ESTUDO ÉTICO.** O teste de segurança e a Força Bruta só devem ser realizados em sistemas para os quais você possui **permissão explícita por escrito**. O uso deste código em ambientes não autorizados é ilegal e antiético.
