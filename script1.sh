# Ligne de commande pour trouver tout les fichiers SUID du système, on met le résultat dans un fichier.
find / -perm -u=s -type f 2>/dev/null >/root/projetbdd/find

#Boucle while recherchant ligne par ligne le cksum.
cat /root/projetbdd/find | while read ligne; do

#On vérifie si le fichier est bien un fichier existant: 
if [ -u $ligne ]; then

#on récupére le cksum :
cksum=$(cksum $ligne | cut -d ' ' -f 1)

#on récupére la taille : 
taille=$(cksum $ligne | cut -d ' ' -f 2)

#on récupére le nom :
nom=$(cksum $ligne | cut -d ' ' -f 3)


echo $cksum " " $taille " " $nom
#INSERT du résultat dans la base:
sqlite3 /root/projetbdd/cksum.db "insert into initial values('$nom',$cksum,$taille);"

fi
done

