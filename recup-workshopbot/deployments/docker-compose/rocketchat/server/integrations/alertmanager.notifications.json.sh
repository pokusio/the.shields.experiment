#!/bin/bash

# ---
export JSON_PAYLOAD="{ \
  \"alias\":\"El Pokuso Bot\", \
  \"emoji\":\":ghost::man_cartwheeling_light_skin_tone:\", \
  \"text\":\"Le NOUVEAU texte du Message Pokus %20%21%21%21%20%3A%29%20\", \
  \"alerts\": [ \
    { \
        \"labels\": { \
          \"alertname\":\"Alerte Pokus Niveau 3\", \
          \"instance\":\"old-pc-16gbram-asus-home\" \
        }, \
        \"annotations\": { \
          \"summary\": \"j'ai renversé du cantal fondu dans mon terminal ssh\", \
          \"severity\": \"dday\" \
        } \
    }, \
    { \
        \"labels\": { \
          \"alertname\":\"Alerte Pokus Niveau 2\", \
          \"instance\":\"pc-alienware-12gb-ram-home\" \
        }, \
        \"annotations\": { \
          \"summary\": \"j'ai coupé l'alimentation électrique de amnièrre inopportune\", \
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
                               \"alertname\":\"Alerte Pokus Niveau 3\", \
                               \"instance\":\"old-pc-16gbram-asus-home\" \
                             }, \
                             \"annotations\": { \
                               \"summary\": \"jai fait tomber ma bière sur le clavier\", \
                               \"severity\": \"dday\" \
                             } \
                         }, \
                         { \
                             \"labels\": { \
                               \"alertname\":\"Alerte Pokus Niveau 2\", \
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
    --data "${JSON_PAYLOAD}" https://chat.pok-us.io/hooks/SQuzrZGhBPE4pmqu3/HumJLpRKjWxFwKF3TQiNWvEwEfkhMEqPYZKxK7onKZtjHfZf | jq .



exit 0


"
\"alerts\": [ \
  { \
      \"labels\": { \
        \"alertname\":\"Alerte Pokus Niveau3\", \
        \"instance\":\"old-pc-16gbram-asus-home\" \
      }, \
      \"annotations\": { \
        \"summary\": \"j'ai tordu le filde souris trop longtemps\", \
      } \
  }, \
  { \
      \"labels\": { \
        \"alertname\":\"Alerte Pokus Niveau 2\", \
        \"instance\":\"pc-alienware-12gb-ram-home\" \
      }, \
      \"annotations\": { \
        \"summary\": \"oh purée on a plus de pâtes\", \
      } \
  } \
] \
"
