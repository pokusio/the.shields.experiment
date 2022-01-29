#  Services

* https://gitea.pok-us.io : `Gitea`
* https://drone.pok-us.io : `Drone CI`
* https://vault.pok-us.io : `HashiCorp Vault`
* https://chat.pok-us.io : `Rocket Chat`
* https://bot.pok-us.io : `Pokus Hubot`

## Architecture

![Gitea Services Architecture](documentation/images/gitea/architecture.png)

#### start squence

* postgres db for vault, postgres db for drone, postgres db for gitea, and mongo db for rocket chat all start
* gitea starts, and the `deployments/docker-compose/gitea/oci/start.sh` script at container start, initializes the initial user and initial oauth2 app for `drone ci` integration.
* gitea has a healthcheck when gitea oauth2 application is ready
* wait for gitea to have finished the oauth2 application creation for drone integration, vault server starts, vault-client starts and initializes the vault, see `deployments/docker-compose/vault/oci/run.sh` script
* drone server waits for gitea healthcheck, and starts
* drone runner waits for drone server  to be up, and vault client to be finshed with initialization, again healthchecks, and both start
* rocket.chat and hubot wait for drone server to be up, and start

## References

* gitea :
  * https://docs.gitea.io/en-us/install-with-docker/
  * gitea ssh git : https://docs.gitea.io/en-us/install-with-docker/#ssh-container-passthrough
  * gitea ui themes :
    * https://docs.gitea.io/en-us/install-with-docker/#customization
    * https://docs.gitea.io/en-us/customizing-gitea/
    * https://github.com/TylerByte666/gitea-matrix-template
    * https://docs.gitea.io/en-us/config-cheat-sheet/#ui-ui
* drone:
  * https://docs.drone.io/server/storage/database/
  * https://docs.drone.io/
  * https://docs.drone.io/runner/extensions/vault/
