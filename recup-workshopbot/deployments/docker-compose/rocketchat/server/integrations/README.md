

* Create the `Rocket Chat` **_Integration_** of type "**_Incoming WebHook_**" :
  * create an avatar for yoru user, using https://getavataaars.com/ (no login required)
  * Add the script [`alertmanager.notifications.js`](./alertmanager.notifications.js) as Script for that Incoming Webhook
  * retrieve the WebHook URL, which is given back by RocketChat API
* Create the ROckat Incoming webhook can be automated using `RocketChat API`, see https://developer.rocket.chat/reference/api/rest-api/endpoints/team-collaboration-endpoints/integration-endpoints/create
* and execute the below script after setting the value of `POKUS_WEBHOOK_URL` to the `WebHook` you just created's URL :


curl -X POST -H 'Content-Type: application/json' --data '{"alias":"pormetheus","emoji":":ghost:","avatar":"https://avataaars.io/?avatarStyle=Circle&topType=Hat&accessoriesType=Prescription01&facialHairType=BeardMajestic&facialHairColor=BrownDark&clotheType=BlazerShirt&eyeType=WinkWacky&eyebrowType=UpDownNatural&mouthType=Grimace&skinColor=Light","text":"Example message","attachments":[{"title":"Rocket.Chat","title_link":"https://rocket.chat","text":"Rocket.Chat, the best open source chat","image_url":"/images/integration-attachment-example.png","color":"#764FA5"}]}'
```bash
#!/bin/bash


# export POKUS_WEBHOOK_URL=https://chat.pok-us.io/hooks/SQuzrZGhBPE4pmqu3/HumJLpRKjWxFwKF3TQiNWvEwEfkhMEqPYZKxK7onKZtjHfZf
export POKUS_WEBHOOK_URL=<your webhook s url>
export POKUS_WEBHOOK_URL=https://chat.pok-us.io/hooks/EyjAgupvk4v58ZQCy/GMDWjS9i7pRFizqmGdMkDkG5vhTbSCEfhdJAcdjPxMC2numH
export MESSAGE_ENVOYE=""
# ---
export JSON_PAYLOAD="{ \
  \"alias\":\"El Pokuso Bot\", \
  \"emoji\":\":ghost: :man_cartwheeling_light_skin_tone:\", \
  \"text\":\"Le NOUVEAU texte du Message Pokus %20%21%21%21%20%3A%29%20\", \
  \"alerts\": [ \
    { \
        \"labels\": { \
          \"alertname\":\"putain_mais_quel_bordel_niveau3\", \
          \"instance\":\"old-pc-16gbram-asus-home\" \
        }, \
        \"annotations\": { \
          \"summary\": \"jai fait tomber ma bière sur le clavier\", \
          \"severity\": \"dday\" \
        } \
    }, \
    { \
        \"labels\": { \
          \"alertname\":\"alerte-pokus_niveau3\", \
          \"instance\":\"old-pc-16gbram-asus-home\" \
        }, \
        \"annotations\": { \
          \"summary\": \"jai fait tomber ma bière sur le clavier\", \
          \"severity\": \"dday\" \
        } \
    }, \
    { \
        \"labels\": { \
          \"alertname\":\"alerte-pokus_niveau2\", \
          \"instance\":\"pc-alienware-12gb-ram-home\" \
        }, \
        \"annotations\": { \
          \"summary\": \"il y a eut un court-jus et le fusible de l'alim du pc a sauté\", \
          \"severity\": \"low\" \
        } \
    } \
  ], \
  \"attachments\": [ \
                     { \
                       \"title\":\"Pokus.Chat\", \
                       \"title_link\":\"https://chat.pok-us.io\", \
                       \"text\":\"Le NOUVEAU message DE POKUS%20%21%21%21%20%3A%29%20 Le NOUVEAU message DE POKUS %20%21%21%21%20%3A%29%20 Le NOUVEAU message DE POKUS %20%21%21%21%20%3A%29%20\", \
                       \"alerts\": [ \
                         { \
                             \"labels\": { \
                               \"alertname\":\"alerte-pokus_niveau3\", \
                               \"instance\":\"old-pc-16gbram-asus-home\" \
                             }, \
                             \"annotations\": { \
                               \"summary\": \"jai fait tomber ma bière sur le clavier\", \
                               \"severity\": \"dday\" \
                             } \
                         }, \
                         { \
                             \"labels\": { \
                               \"alertname\":\"alerte-pokus_niveau2\", \
                               \"instance\":\"pc-alienware-12gb-ram-home\" \
                             }, \
                             \"annotations\": { \
                               \"summary\": \"il y a eut un court-jus et le fusible de l'alim du pc a sauté\", \
                               \"severity\": \"low\" \
                             } \
                         } \
                       ], \
                       \"image_url\":\"/images/integration-attachment-example.png\", \
                       \"color\":\"#764FA5\" \
                     } \
                   ] \
                 }"


# export JSON_PAYLOAD="{ \
#
# }"

echo "# -- -- -- -- -- -- -- #"
echo "# -- JSON_PAYLOAD #"
echo "# -- -- -- -- -- -- -- #"
echo "${JSON_PAYLOAD}" | jq .
echo "# -- -- -- -- -- -- -- #"


curl --insecure -X POST \
    -H 'Content-Type: application/json' \
    --data "${JSON_PAYLOAD}" ${POKUS_WEBHOOK_URL} | jq .


```
