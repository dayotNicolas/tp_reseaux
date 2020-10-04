## Déploiement simple

Pour déployer une nouvelle VM pré-configurée, on édite le fichier Vagrantfile comme suivant:

```
Vagrant.configure("2")do|config|
  config.vm.box="centos/7"

  ## Les 3 lignes suivantes permettent d'éviter certains bugs et/ou d'accélérer le déploiement. Gardez-les tout le temps sauf contre-indications.
  # Ajoutez cette ligne afin d'accélérer le démarrage de la VM (si une erreur 'vbguest' est levée, voir la note un peu plus bas)
  config.vbguest.auto_update = false
  # Désactive les updates auto qui peuvent ralentir le lancement de la machine
  config.vm.box_check_update = false
  # La ligne suivante permet de désactiver le montage d'un dossier partagé (ne marche pas tout le temps directement suivant vos OS, versions d'OS, etc.)
  config.vm.synced_folder ".", "/vagrant", disabled: true
  config.vm.network "private_network", ip: "192.168.2.11"
  config.vm.provision "shell", path: "script_vagrant.sh"
  config.vm.hostname = "node1.tp2.b2"
  config.vm.provider :virtualbox do |vb|
  # Don't boot with headless mode
  #   vb.gui = true
  #
  # Use VBoxManage to customize the VM. For example to change memory:
  vb.customize ["modifyvm", :id, "--memory", "1000", "--cpus", "2"]
  vb.name = "tp2_VM"
  end
end
```

On a même édité un script pour installer vim au boot de la machine :

```
#!/bin/bash
#DAYOT nicolas
#script install au boot vm


sudo yum install -y vim
```

## Re-package

Fait....

## Multi-node deployment

Voici mon vagrantFile pour configurer node1 et node2 :

```
  config.vm.box="centos7-custom"

  ## Les 3 lignes suivantes permettent d'éviter certains bugs et/ou d'accélérer le déploiement. Gardez-les tout le temps sauf contre-indications.
  # Ajoutez cette ligne afin d'accélérer le démarrage de la VM (si une erreur 'vbguest' est levée, voir la note un peu plus bas)
  config.vbguest.auto_update = false
  # Désactive les updates auto qui peuvent ralentir le lancement de la machine
  config.vm.box_check_update = false
  # La ligne suivante permet de désactiver le montage d'un dossier partagé (ne marche pas tout le temps directement suivant vos OS, versions d'OS, etc.)
  config.vm.synced_folder ".", "/vagrant", disabled: true
  file_to_disk = 'VagrantDisk.vdi'
  file_to_disk2 = 'VagrantDisk2.vdi'

  config.vm.define "node1" do |node1|
    node1.vm.network "private_network", ip: "192.168.2.11"
    node1.vm.hostname = "node1.tp2.b2"
    node1.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.name = "node1.tp2.b2"
    end
  unless File.exist?(file_to_disk)
    node1.vm.provider "virtualbox" do |vb|
      vb.customize ['createhd', '--filename', file_to_disk, '--size', 5 * 1024]
      vb.customize ['storageattach', :id, '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
     end
    end
  end

  config.vm.define "node2" do |node2|
    node2.vm.network "private_network", ip: "192.168.2.12"
    node2.vm.hostname = "node2.tp2.b2"
    node2.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.name = "node2.tp2.b2"
    end
  unless File.exist?(file_to_disk2)
    node2.vm.provider "virtualbox" do |vb|
      vb.customize ['createhd', '--filename', file_to_disk2, '--size', 5 * 1024]
      vb.customize ['storageattach', :id, '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk2]
     end
    end
  end
end
```

## Automation here we (slowly) come

Ici, le but est de reproduire les configurations du tp1, mais en automatisant le tout grâce à vagrant. J'espère que tout fonctionnera bien pour toi, j'ai eu pas mal de difficultées à faire cette partie, je n'ai fait aucune vérification (de fichiers ou quoi) sur mon script. Je n'ai pas put faire la dernière partie sur netData car j'ai pas réussi à décomposer la ligne d'installation que tu nous avais fourni et elle ne foncionnait pas en l'état.

Pour ce faire, voici mon VagrantFile :

```
Vagrant.configure("2")do|config|
  config.vm.box="centos7-custom"

  ## Les 3 lignes suivantes permettent d'éviter certains bugs et/ou d'accélérer le déploiement. Gardez-les tout le temps sauf contre-indications.
  # Ajoutez cette ligne afin d'accélérer le démarrage de la VM (si une erreur 'vbguest' est levée, voir la note un peu plus bas)
  config.vbguest.auto_update = true
  # Désactive les updates auto qui peuvent ralentir le lancement de la machine
  config.vm.box_check_update = false
  # La ligne suivante permet de désactiver le montage d'un dossier partagé (ne marche pas tout le temps directement suivant vos OS, versions d'OS, etc.)
  config.vm.synced_folder ".", "/vagrant"
  file_to_disk = 'VagrantDisk.vdi'
  file_to_disk2 = 'VagrantDisk2.vdi'

  config.vm.define "node1" do |node1|
    node1.vm.network "private_network", ip: "192.168.2.11"
    node1.vm.hostname = "node1.tp2.b2"
    node1.vm.provision "shell", path: "script_partie4.sh"
    node1.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.name = "node1.tp2.b2"
    end
  unless File.exist?(file_to_disk)
    node1.vm.provider "virtualbox" do |vb|
      vb.customize ['createhd', '--filename', file_to_disk, '--size', 5 * 1024]
      vb.customize ['storageattach', :id, '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
     end
    end
  end

  config.vm.define "node2" do |node2|
    node2.vm.network "private_network", ip: "192.168.2.12"
    node2.vm.hostname = "node2.tp2.b2"
    node2.vm.provision "shell", path: "script_node2.sh"
    node2.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--memory", "1024"]
      vb.name = "node2.tp2.b2"
    end
  unless File.exist?(file_to_disk2)
    node2.vm.provider "virtualbox" do |vb|
      vb.customize ['createhd', '--filename', file_to_disk2, '--size', 5 * 1024]
      vb.customize ['storageattach', :id, '--storagectl', 'IDE', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk2]
     end
    end
  end
end
```

On remarque, dans le fichier, l'execution de plusieurs scripts. "script_partie4.sh" est le script qui va paramétrer la première machine (node1) :

```
#!/bin/bash
#Dayot  Nicolas
# script paramètrage de machine virtuelle avec nginx

useradd admin -m
useradd backup -m

usermod -aG wheel admin
usermod -aG wheel backup

useradd web -M -s /sbin/nologin

openssl req -new -newkey rsa:2048 -days 365 -nodes -x509 -keyout server.key -out /tmp/server.crt -subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=node1.tp2.b2"

mv server.key /etc/pki/tls/private/node1.tp1.b2.key
chmod 400 /etc/pki/tls/private/node1.tp1.b2.key
chown web:web /etc/pki/tls/private/node1.tp1.b2.key

mv /tmp/server.crt /etc/pki/tls/certs/node1.tp1.b2.crt
chmod 444 /etc/pki/tls/certs/node1.tp1.b2.crt
chown web:web /etc/pki/tls/certs/node1.tp1.b2.crt

cp /etc/pki/tls/certs/node1.tp1.b2.crt /usr/share/pki/ca-trust-source/
update-ca-trust

mkdir /srv/site1
mkdir /srv/site2
echo '<h1>Hello from site 1</h1>' | tee /srv/site1/index.html
echo '<h1>Hello from site 2</h1>' | tee /srv/site2/index.html
chown web:web /srv/site1 -R
chmod 700 /srv/site1 /srv/site2
chmod 400 /srv/site1/index.html /srv/site2/index.html

mv /vagrant/nginx.conf /etc/nginx
systemctl restart nginx
echo "192.168.2.12 node2.tp2.b2" >> /etc/hosts

iptables -A INPUT -p tcp -i eth1 --dport 443 -j ACCEPT

mv /vagrant/script_save.sh /etc/cron.hourly/
chmod 700 /etc/cron.hourly/script_save.sh
chown backup:backup /etc/cron.hourly/script_save.sh
```

"script_node2.sh" est constitué d'une seule ligne pour identifier node1 à traver le fichier hosts :

```
echo "192.168.2.11 node1.tp2.b2" >> /etc/hosts
```

Afin que le tout fonctionne, un fichier nginx.conf doit se trouver dans le dossier vagrant sur la machine hôte qui répond au patron suivant :

```
# For more information on configuration, see:
#   * Official English Documentation: http://nginx.org/en/docs/
#   * Official Russian Documentation: http://nginx.org/ru/docs/

user web;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  node1.tp1.b2;
        root         /srv;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location /site1 {
                alias /srv/site1;
        }

        location /site2 {
                alias /srv/site2;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }

# Settings for a TLS enabled server.

    server {
        listen       443 ssl http2 default_server;
        listen       [::]:443 ssl http2 default_server;
        server_name  node1.tp1.b2;
        root         /srv;

        ssl_certificate "/etc/pki/tls/certs/node1.tp1.b2.crt";
        ssl_certificate_key "/etc/pki/tls/private/node1.tp1.b2.key";
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  10m;
        ssl_ciphers HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers on;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location /site1 {
                alias /srv/site1;
        }

        location /site2 {
                alias /srv/site2;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
}
```
