# ailogin

Várias contas de IA, todas logadas ao mesmo tempo, com uma tela para escolher em qual entrar.

Você tem uma conta pessoal e outra do trabalho no Claude Code, no Codex, no Gemini, no Kiro? Em vez de deslogar e logar de novo a cada troca, o `ailogin` dá a cada conta uma pasta própria e abre o CLI apontando para ela. Os logins ficam separados e dá para ter várias contas abertas ao mesmo tempo em terminais diferentes.

*English: manage multiple logged-in accounts for AI CLIs (Claude Code, Codex, Gemini, Kiro, Copilot and more) and pick one from a terminal menu. One bash file, no dependencies.*

## Como ficam as telas

```
 █████╗ ██╗██╗      ██████╗  ██████╗ ██╗███╗   ██╗
██╔══██╗██║██║     ██╔═══██╗██╔════╝ ██║████╗  ██║
███████║██║██║     ██║   ██║██║  ███╗██║██╔██╗ ██║
██╔══██║██║██║     ██║   ██║██║   ██║██║██║╚██╗██║
██║  ██║██║███████╗╚██████╔╝╚██████╔╝██║██║ ╚████║
╚═╝  ╚═╝╚═╝╚══════╝ ╚═════╝  ╚═════╝ ╚═╝╚═╝  ╚═══╝
   todas as suas contas de IA, logadas ao mesmo tempo

╭─ suas contas ───────────────────────────────────────────╮
│ ❯ 1 ● claude   trabalho   ana@empresa.com · hoje         │
│   2 ● claude   pessoal    ana@gmail.com · ontem          │
│   3 ● codex    pessoal    ana@gmail.com · há 3 d         │
│   4 ● kiro     empresa    ana@empresa.com · hoje         │
│   5 +          nova conta                                │
╰──────────────────────────────────────────────────────────╯
 ↑↓ mover   1-9 abrir direto   enter abrir   n nova   r renomear   d apagar   q sair
```

## Instalar

### O que você precisa

- macOS ou Linux, com `bash` e `curl` (já vêm instalados na maioria das máquinas).
- Pelo menos um CLI de IA instalado (Claude Code, Codex, Gemini, Kiro, Copilot...). O `ailogin` gerencia as contas, mas não instala as IAs.

### Passo a passo

1. Abra o terminal e rode:

   ```bash
   curl -fsSL https://raw.githubusercontent.com/goncalvesdthiago-lgtm/ailogin/main/install.sh | bash
   ```

2. Se o instalador avisar que `~/.local/bin` não está no seu PATH, adicione esta linha ao `~/.zshrc` (ou `~/.bashrc`) e abra um terminal novo:

   ```bash
   export PATH="$HOME/.local/bin:$PATH"
   ```

3. Confira que instalou:

   ```bash
   ailogin --version
   ```

4. Abra a tela e cadastre a primeira conta: `ailogin`, tecla `n`, escolha a IA, dê um nome (por exemplo `trabalho`) e faça o login dentro do CLI. Para a segunda conta, repita com outro nome.

Prefere ler o código antes de rodar? Clone o repositório e instale a partir dele:

```bash
git clone https://github.com/goncalvesdthiago-lgtm/ailogin
cd ailogin && ./install.sh
```

O instalador copia um único arquivo para `~/.local/bin/ailogin`. Não altera seu shell, não instala serviços e não roda nada sozinho. Para instalar em outra pasta use `./install.sh --prefix DIR`.

### Atualizar e remover

- **Atualizar:** rode o comando de instalação de novo. Suas contas não são tocadas.
- **Remover:** `./install.sh --uninstall` dentro da pasta clonada. Isso apaga só o comando. As contas e logins ficam em `~/.ailogin`, e você apaga essa pasta à mão se quiser.

## Usar

```bash
ailogin
```

Abre a tela inicial com todas as suas contas.

| Tecla | O que faz |
|---|---|
| ↑ ↓ | mover |
| 1 a 9 | abrir a conta daquela linha direto |
| enter | abrir a conta selecionada |
| n | nova conta (escolhe a IA, dá um nome e faz o login) |
| r | renomear |
| d | apagar (pede confirmação) |
| q | sair |

Cada linha mostra o e-mail logado (quando o CLI permite saber) e quando a conta foi usada pela última vez. Ao abrir, o terminal informa qual conta está ativa e define as variáveis `AILOGIN_ATIVA` e `AILOGIN_EMAIL`.

### Pela linha de comando

```bash
ailogin add claude trabalho          # cria e abre para você fazer o login
ailogin claude trabalho              # abre direto
ailogin claude trabalho --resume     # repassa argumentos ao CLI
ailogin ultima                       # reabre a última conta usada
ailogin ls                           # lista tudo
ailogin rename claude trabalho empresa
ailogin rm claude empresa
ailogin help
```

### Login com SSO

Funciona igual ao uso normal: dentro do CLI (no Claude, `/login`) siga o fluxo do navegador. Se o navegador já estiver logado em outra conta, copie a URL de login e abra numa janela anônima ou em outro perfil, para não cair na conta errada. Depois confira o e-mail na tela do `ailogin`.

## IAs suportadas

Claude Code, Codex, Gemini CLI, Antigravity (`agy`), Kiro, GitHub Copilot CLI, OpenCode, Cursor Agent, Qwen Code, Amp e Droid.

Para incluir outra, crie `~/.ailogin/clis.conf` (veja `clis.conf.example`):

```
id|Nome bonito|comando|modo|cor
minhaia|Minha IA|minhaia|home|255;0;128
```

## Como funciona

- Cada conta vive em `~/.ailogin/<ia>/<conta>/`, com permissão restrita.
- Se o CLI tem uma variável de ambiente para a pasta de configuração (`CLAUDE_CONFIG_DIR`, `CODEX_HOME`, `GEMINI_CLI_HOME`), o `ailogin` usa ela.
- Para os demais, usa um `HOME` virtual por conta.
- Renomear troca só o nome exibido. A pasta não muda, porque alguns logins (como o do Claude no Keychain do Mac) dependem do caminho dela.
- Nas contas do Claude, o `ailogin` liga suas preferências do `~/.claude` (CLAUDE.md, settings, skills, comandos, agentes, hooks) na conta nova, sem copiar o login.

## Avisos

- **Keychain:** CLIs que guardam o login no Keychain do sistema, e não em arquivos, podem acabar compartilhando o mesmo login mesmo com `HOME` virtual. Depois do primeiro login de uma IA nova, abra uma segunda conta dela e confira o e-mail.
- **Suas credenciais ficam na sua máquina**, em `~/.ailogin`. Não suba essa pasta para o Git nem para backups públicos.
- **Use só suas próprias contas.** O `ailogin` serve para alternar entre contas que são suas. Não foi feito para revezar contas e driblar limites de uso, o que pode violar os termos dos serviços.

## Problemas comuns

- **`ailogin: command not found`:** o PATH não inclui `~/.local/bin`. Veja o passo 2 da instalação.
- **A conta nova abriu logada na conta errada:** o navegador já estava logado em outra conta. Copie a URL de login e abra numa janela anônima ou em outro perfil.
- **Duas contas mostram o mesmo e-mail:** a IA provavelmente guarda o login no Keychain do sistema. Veja a seção Avisos.
- **A tela aparece quebrada:** use um terminal com suporte a cores e a caracteres Unicode (Terminal do macOS, iTerm, GNOME Terminal etc.) e deixe a janela com pelo menos 60 colunas.

## Créditos

Ideia inspirada no `favo-cli` de Irwin Arruda. Esta é uma implementação independente.

Criador: Thiago Dias. Licença MIT.
