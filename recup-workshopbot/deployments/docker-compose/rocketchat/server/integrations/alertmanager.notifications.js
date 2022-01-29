/**
 * exported Script
 * globals console,_,s, HTTP
 *
 **/

/**
 * Global Helpers
 *
 * console - A normal console instance
 * _       - An underscore instance
 * s       - An underscore string instance
 * (Only for OutGoing WebHooks, not for Incoming WebHooks) HTTP    - The Meteor HTTP object to do sync http calls
 *
 **/


class Script {

  process_incoming_request({
    request
  }) {
    console.log(request.content);

    console.log(`# -- Allooo C'est JBL + JBL + JBL + JBL + JBL + JBL + JBL + JBL`);
    console.log(`# -- Allooo C'est JBL + JBL + JBL + JBL + JBL + JBL + JBL + JBL`);
    console.log(`# -- Allooo C'est JBL + JBL + JBL + JBL + JBL + JBL + JBL + JBL`);
    console.log(`# -- Allooo C'est JBL + JBL + JBL + JBL + JBL + JBL + JBL + JBL`);
    console.log(`        Structure of the [request.content] Object : `);
    console.log(JSON.stringify(request.content, null, ' '));
    console.log(request.content);
    console.log(`# -- Allooo C'est JBL + JBL + JBL + JBL + JBL + JBL + JBL + JBL`);
    console.log(`        Structure of the full[request] Object : `);
    console.log(JSON.stringify(request, null, ' '));
    console.log(`# -- Allooo C'est JBL + JBL + JBL + JBL + JBL + JBL + JBL + JBL`);
    console.log(`# -- Allooo C'est JBL + JBL + JBL + JBL + JBL + JBL + JBL + JBL`);
    console.log(`# -- Allooo C'est JBL + JBL + JBL + JBL + JBL + JBL + JBL + JBL`);

    var alertColor = "warning";
    if (request.content.status == "resolved") {
      alertColor = "good";
    } else if (request.content.status == "firing") {
      alertColor = "danger";
    }

    let finFields = [];
    for (i = 0; i < request.content.alerts.length; i++) {
      var endVal = request.content.alerts[i];
      var elem = {
        title: "alertname: " + endVal.labels.alertname,
        value: "*instance:* " + endVal.labels.instance,
        short: false
      };

      finFields.push(elem);

      if (!!endVal.annotations.summary) {
        finFields.push({
          title: "summary",
          value: endVal.annotations.summary
        });
      }

      if (!!endVal.annotations.severity) {
        finFields.push({
          title: "severity",
          value: endVal.annotations.severity
        });
      }

      if (!!endVal.annotations.description) {
        finFields.push({
          title: "description",
          value: endVal.annotations.description
        });
      }
    }

    return {
      content: {
        username: "Prometheus Alert",
        attachments: [{
          color: alertColor,
          title_link: request.content.externalURL,
          title: "Prometheus notification",
          fields: finFields
        }]
      }
    };

    return {
      error: {
        success: false
      }
    };
  } // End of   process_incoming_request({ request })
}
