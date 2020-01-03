# SUID_test
L'objectif est de proposer un système de surveillance des fichiers exécutables SUID de votre système. Les fichiers exécutables disposant d’un droit SUID sont des points sensibles de la sécurité d’un système. Vous allez mettre en place une solution de surveillance de ces fichiers. L’idée est de calculer avec un premier programme une empreinte (checksum) des fichiers SUID et de les stocker dans une base de données.  Chaque jour un second programme a pour rôle de recalculer le checksum des fichiers SUID et vérifier par rapport à ce qui est stocké dans la base de données si le contenu des fichiers SUID n’a pas évalué, puis de générer des rapports

Le premier script cherche dans tout le système les fichiers disposant d’un droit 
SUID. Pour chacun d’eux on calcule son checksum et sa taille en octet et on stocke ces informations dans la base de données.  
