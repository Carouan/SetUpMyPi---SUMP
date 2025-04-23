# 🚀 SetUpMyPi (SUMP)

**SUMP** est un outil shell modulaire pour configurer rapidement et proprement un serveur Debian ou Raspberry Pi.
Il vous guide étape par étape pour sécuriser, configurer, sauvegarder et équiper votre machine.

## 📦 Modules inclus

| Ordre | Script                        | Description                                                  | Auto |
|-------|-------------------------------|--------------------------------------------------------------|------|
| 00    | `00_SysUp.sh`                 | Mise à jour système + redémarrage                            | ✅   |
| 01    | `01_Sec_SSH.sh`               | Sécurisation SSH (nouvel utilisateur sudo + clé + port)      | ❌   |
| 02    | `02_Sec_Host.sh`              | Pare-feu UFW + protection fail2ban                           | ✅   |
| 03    | `03_BasFig.sh`                | Nom d’hôte + IP statique + DNS                               | ❌   |
| 04    | `04_DynIp.sh`                 | Configuration DNS dynamique (DuckDNS)                        | ❌   |
| 05    | `05_SetBackup.sh`             | Mise en place des sauvegardes automatiques (rsync, cron)     | ❌   |
| 06    | `06_Finally_Utility_Thinks.sh`| Installation finale : Docker, monitoring, etc.               | ❌   |

## ⚡ Lancement rapide

```bash
wget -O SUMP.sh 'https://raw.githubusercontent.com/Nauorac/SetUpMyPi---SUMP/main/SUMP.sh' && chmod +x SUMP.sh && sudo bash SUMP.sh
```

## 🤝 Contributions

Tu veux proposer un nouveau module ? Une interface Web ?
Ouvre une issue ou une pull request — toute contribution est la bienvenue 🙌

## 📜 Licence

Projet libre sous licence MIT.

---

# 🚀 SetUpMyPi (SUMP)

**SUMP** is a modular shell tool to quickly and cleanly set up a Debian or Raspberry Pi server
It guides you step-by-step to secure, configure, back up and equip your system.

## 📦 Included Modules

| Order | Script                        | Description                                                  | Auto |
|-------|-------------------------------|--------------------------------------------------------------|------|
| 00    | `00_SysUp.sh`                 | System update + reboot                                       | ✅   |
| 01    | `01_Sec_SSH.sh`               | SSH security (new sudo user + SSH key + port change)         | ❌   |
| 02    | `02_Sec_Host.sh`              | UFW firewall + fail2ban protection                           | ✅   |
| 03    | `03_BasFig.sh`                | Hostname + static IP + DNS                                   | ❌   |
| 04    | `04_DynIp.sh`                 | Dynamic DNS setup (DuckDNS)                                  | ❌   |
| 05    | `05_SetBackup.sh`             | Automatic backup setup (rsync, cron)                         | ❌   |
| 06    | `06_Finally_Utility_Thinks.sh`| Final install: Docker, monitoring, etc.                      | ❌   |

## ⚡ Quick Launch

```bash
wget -O SUMP.sh 'https://raw.githubusercontent.com/Nauorac/SetUpMyPi---SUMP/main/SUMP.sh' && chmod +x SUMP.sh && sudo bash SUMP.sh
```

## 🤝 Contribute

Want to add a new module or interface?
Open an issue or pull request — contributions are welcome 🙌

## 📜 License

MIT License.