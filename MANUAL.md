# Manual do ailogin

Este manual ensina a usar o `ailogin` do zero, com exemplos do dia a dia. Se você só quer instalar, o [README](README.md) basta.

## 1. A ideia em um minuto

Normalmente, quem tem duas contas da mesma IA (por exemplo, a pessoal e a do trabalho no Claude Code) precisa sair de uma e entrar na outra a cada troca. O `ailogin` evita isso: ele guarda cada conta numa pasta separada e abre a IA apontando para a pasta certa. As duas contas ficam logadas ao mesmo tempo e você só escolhe qual abrir.

Três palavras que aparecem no manual:

- **IA** (ou CLI): o programa de terminal, como `claude`, `codex`, `gemini`, `kiro-cli`.
- **Conta**: um login de uma IA, com um nome que você escolhe (`trabalho`, `pessoal`).
- **Tela**: o menu que abre quando você digita `ailogin`.

## 2. Primeiros passos

Instale (veja o README) e confira:

```bash
ailogin --version
```

### Cadastrar sua primeira conta

1. Digite `ailogin`. Sem contas, a tela mostra só a linha **nova conta**.
2. Aperte `enter` (ou `n`).
3. Escolha a IA com as setas e aperte `enter`. IAs que não estão instaladas no seu computador aparecem com "(falta instalar)".
4. Digite um nome para a conta e aperte `enter`. Use letras, números, `-` e `_` (por exemplo `trabalho`).
5. A IA abre sem login. **Faça o login dentro dela**, do jeito normal daquela IA:
   - Claude Code: digite `/login`.
   - Codex: `codex login` ou o login que ele pede ao abrir.
   - Gemini: o login do Google aparece ao abrir.
   - Kiro: `kiro-cli login`.
6. Pronto. Saia da IA. A conta fica salva e logada.

### Cadastrar a segunda conta

Repita o processo com outro nome. Se for da mesma IA, o `ailogin` mantém as duas separadas.

## 3. Uso diário

### Pela tela

Digite `ailogin` e use:

| Tecla | O que faz |
|---|---|
| ↑ ↓ (ou `j` `k`) | mover a seleção |
| `1` a `9` | abrir direto a conta daquela linha |
| `enter` | abrir a conta selecionada |
| `n` | nova conta |
| `r` | renomear |
| `d` | apagar (pede que você digite `sim`) |
| `q` | sair |

Cada linha mostra a cor da IA, o nome da conta, o **e-mail logado** (quando a IA permite saber) e **quando você usou pela última vez**. Conta sem login aparece em vermelho.

### Pelo comando

Quando você já sabe o que quer, pule a tela:

```bash
ailogin claude trabalho          # abre essa conta
ailogin claude trabalho --resume # repassa opções para a IA
ailogin claude                   # menu só das contas do Claude
ailogin ultima                   # reabre a última conta que você usou
```

Tudo o que vem depois do nome da conta é entregue à IA, como se você tivesse digitado direto nela.

### Como saber em qual conta estou?

Ao abrir uma conta, o terminal mostra uma linha como `▸ ailogin  Claude Code · trabalho (ana@empresa.com)` e o título da janela muda. Dentro da IA também ficam definidas duas variáveis, `AILOGIN_ATIVA` (por exemplo `claude:trabalho`) e `AILOGIN_EMAIL`, que você pode usar em scripts ou numa linha de status.

## 4. Receitas

### Conta pessoal e conta do trabalho

```bash
ailogin add claude pessoal
ailogin add claude trabalho
```

Depois, `ailogin` e `1` ou `2` para escolher. Dá para ter as duas abertas ao mesmo tempo, cada uma num terminal.

### Conta do trabalho com SSO

O login é igual ao normal: na IA, siga o fluxo do navegador com o e-mail da empresa. O cuidado é com o navegador. Se ele já estiver logado na conta pessoal, o login pode cair na conta errada. Copie a URL de login que a IA mostra e abra numa **janela anônima** ou num **outro perfil**. Depois confira o e-mail na tela do `ailogin`.

### Trocar o nome de uma conta

Na tela, selecione a conta e aperte `r`. Ou:

```bash
ailogin rename claude trabalho empresa
```

O login continua valendo. Renomear muda só o nome exibido, e o nome antigo continua funcionando nos comandos.

### Refazer o login

```bash
ailogin login claude trabalho
```

Abre a IA nessa conta para você logar de novo.

### Apagar uma conta

Na tela, `d` e digite `sim`. Ou `ailogin rm claude empresa`. Isso apaga também o login daquela conta.

### Usar uma IA que não está na lista

Crie o arquivo `~/.ailogin/clis.conf` com uma linha por IA:

```
id|Nome bonito|comando|modo|cor
minhaia|Minha IA|minhaia|home|255;0;128
```

- `id`: nome curto, sem espaços.
- `comando`: o programa que o terminal executa.
- `modo`: `home` serve para quase qualquer IA. Se a IA tem uma variável de ambiente que aponta a pasta de configuração, use `env:NOME_DA_VARIAVEL` (por exemplo `env:CODEX_HOME`).
- `cor`: três números de 0 a 255 (vermelho;verde;azul) para a bolinha na tela.

Depois, ela aparece em **nova conta**.

## 5. Onde ficam as coisas

| O quê | Onde |
|---|---|
| Contas e logins | `~/.ailogin/<ia>/<conta>/` |
| Lista extra de IAs | `~/.ailogin/clis.conf` |
| O comando | `~/.local/bin/ailogin` |

Para guardar as contas em outro lugar, defina `AILOGIN_DIR` antes de rodar (`AILOGIN_DIR=/caminho ailogin`).

**Segurança:** a pasta das contas contém seus logins. Não suba para o Git, não compartilhe e não inclua em backups públicos. As pastas são criadas com permissão restrita ao seu usuário.

## 6. Como funciona por dentro

Quando você abre uma conta, o `ailogin` roda a IA com o ambiente apontando para a pasta daquela conta:

- Se a IA aceita uma variável de pasta (Claude: `CLAUDE_CONFIG_DIR`, Codex: `CODEX_HOME`, Gemini: `GEMINI_CLI_HOME`), usa ela.
- Senão, usa um `HOME` virtual dentro da pasta da conta.

Por isso os logins não se misturam. Duas consequências úteis de saber:

- **Renomear não move a pasta.** O nome é só uma etiqueta (arquivo `.ailogin-nome`). Isso protege o login de IAs que o amarram ao caminho da pasta.
- **No Claude Code, suas preferências são ligadas, não copiadas.** A conta nova recebe links para o seu `CLAUDE.md`, `settings.json`, skills, comandos, agentes e hooks do `~/.claude`. O login nunca é copiado.

O status na tela vem de arquivos da própria conta (o e-mail do Claude e do Codex, por exemplo), sem abrir a IA. O "último uso" é a data de um arquivo `.ailogin-uso`, atualizado cada vez que você abre a conta.

## 7. Quando algo dá errado

| Sintoma | O que fazer |
|---|---|
| `ailogin: command not found` | `~/.local/bin` não está no PATH. Adicione `export PATH="$HOME/.local/bin:$PATH"` ao `~/.zshrc` e abra um terminal novo. |
| Abriu logado na conta errada | Era o navegador. Use janela anônima ou outro perfil no login. |
| Duas contas mostram o mesmo e-mail | A IA guarda o login no Keychain do sistema, então o `HOME` virtual não separa. Teste com outra IA ou veja se ela tem uma variável de pasta e use `env:`. |
| A IA diz que não está instalada | Instale a IA e confira que o comando funciona fora do `ailogin`. |
| Conta aparece como "sem login" | Entre nela (`enter`) e faça o login dentro da IA. |
| A tela aparece quebrada | Use um terminal com cores e Unicode e janela com pelo menos 60 colunas. |
| "já existe uma conta..." | O nome já é usado nessa IA. Escolha outro. |

## 8. Para quem quer mexer no código

O `ailogin` é um único arquivo bash, sem dependências além de ferramentas comuns do sistema (`python3` só para ler o e-mail do Codex e `sqlite3` para o status do Kiro, ambos opcionais). Os pontos principais:

- **Catálogo de IAs:** a variável `CATALOGO` no começo do arquivo.
- **`rodar`:** monta o ambiente e executa a IA. É onde entram `env:` e `home`.
- **`status_login`:** como cada IA revela quem está logado. Para suportar uma IA nova, acrescente um caso.
- **`tela` e `lista_tui`:** a interface.

Depois de editar, confira a sintaxe com `bash -n ailogin` e teste com contas descartáveis, apontando `AILOGIN_DIR` para uma pasta temporária para não tocar nas suas contas reais.

Sugestões e correções são bem-vindas nas issues do repositório.
