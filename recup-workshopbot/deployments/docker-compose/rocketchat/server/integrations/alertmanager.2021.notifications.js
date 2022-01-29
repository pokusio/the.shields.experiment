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
 *
 **/
const buildMessage = (requestContentObj) => {
  const min = Math.floor(requestContentObj.duration / 60);
  const sec = requestContentObj.duration - min * 60;

  let template = `Build [#${requestContentObj.number}](${requestContentObj.build_url})`;
  template += ` ([${requestContentObj.commit.substring(0, 7)}](${requestContentObj.compare_url})) of`
  template += ` ${requestContentObj.repository.owner_name}/${requestContentObj.repository.name}@${requestContentObj.branch}`;
  if(requestContentObj.pull_request) {
     let pr_url = `https://github.com/${requestContentObj.repository.owner_name}/`;
     pr_url += `${requestContentObj.repository.name}/pull/${requestContentObj.pull_request_number}`;
     template += ` in PR [#${requestContentObj.pull_request_number}](${pr_url})`;
  }
  template += ` by ${requestContentObj.author_name} ${requestContentObj.state} in ${min} min ${sec} sec`;

  let status_color = '#36A64F';
  if(requestContentObj.state !== 'passed') {
    status_color = '#A63636'
  }

  return {
    text: template,
    color: status_color
  };
};

class Script {
  process_incoming_request({ request }) {
    msg = buildMessage(request.content);

    return {
      content: {
        attachments: [
          {
            text: msg.text,
            color: msg.color
          }
        ]
      }
    };
  }
}
