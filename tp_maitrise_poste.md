# Maîtrise de poste

## Self-footprinting

### Host OS

- Déterminer les principales informations de votre machine.

Si l'on va dans démarrer, paramètres, système, puis informations, on tombe sur la page suivante :

![](https://i.imgur.com/Z19b8LL.png)

Elle détaille les informations de la machine et les spécifications de la version de Windows utilisée.

Si on utilise le gestionnaire des tâches, dans l'onglet performances puis processeur, on trouve des détails sur l'utilisation du processeur. Si l'on voyage dans mémoire, on trouve plus d'informations concernant la RAM.

![](https://i.imgur.com/kZ0zwJ1.png)
![](https://i.imgur.com/P8RqmIA.png)

### Devices

On cherche ici des informations sur les périphériques branchés à la carte mère.

On a déjà trouvé dans les screenshots prédcédents le nom et la marque de mon processeur. C'est un processeur Intel. On voit dans l'onglet processeur qu'il possède 4 coeurs, 8 processeurs logiques.
C'est un Intel core i5-9300H ce qui signifie qu'il est de la 9ième génération de i5, et de la famille Coffee Lake H.

Pour trouver des informations sur le touchpad, ou sur les enceintes intégrées, il faut aller dans démarrer -->gestionnaire de périphériques, puis on fait clique droit sur le périphérique souhaité et propriétés. A partir de là on trouve ces onglets d'informations :

![](https://i.imgur.com/uqLEN9p.png)
![](https://i.imgur.com/zCEoM1W.png)

On y trouve aussi des informations sur le disque dur principale :

![](https://i.imgur.com/BQK9QSK.png)

Mon disque dur ne possède qu'une seule partition (la C:) qui est ma partition principale. Cette partiction va servir, si le système de fichier et le système d'exploitation installés correspondent, à allouer l'espace que va pouvoir utiliser le système d'exploitation pour tous ses processus.

![](https://i.imgur.com/3Zesul2.png)

Lorsque l'on va dans ses propriétés, on peut y lire le système de fichier qui est NTFS

![](https://i.imgur.com/oedd84R.png)

### Network

Pour trouver des informations sur les connections réseau réels et virtuelles, il faut se rendre dans Panneau de configuration, Centre Réseau et partage, puis modifier les paramètre de la carte.

![](https://i.imgur.com/2UVGnI3.png)

Les trois cartes intitulées "Virtual Host-Only" sont des connections virtuelles qui vont servir pour les machines virtuelles (ici de Oracle VirtualBox). Les trois suivantes sont physiques et représentes les moyens de connections au Bluetooth, à l'ethernet, et au wi-fi.

Pour vérifier quels ports sont ouvert, sur l'invite de commande windows, j'ai tapé la commande netstat -abn. Les screenshots suivants représentent la réponse de windows et l'on peut voir de TRES nombreux ports d'ouverts aussi bien en TCP qu'en UDP.

![](https://i.imgur.com/tPe6AXt.png)
![](https://i.imgur.com/JE4jCrD.png)
![](https://i.imgur.com/KTvH3sz.png)
![](https://i.imgur.com/jujCogC.png)
![](https://i.imgur.com/ucsrAcf.png)

En raison des nombreuses connexions d'ouvertes sur mon pc, j'ai préféré utiliser l'attribut -b qui permet l'affichage du nom de l'executable que de lister tous les noms à la main sur ce tp.

### Users

Pour voir ma liste d'utilisateurs, j'ai utilisé l'invite de commande windows et la commande net user.

![](https://i.imgur.com/FAJxow0.png)

On peut y voir que l'utilisateur Dayot (moi) est le seul à posséder les droits d'adminisatrateur. La liste se suit avec plusieurs comptes invités :

### Processus

Pour lister les processus en cours il suffit de se rendre sur le gestionnaire des tâches. Le premier onglet est celui qui nous interesse. Il liste les processus en premier plan, en arrière plan et les services systèmes ainsi que leurs utilisations en terme de ressources.

![](https://i.imgur.com/UpKd6Za.png)
![](https://i.imgur.com/vICHn11.png)

Pour trouver une liste détaillée des services windows (en execution ou non), avec leur descriptions, il m'a fallu ouvrir l'executeur de windows avec windows+R et entrer services.msc.

![](https://i.imgur.com/WFxlntO.png)

On peut y voir la description de ce que gèrent ces services.

On revient sur le gestionnaire des tâches, dans l'onglet détail, pour trouver plus de renseignements sur les processus, la mémoire qu'ils utilisent et le nom de compte qui est à l'origine de l'execution.

![](https://i.imgur.com/Bwin9zs.png)

On voit que la plupart des systèmes primordiaux tels que wininit.exe sont lancé par le système alors que la plupart des services lancés par l utilisateur Dayot sont des logicels ou applications tels que teams, Xampp.

## Scripting

Parmis les languages natif pour scripter que windows propose, j'ai choisi Powershell. C'est un language que j'avais légèrement commencé à pratiquer sans m'en rendre compte et mes recherches m'ont indiqués qu'il présentait plusieurs avantages. Les commandes de powershell sont rétro-compatibles ce qui permet de faire tourner un script peu importe la version de powershell.

Le script1 va servir à récupérer un emsemble d'informations importantes condensés :

![](https://i.imgur.com/EwsqBVg.png)
![](https://i.imgur.com/xSoh3Pl.png)

Le résultat du script1 :

![](https://i.imgur.com/kvka2F0.png)

Le script2 est un script qui va servir à verrouiller l'écran de mon pc, et l'éteindre après quelques secondes :

![](https://i.imgur.com/Wig7y7h.png)

## Gestion de soft

Le gestionnaire de paquet de windows (mais pas installé de base) est chocolatey. Le gestionnaire de paquets permet de centraliser les installations sur un même serveur afin de pouvoir ensuite, grâce à des commandes faciliter la manipulation de ces logiciels. Avec une seule commande on peut mettre à jour tous les logiciels de son pc, sans devoir aller chercher sur internet, vérifier que la version que l'on télécharge est la bonne, trouver des sites de confiances pour le téléchargement (car on ne sait jamais ce qu'il se passe derrière un lien ou un bouton). Lorsque l'on cherche une mise à jour sur internet, on demande la version de notre logiciel à un fournisseur qui peut n'avoir aucun vrai contact avec les personnes qui ont fait le logiciel, qui le propose piraté ou dans des version peut fonctionnelles, ou qui profitent du nom connu du logiciel qu'ils proposent pour faire passer des malwares ou des spyware.
On peut faire des recherches sur ce serveur pour obtenir les informations des logiciels installés. C'est un outils de gestion très pratiques pour la maintenance d'un (et surtout de plusieurs) client.

Chocolatey ne peut agir que sur les paquets que l'on a installé grâce à lui. J'ai donc du installer un paquet pour pouvoir afficher une liste.

![](https://i.imgur.com/KqMSHuo.png)

On utilise 'choco source' pour determiner le serveur par défault sur lequel on va aller chercher nos paquets:

![](https://i.imgur.com/eCjsQTI.png)

## Partage de fichiers

Sur windows 10 il existe une fonction très directe pour activer le partage de fichier sur un réseau. Il faut aller dans l'onglet réseau sur l'explorateur de fichier et faire activer la visualtion des machines autours de soit et leur accorder le droit au partage.
Il faut aussi, sur le fichier ou le dossier que l'on veut partager, autoriser l'acces au fichier par des personne spécifiques (on peut déterminer à cette étape si on souhaite que le fichier partagé soit modifiable ou non).

![](https://i.imgur.com/j6Es0ID.png)

## Chiffrement et notion de confiance

Un certificat est un simple fichier qui contient les informations suivantes:

- le numéros de série du certificat
- Nom/prenom/entreprise
- émetteur
- Date de validité
- clé public
- objet
- fonction de hashage
- un condensat

Toutes ces informations sont hashés par la fonction de hashage précisée; la personne qui reçoit ce certificat va pouvoir utiliser cette fonction pour obtenir un condensat et le comparer à celui fourni.

L'émetteur est l'organisme ou l'entreprise que va certifier de l'authenticité du certificat. On les appels des PKI (public key infrastructure). On va pouvoir se renseigner auprès d'eux pour attester de la véracitée des informations. Les authorités de certification sont elles-mêmes cerifiées par d'autres authorités de certifications jusqu'à une authorité racine qui est fiable à 100%.

Tout cela pour valider l'indentité de la personne qui donne sa clef publique. Afin d'éviter les pirates qui se font passer pour quelqu'un et fournissent des clefs publiques pour faire transiter des informations par eux-mêmes.

## Chiffrement de mail

Dans le but de faire du chiffrement de mail j'ai du faire beaucoup de recherches pour en comprendre le principe. J'ai choisi d'utiliser un service pour m'aider à la génération et au partage des clefs publiques. J'utilise kleopatra qui fonctionne sur du gpg.

Cela me permet de générer et d'envoyer des clef publique mais aussi d'enregistrer quels sont les utilisateurs pour lesquels j'ai enregistré ou partagé des clefs.

![](https://i.imgur.com/oTpla9C.png)

Le prince est le suivant, on échange une paire de clef publique pour démarrer une liaison entre deux utilisateurs. Lorsque l'on veut envoyer un message à quelqu'un, on chiffre notre message avec la clef publique de cette personne. Ce qui fait que seul cette personne pourra déchiffrer le message grâce à sa clef privée et vice-versa. Grâce à cela si l'on choisi des clefs publiques différentes par utilisateurs, on peut même garantir la provenance du message.

## TLS

L'HTTP et l'HTTPS sont deux protocoles d'échanges à travers le web. A la différence de l'HTTP, l'HTTPS est considéré comme plus sécurisé car il permet le chiffrement des données et ganrantie qu'elless ne soient pas modifiées pendant le transfert.

![](https://i.imgur.com/NlODMDv.png)

Sur ce certificat qui provient de Facebook, on peut voir qu'ils sont certifiés par DigiCert Inc, que leur certificat expire le 14 juillet 2020 (pas d'inquiétude il ser renouvellé). On trouve aussi des informations concernant l'utilisateur, combien de fois il a déjà visité le site, si des cookies le concernant sont stocké en local, si j'ai sélectionné l'enregistrement de mon mot de passe. Enfin, on nous indique que la connexion est chiffrée et la clef de chiffrement.
Ce n'est qu'un résumé des informations principales du certificat, si on le souhaite, on peut l'afficher en entier.
C'est sur le certificat en entier que l'on trouvera la clef publique de facebook si l'on sohaite l'enregistrer.

![](https://i.imgur.com/an5GJcN.png)

## SSH Client

Le principe d'échange de clefs SSH repose sur une différence entre clef publique et clef privée. Tout est dans le nom, la clef publique est la clef échangeable alors que la clef privée est à garder secrètement.
Si un client1 veut faire un transfert sécurisé vers un client2, il doit posséder la clef publique du client2. Il va chiffrer son message avec la clef publique du client2 et l'envoyer. La sécurité tient dans le fait que seul le client2 possède sa clef privée qui va servir à déchiffrer le message.

Client1 <---> Client2
</br>
(clef publique client2) <---> (clef publique client1)
</br>
(clef privé client1) xxxxxxx (clef privé client2)

Une fois les clefs échangés et la première connexion effectuée, les deux machines "se font confiance" et peuvent communiquer sans plus de vérifications.
Le fingerprint SSH est une suite chiffrée qui va servir à identifier les clients à la première connexion. Afin de sécuriser la mise en place de la connexion, on peut y acceder dans un fichier de configuration de la machine hôte et il sera proposé au client lorsqu'il tentera sa première connexion, lui permettant, s'il doute, de comparer cette empreinte avec les informations de l'hôte avant d'ouvrir.

## SSH Tunnel

Le but est de pouvoir accéder à un service qui tourne derrière un port sur une machine distante à travers une connexion ssh. Dans ce but il faut faire de la redirection de ports port que la demande du proxy sorte par le port choisi. On configure "l'entrée" du tunnel ssh en lui attribuant un port coté machine physique et demande au navigateur d'utiliser un proxy qui utilise ce port. Lorsque l'on fera une demande localhost, la demande sera envoyée à travers le tunnel et c'est le 'localhost' de la machine qui devrait être renvoyé (ici la page d'accueil de nginx normalement).

Mais je n'ai pas réussi à le faire fonctionnner :
mes seuls résultats sont "page web inaccessible" ou "404".

## SSH jumps

Une alternative possible à la configuration précédente aurait put être le SSH jumps. Le principe est de forcer l'execution d'une commande ssh sur l'hôte pour passer au prochain et cela peut continuer..

```
ssh -J username@host1:port username@host2:port
```

En utilisant cette commande, on cherche joindre le host2 sur son port choisi, en été juste passé par le host1 sans s'arréter.

## Forwarding de ports at home

N'ayant pas pu prendre contact avec d'autres étudiants (pas par manque de moyens mais parce que je n'ai pas lu le tp en entier avant de me dire 'fini la dernière partie dimanche soir'), je n'ai pas pu réaliser le Forwarding.

L'idée de l'IP en bridge pour la VM revient à créer un pont (oui..) pour que la VM puisse accéder au même réseau que son hôte. L'ip en bridge sera donc un ip sur le même réseau que l'ip de la machine physique.

Au final, avec une VM sur mon réseau local, je pourrais lui configurer une interface avec une ip fixe et m'y connecter avec d'autres machines.

J'aurais bien aimé montrer au moins la partie configuration de ma box mais malheureusement, c'est mon ancien colocataire qui possède les identifiants et il est injoignable...
