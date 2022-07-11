***This is just a proof of concept***

This assumes you are using the local-install-profile in isle-dc


To use the multisite-helper first clone the repo.

Next enter the multisite-helper directory.

Clone isle-dc repository and rename it: git clone https://github.com/Islandora-Devops/isle-dc.git

Clone another isle-dc repository: git clone https://github.com/Islandora-Devops/isle-dc.git

What you should have is a parent directory named multisite-helper with three files (Makefile, tls.yml, docker-compose.yml) and two project directories (isle-dc, and your_renamed_directory.)

In the multisite-helper directory run make download-default-certs

Make sure in each project directory your .env file that you created has a domain name and composer project name that is different than your other project.

Also make sure the include Traefik service variable is set to false.

Note: You may also need to put a traefik label for host rule in the following docker-compose files per project: activemq, blazegraph, fcrepo, fcrepo6, solr. Place the label below the entrypoint label in the file. This is an example for docker-compose.solr.yml (you need to change the service name to match the service referenced in the file):

- traefik.http.routers.${COMPOSE_PROJECT_NAME-isle-dc}-solr_http.rule=Host(`${DOMAIN}`)

In each project run make -B docker-compose.yml

Check the docker-compose.yml file that was created in each project and change the gateway settings located under networks at the very top of the file to: 

  driver: bridge  
  internal: false
  

Next run in each project's local-install-profile commands from make pull to docker-compose up -d --remove orphans. You can put a hash character in front of each line you don't want to run to disable them.

Then edit the docker-compose file in the multisite-helper directory and replace project1 in project1_default and project1_gateway to the name of your project. Ex. isle-dc_default and isle-dc_gateway.

Replace project1domain.traefik.me and project2domain.traefik.me to whatever the domain names are in your projects. Ex. islandora.traefik.me

In the multisite-helper directory run docker-compose up -d

The Traefik container should now be up and running.

Restart the drupal container in each project.

Finally run the rest of the local-install-profile commands in each project starting from docker-compose exec -T drupal with-contenv bash -lc 'composer install; chown -R nginx:nginx .'
