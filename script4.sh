#Création du dossier :
mkdir /root/verifsuid
#Création du script1 :
echo "Création du script1 en cours..."
echo "# Ligne de commande pour trouver tout les fichiers SUID du système, on met le résultat dans un fichier." >> /root/verifsuid/script1.sh
echo "find / -perm -u=s -type f 2>/dev/null >/root/projetbdd/find" >> /root/verifsuid/script1.sh
echo "#Boucle while recherchant ligne par ligne le cksum." >> /root/verifsuid/script1.sh
echo "cat /root/projetbdd/find | while read ligne; do" >> /root/verifsuid/script1.sh
echo "#On vérifie si le fichier est bien un fichier existant:" >> /root/verifsuid/script1.sh
echo "if [ -u $ligne ]; then" >> /root/verifsuid/script1.sh
echo "#on récupére le cksum :" >> /root/verifsuid/script1.sh
echo "cksum=$(cksum $ligne | cut -d ' ' -f 1)" >> /root/verifsuid/script1.sh
echo "#on récupére la taille :" >> /root/verifsuid/script1.sh 
echo "taille=$(cksum $ligne | cut -d ' ' -f 2)" >> /root/verifsuid/script1.sh
echo "#on récupére le nom :" >> /root/verifsuid/script1.sh 
echo "nom=$(cksum $ligne | cut -d ' ' -f 3)" >> /root/verifsuid/script1.sh
echo "echo $cksum " " $taille " " $nom" >> /root/verifsuid/script1.sh
echo "#INSERT du résultat dans la base:" >> /root/verifsuid/script1.sh
echo "sqlite3 /root/projetbdd/cksum.db "insert into initial values('$nom',$cksum,$taille);"" >> /root/verifsuid/script1.sh
echo "fi" >> /root/verifsuid/script1.sh
echo "done" >> /root/verifsuid/script1.sh
echo "Script 1 créé !"