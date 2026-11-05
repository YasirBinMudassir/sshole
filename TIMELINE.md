# timeline

every line links to the actual commit or mail. the long version with commentary is on [sshhole.com](https://sshhole.com).

| when | what | where |
|---|---|---|
| 1980 | bill joy puts a `*` in `/etc/passwd` for `daemon`. "no password can match this" | [3bsd /etc/passwd](https://github.com/dspinellis/unix-history-repo/blob/BSD-3/etc/passwd) |
| 1990s | sshd checks passwords with `strcmp(crypt(pw, field), field)`. a `*` field can never match | openssh `auth-passwd.c` |
| 1997 | posix: `crypt()` returns NULL on error | [sus crypt()](https://pubs.opengroup.org/onlinepubs/7908799/xsh/crypt.html) |
| 2012-08-09 | musl: `crypt()` returns `"*"` instead of NULL on failure, "unmatchable hash", because callers don't null-check | [musl b3c4cc12](https://git.musl-libc.org/cgit/musl/commit/?id=b3c4cc12) |
| 2012-08-29 | musl adds sha256/sha512 crypt with a 256-byte key limit. over the limit = failure = `"*"` | [musl 88bf5a8a](https://git.musl-libc.org/cgit/musl/commit/?id=88bf5a8a) |
| 2013-07 | debian #714219: glibc's NULL breaks programs; a dev proposes copying musl's `"*"`. debian later moves to libxcrypt, which returns `"*0"`. one character away | [libc-alpha](https://sourceware.org/legacy-ml/libc-alpha/2013-07/msg00046.html) |
| 2016-07-15 | CVE-2016-6210 timing fix: for accounts without a usable salt, sshd hashes with another account's salt (`pick_salt`). still compares against the stored field. the bug is born. shipped in 7.3p1 | [openssh 9286875a7](https://github.com/openssh/openssh-portable/commit/9286875a73b2de7736b5e50692739d314cd8d9dc), [dbf788b4d](https://github.com/openssh/openssh-portable/commit/dbf788b4d9d9490a5fff08a7b09888272bb10fcc) |
| 2019-05 | CVE-2019-5021: alpine docker images have an empty root password. fixed by locking root with `!` | [alpine advisory](https://www.alpinelinux.org/posts/Docker-image-vulnerability-CVE-2019-5021.html) |
| 2022 | alpine 3.16 changes root to `*` so ssh keys work again. root is now a target on every alpine image | [aports fbe926af](https://gitlab.alpinelinux.org/alpine/aports/-/commit/fbe926af) |
| 2024-12 | musl list: busybox `passwd` segfaults on a 257-byte password (the read-only `"*"`). limit and token kept. nobody mentions sshd | [musl list](https://www.openwall.com/lists/musl/2024/12/31/2) |
| 2026-10-30 | openssh security review fixes bcrypt handling in `pick_salt()`. four lines above the bug | [openssh 84f8f4666](https://github.com/openssh/openssh-portable/commit/84f8f4666) |
| 2026-11-03 | found, via a differential auth matrix across libcs and build flags. sha256 commitment tweeted | [tweet](https://x.com/kultekin) |
| 2026-11-03 | reported to openssh@openssh.com. patch back in under an hour | |
| 2026-11-04 | alpine, musl notified | |
| 2026-11-05 | openssh 10.6p2 released. alpine packages same minute | [release notes](https://www.openssh.com/txt/release-10.6p2), [fix 4353fdc43](https://github.com/openssh/openssh-portable/commit/4353fdc43ef646c43a8dda7025cc1a898caf1482), [aports d482fb50](https://gitlab.alpinelinux.org/alpine/aports/-/commit/d482fb50) |
| 2026-11-05 | sshhole.com | |
