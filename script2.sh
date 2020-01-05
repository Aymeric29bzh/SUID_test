#Dans ce script j ai eu des problèmes avec la variable <nom>, elle ne se stockais pas correctement les noms de fichier, j ai donc mis le résultat dans un fichier...


#on récupère la table ou se situe la taille des fichiers et leurs cksum initiaux :
sqlite3 /root/projetbdd/cksum.db "select * from initial;" > /root/projetbdd/oldcksum


#Boucle qui lit le fichier :
cat /root/projetbdd/oldcksum | while read ligne; do
#on récupere le nom du fichier
echo $ligne | cut -d '|' -f 1 >> /root/projetbdd/nomfic 

done

#on lit les noms des fichiers :
cat /root/projetbdd/nomfic | while read ligne; do 

#Comme pour le script1 on récupere le cksum, la taille et le nom.
cksum=$(cksum $ligne | cut -d ' ' -f 1) 2>> erreur
taille=$(cksum $ligne | cut -d ' ' -f 2) 2>> erreur
nom=$(cksum $ligne | cut -d ' ' -f 3) 2>> erreur
#Compteur qui s'auto incrémente à chaque tour de la boucle pour lire ligne par ligne le fichier oldckum
i=$(( $i + 1 ))

#on récupere l'ancien cksum:
oldcksum=$(sed -n $i" p" /root/projetbdd/oldcksum | cut -d '|' -f 2)
#on récupere l'ancienne taille
oldtaille=$(sed -n $i" p" /root/projetbdd/oldcksum | cut -d '|' -f 3)
date=$(date +%D-%T)
#on compare si le cksum est équivalent à l'ancien :
if [ $cksum = $oldcksum ]; then
# on compare si la taille est équivalente à l'ancien :
if [ $taille = $oldtaille ]; then
echo "le fichier "$nom" n'a pas été modifié !"$date""
echo "le fichier "$nom" n'a pas été modifié !"$date"" >> /var/log/suid_log 
#Insert dans la base des tests
sqlite3 /root/projetbdd/cksum.db "insert into calcul values('$nom',$cksum,$taille,'$date', 'identique');"
else
#si la taille nest pas bonne :
echo " la taille du fichier" $nom "à changé"$date""
echo " la taille du fichier" $nom "à changé"$date"" >> /var/log/suid_log
sqlite3 /root/projetbdd/cksum.db "insert into calcul values('$nom',$cksum,$taille,'$date', 'modifié');"
fi
else 
#si le cksum a changé :
echo " le fichier "$nom" à changé de cksum"$date""
echo " le fichier "$nom" à changé de cksum"$date"" >> /var/log/suid_log
sqlite3 /root/projetbdd/cksum.db "insert into calcul values('$nom',$cksum,$taille,'$date', 'modifié');"

fi
done

#on remove le fichier ou on stocke les nom car il est susceptible de changer...
rm /root/projetbdd/nomfic


