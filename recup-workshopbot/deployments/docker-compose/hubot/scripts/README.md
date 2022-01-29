
Example treatment of SSH and GPG Secrets with secrethub and Circle CI (we will transpose to vault drone / vault nodejs)

```Yaml
environment:
  DRY_RELEASE_MAVEN_SETTINGS: 'secrethub://pokusio/cicd/pokusbot/infra/maven/dry-run/artifactory/settings.xml'
  NON_DRY_RELEASE_MAVEN_SETTINGS: 'secrethub://pokusio/cicd/pokusbot/infra/maven/dry-run/artifactory/settings.non.dry.run.xml'
  # NEXUS_STAGING_MAVEN_SETTINGS: 'secrethub://pokusio/cicd/pokusbot/infra/maven/settings.nexus-staging.xml'
  NEXUS_STAGING_MAVEN_SETTINGS: 'secrethub://pokusio/cicd/pokusbot/infra/maven/deploy.settings.nexus.xml'
  # S3_SERVICE_SECRET: "secrethub://pokusio/cicd/pokusbot/infra/zip-bundle-server/clever-cloud-s3/s3cmd/config"
  S3_SERVICE_AWS_ACCESS_KEY: "secrethub://pokusio/cicd/pokusbot/infra/zip-bundle-server/clever-cloud-s3/s3cmd/aws_access_key"
  S3_SERVICE_AWS_SECRET_KEY: "secrethub://pokusio/cicd/pokusbot/infra/zip-bundle-server/clever-cloud-s3/s3cmd/aws_secret_key"
  POKUSIO_GPG_PUB_KEY: 'secrethub://pokusio/cicd/pokusbot/gpg/armor_format_pub_key'
  POKUSIO_GPG_PRV_KEY: 'secrethub://pokusio/cicd/pokusbot/gpg/armor_format_private_key'
  GIT_USER_NAME: 'secrethub://pokusio/cicd/pokusbot/git/user/name'
  GIT_USER_EMAIL: 'secrethub://pokusio/cicd/pokusbot/git/user/email'
  GIT_SSH_PUB_KEY: 'secrethub://pokusio/cicd/pokusbot/git/ssh/public_key'
  GIT_SSH_PRIVATE_KEY: 'secrethub://pokusio/cicd/pokusbot/git/ssh/private_key'
  DOCKERHUB_USER_NAME: 'secrethub://pokusio/cicd/pokusbot/infra/dockerhub-user-name'
  DOCKERHUB_USER_TOKEN: 'secrethub://pokusio/cicd/pokusbot/infra/dockerhub-user-token'

steps:
  - secrethub/exec:
      command: |
                mkdir -p /opt/poku7io/.secrets/.gungpg
                echo $DRY_RELEASE_MAVEN_SETTINGS > /opt/poku7io/.secrets/dry.release.settings.xml
                echo $NON_DRY_RELEASE_MAVEN_SETTINGS > /opt/poku7io/.secrets/non.dry.release.settings.xml
                echo $NEXUS_STAGING_MAVEN_SETTINGS > /opt/poku7io/.secrets/nexus.staging.settings.xml
                mkdir -p /opt/poku7io/.secrets/.s3cmd
                # ${TEMP_S3_CMD_CONFIG}/.s3cmd/config  /opt/poku7io/.secrets/.s3cmd
                echo $S3_SERVICE_AWS_ACCESS_KEY > /opt/poku7io/.secrets/.s3cmd/aws_access_key
                echo $S3_SERVICE_AWS_SECRET_KEY > /opt/poku7io/.secrets/.s3cmd/aws_secret_key
                echo $POKUSIO_GPG_PUB_KEY > /opt/poku7io/.secrets/.gungpg/pokusbot.gpg.pub.key
                echo $POKUSIO_GPG_PRV_KEY > /opt/poku7io/.secrets/.gungpg/pokusbot.gpg.priv.key
                echo $GIT_USER_NAME > /opt/poku7io/.secrets/git_user_name
                echo $GIT_USER_EMAIL > /opt/poku7io/.secrets/git_user_email

                echo $GIT_SSH_PUB_KEY > /opt/poku7io/.secrets/git_ssh_pub_key
                echo $GIT_SSH_PRIVATE_KEY > /opt/poku7io/.secrets/git_ssh_private_key

                mkdir -p /opt/poku7io/.secrets/dockerhub
                echo $DOCKERHUB_USER_NAME > /opt/poku7io/.secrets/dockerhub/user_name
                echo $DOCKERHUB_USER_TOKEN > /opt/poku7io/.secrets/dockerhub/user_token
  - run:
      name: "Re-format GPG Keys"
      command: |
                # - # Re-format private and public GPG Keys
                export PUB_KEY_CONTENT=$(cat /opt/poku7io/.secrets/.gungpg/pokusbot.gpg.pub.key | awk -F '-----BEGIN PGP PUBLIC KEY BLOCK-----' '{print $2}' | awk -F '-----END PGP PUBLIC KEY BLOCK-----' '{print $1}')
                echo '-----BEGIN PGP PUBLIC KEY BLOCK-----' > /opt/poku7io/.secrets/.gungpg/pokusbot.gpg.pub.key
                echo "$PUB_KEY_CONTENT" | tr ' ' '\n' | tee -a /opt/poku7io/.secrets/.gungpg/pokusbot.gpg.pub.key
                sed -i '$ s/$/-----END PGP PUBLIC KEY BLOCK-----/' /opt/poku7io/.secrets/.gungpg/pokusbot.gpg.pub.key
                export PRIV_KEY_CONTENT=$(cat /opt/poku7io/.secrets/.gungpg/pokusbot.gpg.priv.key | awk -F '-----BEGIN PGP PRIVATE KEY BLOCK-----' '{print $2}' | awk -F '-----END PGP PUBLIC KEY BLOCK-----' '{print $1}')
                echo '-----BEGIN PGP PRIVATE KEY BLOCK-----' > /opt/poku7io/.secrets/.gungpg/pokusbot.gpg.priv.key
                echo "$PRIV_KEY_CONTENT" | tr ' ' '\n' | tee -a /opt/poku7io/.secrets/.gungpg/pokusbot.gpg.priv.key
                sed -i '$ s/$/-----END PGP PRIVATE KEY BLOCK-----/' /opt/poku7io/.secrets/.gungpg/pokusbot.gpg.priv.key
  - run:
      name: "Re-format SSH Keys used for Git config"
      command: |
                echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
                echo "DEBUG : content of the SSH PRIVATE KEY FILE BEFORE RE-FORMATING : "
                echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
                cat /opt/poku7io/.secrets/git_ssh_private_key
                echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
                # - # Re-format private and public SSH Keys used for Git config
                # export SSH_PUB_KEY_CONTENT=$(cat /opt/poku7io/.secrets/git_ssh_pub_key | awk -F '-----BEGIN RSA PRIVATE KEY-----' '{print $2}' | awk -F '-----END RSA PRIVATE KEY-----' '{print $1}')
                # echo '-----BEGIN RSA PRIVATE KEY-----' > /opt/poku7io/.secrets/git_ssh_pub_key
                # echo "$SSH_PUB_KEY_CONTENT" | tr ' ' '\n' | tee -a /opt/poku7io/.secrets/git_ssh_pub_key
                # sed -i '$ s/$/-----END RSA PRIVATE KEY-----/' /opt/poku7io/.secrets/git_ssh_pub_key
                # -->> SSH Public Key is a one liner, so no need to re-format this buddy

                export SSH_PRIV_KEY_CONTENT=$(cat /opt/poku7io/.secrets/git_ssh_private_key | awk -F '-----BEGIN RSA PRIVATE KEY-----' '{print $2}' | awk -F '-----END RSA PRIVATE KEY-----' '{print $1}')
                echo '-----BEGIN RSA PRIVATE KEY-----' > /opt/poku7io/.secrets/git_ssh_private_key
                echo "$SSH_PRIV_KEY_CONTENT" | tr ' ' '\n' | tee -a /opt/poku7io/.secrets/git_ssh_private_key
                sed -i '$ s/$/-----END RSA PRIVATE KEY-----/' /opt/poku7io/.secrets/git_ssh_private_key
                echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
                echo "DEBUG : content of the SSH PRIVATE KEY FILE AFTER RE-FORMATING : "
                echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
                cat /opt/poku7io/.secrets/git_ssh_private_key
                echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
                chmod 644 /opt/poku7io/.secrets/git_ssh_private_key
                mkdir -p ~/.ssh
                rm -f ~/.ssh/known_hosts
                touch ~/.ssh/known_hosts
                ssh-keygen -R github.com
                ssh-keyscan -H github.com >> ~/.ssh/known_hosts
                ssh -Ti /opt/poku7io/.secrets/git_ssh_private_key git@github.com || true
```

* and a pipeline job step to run the GIT CONFIG with SSH (an later GPG) config, using th secrets fetched from vault :


```Yaml
- run:
    name: "Git configuration"
    command: |
              ls -allh /opt/poku7io/.secrets/git_user_name
              ls -allh /opt/poku7io/.secrets/git_user_email
              export GIT_USER_NAME=$(cat /opt/poku7io/.secrets/git_user_name)
              export GIT_USER_EMAIL=$(cat /opt/poku7io/.secrets/git_user_email)

              echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
              echo "      SSH Configuration for GIT"
              echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
              export LOCAL_SSH_PUBKEY="${HOME}/.ssh.pok-us.io/id_rsa.pub"
              export LOCAL_SSH_PRVIKEY="${HOME}/.ssh.pok-us.io/id_rsa"
              export GIT_SSH_COMMAND='ssh -i ~/.ssh.pok-us.io/id_rsa'
              mkdir -p ${HOME}/.ssh.pok-us.io/
              cp /opt/poku7io/.secrets/git_ssh_pub_key ${HOME}/.ssh.pok-us.io/id_rsa.pub
              cp /opt/poku7io/.secrets/git_ssh_private_key ${HOME}/.ssh.pok-us.io/id_rsa
              chmod 700 "${HOME}/.ssh.pok-us.io/"
              chmod 644 "${LOCAL_SSH_PUBKEY}"
              chmod 600 "${LOCAL_SSH_PRVIKEY}"
              ssh-add -D
              echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
              # echo "DEBUG : content of the SSH PRIVATE KEY FILE : "
              echo "SSH Configuration for GIT"
              echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
              # cat ${LOCAL_SSH_PRVIKEY}
              # echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
              ssh-add "${LOCAL_SSH_PRVIKEY}"
              mkdir -p ~/.ssh
              rm -f ~/.ssh/known_hosts
              touch ~/.ssh/known_hosts
              ssh-keygen -R github.com
              ssh-keyscan -H github.com >> ~/.ssh/known_hosts
              ssh -Ti ~/.ssh.pok-us.io/id_rsa git@github.com || true
              echo "# -+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+- #"
              echo "[$0 - Git config] [GIT_USER_NAME=[${GIT_USER_NAME}]] "
              echo "[$0 - Git config] [GIT_USER_EMAIL=[${GIT_USER_EMAIL}]] "
              echo "[$0 - Git config] [GIT_SSH_COMMAND=[${GIT_SSH_COMMAND}]] "
              if [ "x${GIT_USER_NAME}" == "x" ]; then
                echo "[$0 - Git config] You did not set the [GIT_USER_NAME] env. var."
                Usage
                exit 1
              fi;
              if [ "x${GIT_USER_EMAIL}" == "x" ]; then
                echo "[$0 - Git config] The [GIT_USER_EMAIL] env. var. was not properly set from secret manager"
                Usage
                exit 1
              fi;
              if [ "x${GIT_USER_GPG_SIGNING_KEY}" == "x" ]; then
                echo "[$0 - Git config] the [GIT_USER_GPG_SIGNING_KEY] env. var. was not set, So [${GIT_USER_NAME}]] won't be signed"
                git config --global commit.gpgsign false
              else
                echo "[$0 - Git config] [${GIT_USER_NAME}] commits will be signed with signature [${GIT_USER_GPG_SIGNING_KEY}]"
                git config --global commit.gpgsign true
                git config --global user.signingkey ${GIT_USER_GPG_SIGNING_KEY}
              fi;
              git config --global user.name "${GIT_USER_NAME}"
              git config --global user.email "${GIT_USER_EMAIL}"
              git config --global --list
              echo "[$0 - Git config] completed "
```
