#Déploiement d'un client tinc depuis une configuration existante

Cette documentation vise à expliquer comment ajouter un client à une configuration Tinc existante à partir d'une archive de configuration livrée.

##Installation de Tinc

Tinc est fourni par *Debian*. Pour l'installer, il suffit donc de commander son installation via *apt* :

    sudo apt-get install tinc

Une fois installé, un nouveau service *tinc* est disponible ainsi qu'un répertoire de configuration  */etc/tinc*.

##Désarchiver l'archive de configuration

Désarchiver l'archive livrée depuis le répertoire de configuration */etc/tinc* :

    cd /etc/tinc
    tar zxvf /tmp/conf_tinc_loire.tgz

Dans l'exemple ci dessus, l'archive contient une configuration pour un réseau tinc appelé *loire*. Un nouveau répertoire est donc disponible pour ce réseau */etc/tinc/loire*.

Ce répertoire contient un fichier de configuration général *tinc.conf* où notamment le nom du noeud est définit (via la directive *Name*) ainsi que les serveurs tinc à utiliser (via les directive *ConnectTo*) :

    Device=/dev/net/tun
    Mode=switch
    Name=nouveauclient
    ConnectTo=serveur1
    ConnectTo=serveur2

Dans l'exemple ci dessus, le nom du noeud que nous créons est *nouveauclient*. Ce noeud se connectera à deux serveurs tinc (*serveur1* et *serveur2*).

Chaque nom serveur correspond à un fichier de configuration dans le sous répertoire hosts :

    $ ls /etc/tinc/loire/hosts/
    serveur1  serveur2

##Création d'une paire de clées

Afin de permettre à ce nouveau noeud de se connecter au réseau tinc, il faut que celui ci possède une paire de clée PKI (public/privée). Pour créer ce type de clés, une commande tinc est disponible :

    tincd -n loire -k

L'option **-n** permet de spécifié le réseau pour lequel on souhaite créer une paire de clées (ici *loire*). L'option **-k**, permet de commander la création de clés.

A l'issue de cette opération, une clée privée a été créé dans le répertoire de configuration du réseau et une clée publique a été ajouté dans le sous-répertoire **hosts**.

    $ ls /etc/tinc/loire/hosts/
    nouveauclient  serveur1  serveur2

##Inscription de la clé publique sur les serveurs

Le fichier contenant la clée publique (dans notre exemple */etc/tinc/loire/hosts/nouveauclient*) doit être fournis aux administrateurs du réseau tinc pour être déployée sur les serveurs. Ce n'est qu'après cette opération que le client pourra être autorisé à se connecter sur le réseau.

##Démarrage manuel du client tinc

Pour démarrer manuelle le réseau, une commande tinc est accessible :

    tincd -n loire

L'option **-n** permet de spécifier le réseau à démarrer manuellement (ici le réseau *loire*).

Une fois le réseau tinc démarré, une nouvelle interface ip virtuelle est accessible :

    $ ip addr
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue 
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
           valid_lft forever preferred_lft forever
    [...]
    4: loire@NONE: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 
        link/ether aa:dd:aa:dd:aa:dd brd ff:ff:ff:ff:ff:ff
        inet 10.0.0.100/24 brd 10.0.0.255 scope global 20team
           valid_lft forever preferred_lft forever

Le *4: loire@NONE* initie les informations liées au réseau configuré dans cet exemple.

##Inscription des réseaux à démarrer automatiquement

Dans le répertoire général de configuration de tinc, le fichier */etc/tinc/nets.boot* permet de démarrer automatiquement des réseaux lors de l'initialisation du service tinc.

Ce fichier contient un ligne par réseau à lancer au démarrage. Il suffit donc d'ajouter le nom du réseau que l'on souhaite démarrer par défaut pour qu'il soit lancé automatiquement.