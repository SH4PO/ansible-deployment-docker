![](https://www.indetail.co.jp/wp-content/uploads/2016/02/ansible_docker_1200-1024x538.png)
# Introduction : 

Mis à jour le 14/10/2020

# Pré-requis : 

- Une machine sous Linux (testé sur Debian uniquement)

# Installation (avec le compte "root"): 

1. Mise à jour des paquets

```
apt update && apt upgrade -y
```

2. Installation de Git :

```
apt install git -y
```

3. Import du projet :

```
git clone https://github.com/SH4PO/ansible-deployment-docker.git
```

4. Se rendre dans le dossier du projet :

```
cd ansible-deployment-docker
```

5. Lancer le script d'installation : 

```
./stack.sh
```

Ce projet est a caractère expérimental pour le moment. Tous droits réservés
