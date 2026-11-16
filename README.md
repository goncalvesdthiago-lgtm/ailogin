# ailogin

Várias contas de IA, todas logadas ao mesmo tempo, com uma tela para escolher em qual entrar.

Você tem uma conta pessoal e outra do trabalho no Claude Code, no Codex, no Gemini, no Kiro? Em vez de deslogar e logar de novo a cada troca, o `ailogin` dá a cada conta uma pasta própria e abre o CLI apontando para ela. Os logins ficam separados e dá para ter várias contas abertas ao mesmo tempo em terminais diferentes.

*English: manage multiple logged-in accounts for AI CLIs (Claude Code, Codex, Gemini, Kiro, Copilot and more) and pick one from a terminal menu. One bash file, no dependencies.*

## Instalar

```bash
curl -fsSL https://raw.githubusercontent.com/goncalvesdthiago-lgtm/ailogin/main/install.sh | bash
```

Ou clonando o repositório: `git clone https://github.com/goncalvesdthiago-lgtm/ailogin && cd ailogin && ./install.sh`

O instalador copia um único arquivo para `~/.local/bin/ailogin`. Não altera seu shell, não instala serviços e não roda nada sozinho. Se `~/.local/bin` não estiver no seu PATH, ele avisa o que adicionar. Para remover: `./install.sh --uninstall`.

Precisa de `bash` e de um terminal com cores. Testado no macOS; no Linux deve funcionar, mas foi menos testado.

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

## Créditos

Ideia inspirada no `favo-cli` de Irwin Arruda. Esta é uma implementação independente.

Criador: Thiago Dias. Licença MIT.
