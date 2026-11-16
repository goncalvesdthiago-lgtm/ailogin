#!/usr/bin/env bash
# Instalador do ailogin.
#   curl -fsSL https://raw.githubusercontent.com/REPO/main/install.sh | bash
#   ./install.sh [--prefix DIR] [--uninstall]
# Instala só um arquivo (o comando "ailogin") em ~/.local/bin. Nada roda sozinho, nada é alterado no seu shell.
set -eu
REPO="${AILOGIN_REPO:-goncalvesdthiago-lgtm/ailogin}"
PREFIX="${HOME}/.local/bin"
ACAO=instalar
while [ $# -gt 0 ]; do
  case "$1" in
    --prefix) PREFIX="$2"; shift ;;
    --uninstall) ACAO=remover ;;
    -h|--help) sed -n '2,5p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) echo "opção desconhecida: $1" >&2; exit 1 ;;
  esac; shift
done
DEST="$PREFIX/ailogin"

if [ "$ACAO" = remover ]; then
  rm -f "$DEST" && echo "removido: $DEST"
  echo "Suas contas e logins continuam em ~/.ailogin (apague à mão se quiser)."
  exit 0
fi

[ -n "${BASH_VERSION:-}" ] || { echo "rode com bash" >&2; exit 1; }
mkdir -p "$PREFIX"
AQUI="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
if [ -n "$AQUI" ] && [ -f "$AQUI/ailogin" ]; then
  cp "$AQUI/ailogin" "$DEST"
else
  command -v curl >/dev/null || { echo "precisa do curl" >&2; exit 1; }
  curl -fsSL "https://raw.githubusercontent.com/$REPO/main/ailogin" -o "$DEST"
fi
chmod +x "$DEST"
bash -n "$DEST" || { echo "arquivo baixado inválido" >&2; rm -f "$DEST"; exit 1; }
echo "ailogin instalado em $DEST"

case ":$PATH:" in *":$PREFIX:"*) ;; *)
  echo
  echo "Atenção: $PREFIX não está no seu PATH. Adicione esta linha ao ~/.zshrc (ou ~/.bashrc):"
  echo "  export PATH=\"$PREFIX:\$PATH\""
  echo "e abra um terminal novo." ;;
esac
echo
echo "Depois é só digitar:  ailogin"
