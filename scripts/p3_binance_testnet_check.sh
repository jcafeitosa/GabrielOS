#!/usr/bin/env bash
# P3 — verificação de permissões da chave Binance Testnet.
# Lê as chaves do cofre do OpenBot, sem imprimir os valores.
# Critério: a chave deve funcionar e NÃO pode ter saque habilitado.
set -u

VAULT="/Users/jcafeitosa/Library/Application Support/OpenBot/agent-api-keys/.vault"
KEY_FILE="$VAULT/BINANCE_TESTNET_API_KEY"
SECRET_FILE="$VAULT/BINANCE_TESTNET_API_SECRET"
BASE="https://testnet.binance.vision"

for f in "$KEY_FILE" "$SECRET_FILE"; do
  if [ ! -f "$f" ]; then
    echo "FALHA: arquivo ausente: $(basename "$f")"; exit 2
  fi
done

K="$(cat "$KEY_FILE")"
S="$(cat "$SECRET_FILE")"

echo "tamanho chave: ${#K} (esperado 64) | tamanho segredo: ${#S} (esperado 64)"
if [ "${#K}" -ne 64 ] || [ "${#S}" -ne 64 ]; then
  echo "FALHA: tamanho inesperado; provável caractere perdido ao salvar."
  unset K S; exit 3
fi

echo "conectividade: $(curl -s -o /dev/null -w '%{http_code}' "$BASE/api/v3/ping")"

TS=$(python3 -c 'import time;print(int(time.time()*1000))')
Q="timestamp=$TS&recvWindow=5000"
SIG=$(printf '%s' "$Q" | openssl dgst -sha256 -hmac "$S" | awk '{print $NF}')
RESP=$(curl -s -H "X-MBX-APIKEY: $K" "$BASE/api/v3/account?$Q&signature=$SIG")
unset K S

printf '%s' "$RESP" | python3 -c '
import sys, json
d = json.load(sys.stdin)
if "code" in d:
    print("FALHA: API recusou a chave:", d); sys.exit(4)
print("canTrade:", d.get("canTrade"), "| canDeposit:", d.get("canDeposit"), "| canWithdraw:", d.get("canWithdraw"), "| permissions:", d.get("permissions"))
if d.get("canWithdraw"):
    print("REPROVADO: saque habilitado. Gere outra chave sem permissão de saque.")
    sys.exit(5)
print("APROVADO no critério de saque bloqueado.")
'
