SUPABASE_URL="https://tu-proyecto.supabase.co/rest/v1/activos_validos"
SUPABASE_KEY="Bearer tu_token"

IDS_VALIDOS=$(curl -s "$SUPABASE_URL" \
  -H "Authorization: $SUPABASE_KEY" \
  -H "apikey: $SUPABASE_KEY" \
  | jq -r '.[].activo' | paste -sd "|" -)

ARCHIVOS_CAMBIADOS=$(git diff --name-only HEAD^ HEAD)

for ARCHIVO in $ARCHIVOS_CAMBIADOS; do
  echo "Verificando: $ARCHIVO"
  if [[ "$ARCHIVO" =~ evidencias/($IDS_VALIDOS)/(entradas|salidas)/.* ]]; then
    echo "✅ Válido: $ARCHIVO"
  else
    echo "❌ Inválido: $ARCHIVO"
    exit 1
  fi
done
