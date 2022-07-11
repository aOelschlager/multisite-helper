***This is just a proof of concept***

This assumes you are using the local-install-profile in isle-dc


# To use the multisite-helper first clone the repo.

Next enter the multisite-helper directory.

***This is using my forked repo of the isle-dc repo for a quicker setup. Instructions to use the isle-dc repo are after these***

For a quicker setup to demo you can clone the branch multi-project-example from my forked repo of isle-dc: git clone -b multi-project-example https://github.com/aOelschlager/isle-dc.git

Or if you have Windows and generate secrets does not work for you, clone this forked repo: git clone -b multi-project-windows https://github.com/aOelschlager/isle-dc.git

Rename the directory and clone again.

Change the domain name and composer project name in the env file located in the renamed directory (You have to copy the file from the sample.env file.)

Enter one of the project directories and run make local-part-one. Repeate this step in the other directory.

Then in the multisite-helper directory run make download-default-certs

Then edit the docker-compose file in the multisite-helper directory and replace project1 in project1_default and project1_gateway to the name of your project. Repeate for project2. Ex. isle-dc_default and isle-dc_gateway.

Replace project1domain.traefik.me and project2domain.traefik.me to whatever the domain names are in your projects. Ex. islandora.traefik.me

Save the docker-compose file.

In the multisite-helper directory run docker-compose up -d

In one of the project directories run make local-part-two. When finished repeate this step in the other project directory.

***This is using the isle-dc repo and a more manual setup***

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


