#!/bin/bash
# deploy.sh — deploy card JS to HA and restart so changes take effect

HA_HOST="192.168.1.90"
HA_PORT="8123"
HA_TOKEN="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiI5ZjI5ZWIzZTg4ZjY0ZjJhYWI0OTZhMjljMmVkNTk2MyIsImlhdCI6MTc4MDg0ODAyMywiZXhwIjoyMDk2MjA4MDIzfQ.rBrHFOoVb8FWj_bdhaGU2RBnsVlJ0MgjlS_GUZxU0gU"
HA_SSH_PASS="claudepassssh433191"
JS_FILE="xiaomi-s20plus-vacuum-card.js"
HA_PATH="/homeassistant/www/community/xiaomi-s20plus-vacuum-card/$JS_FILE"

echo "→ Deploying $JS_FILE..."

# 1. Upload JS
expect -c "
spawn scp -o StrictHostKeyChecking=no -P 22 $JS_FILE root@$HA_HOST:$HA_PATH
expect \"password:\"
send \"$HA_SSH_PASS\r\"
expect eof
" > /dev/null 2>&1 && echo "  ✓ File uploaded"

# 2. Delete .gz + bump version in storage
expect -c "
spawn ssh -o StrictHostKeyChecking=no -p 22 root@$HA_HOST
expect \"password:\"
send \"$HA_SSH_PASS\r\"
expect \"# \"
send \"rm -f ${HA_PATH}.gz && sed -i 's|$JS_FILE?v=[0-9]*|${JS_FILE}?v=\$(date +%s)|g' /config/.storage/lovelace_resources\r\"
expect \"# \"
send \"exit\r\"
expect eof
" > /dev/null 2>&1 && echo "  ✓ Cache cleared, version bumped"

# 3. Restart HA
curl -s -X POST "http://$HA_HOST:$HA_PORT/api/services/homeassistant/restart" \
    -H "Authorization: Bearer $HA_TOKEN" \
    -H "Content-Type: application/json" > /dev/null
echo "  ✓ HA restart triggered..."

# 4. Wait for HA to come back up
printf "  Waiting for HA"
sleep 10
for i in $(seq 1 30); do
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" \
        "http://$HA_HOST:$HA_PORT/api/" \
        -H "Authorization: Bearer $HA_TOKEN" 2>/dev/null)
    if [ "$STATUS" = "200" ]; then
        echo ""
        echo "  ✓ HA is back up!"
        echo ""
        echo "✅ Done! Reload the browser (F5 / Ctrl+R) to see changes."
        exit 0
    fi
    printf "."
    sleep 3
done

echo ""
echo "  ⚠ HA still starting — reload browser in a few seconds."
