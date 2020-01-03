#On recherche les nouveaux fichier SUID
find / -perm -u=s -type f 2>/dev/null >/root/projetbdd/find
#ON récupere l'ancienne liste des fichiers SUID :
sqlite3 /root/projetbdd/cksum.db "select * from initial;" > /root/projetbdd/oldcksum
#on récupere le nombre de lignes des deux fichiers:
nblignefind=$(wc -l /root/projetbdd/find | cut -d " " -f 1)
nbligneoldcksum=$(wc -l /root/projetbdd/oldcksum | cut -d " " -f 1)


#on vérifie si le nombre de ligne est identique :
if [ $nblignefind = $nbligneoldcksum ]; then

  echo "Il n'y a pas de fichiers SUID nouveaux..."

#sinon on essaye de trouver dans le fichier find lequel est nouveau :
else 

  echo "Il y a un nouveau fichier dans le système :"
  cat /root/projetbdd/find | while read ligne; do
 # compteur pour pouvoir comparer les deux fichiers :
  i=$(( $i + 1 ))
# récuperation de l'ancien nom :
  oldnom=$(sed -n $i" p" /root/projetbdd/oldcksum | cut -d '|' -f 1)
#test si les lignes du fichier find ne sont pas identique aux ligne  du fichier oldcksum :
  if [ $ligne != $oldnom ]; then
#récuperation du nom du fichier ou ce n'est pas identique
   nom=$(sed -n $i" p" /root/projetbdd/find | cut -d '|' -f 1)
   echo $nom
#calcul de son cksum :
   cksum=$(cksum $nom | cut -d ' ' -f 1)
   taille=$(cksum $nom | cut -d ' ' -f 2)
#insertion dans la base :   
   sqlite3 /root/projetbdd/cksum.db "insert into initial values('$nom',$cksum,$taille);"
   return
  fi
done
fi
