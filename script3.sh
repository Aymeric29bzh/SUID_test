#On recherche les nouveaux fichier SUID
find / -perm -u=s -type f 2>/dev/null >/root/projetbdd/find
#ON récupere l'ancienne liste des fichiers SUID :
sqlite3 /root/projetbdd/cksum.db "select * from initial;" > /root/projetbdd/oldcksum

nblignefind=$(wc -l /root/projetbdd/find | cut -d " " -f 1)
nbligneoldcksum=$(wc -l /root/projetbdd/oldcksum | cut -d " " -f 1)

if [ $nblignefind = $nbligneoldcksum ]; then

  echo "Il n'y a pas de fichiers SUID nouveaux..."


else 

  echo "Il y a un nouveau fichier dans le système :"
  cat /root/projetbdd/find | while read ligne; do

  i=$(( $i + 1 ))
  oldnom=$(sed -n $i" p" /root/projetbdd/oldcksum | cut -d '|' -f 1)

  if [ $ligne != $oldnom ]; then
   nom=$(sed -n $i" p" /root/projetbdd/find | cut -d '|' -f 1)
   echo $nom
   cksum=$(cksum $nom | cut -d ' ' -f 1)
   taille=$(cksum $nom | cut -d ' ' -f 2)
   sqlite3 /root/projetbdd/cksum.db "insert into initial values('$nom',$cksum,$taille);"
   return
  fi
done
fi


#cat /root/projetbdd/oldcksum | while read ligne; do
#done

