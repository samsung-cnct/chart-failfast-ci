# Failfast-CI Chart

The failfast-ci chart is for installing the api server and worker pods for the [failfast-ci](https://github.com/samsung-cnct/failfast-api) github-gitlab integration tool. This tool is used for syncing github branches and pull requests to gitlab in order to use gitlab's CI tools and report the status of the CI run back to github.


## Installation

Installation of this chart depends on the [app registry](https://github.com/app-registry/appr-helm-plugin) helm plugin. Install it according to their readme.

### GitHub Configuration

To configure GitHub to use failfast-ci, add an application through _"Developer Settings"_, _"GitHub Apps"_.

1. Create _"New GitHub App"_
1. Give the app a name.
1. Add a homepage url. I use the url for our fork of failfast-ci.
1. Set the _"Webhook URL"_ to `http[s]://<your api server hostname>/api/v1/github_event`.
1. Add permissions:
   * Repository Administration: Read
   * Commit statuses: Read and Write
   * Deployments: Read and Write
   * Issues: Read and Write
   * Pull Requests: Read and Write
   * Repository Contents: Read and Write
   * Organization Members: Read
1. Subscribe to events:
   * Label
   * Repository
   * Deployment
   * Pull Request
   * Commit comment
   * Delete
   * Push
   * Public
   * Status
   * Deployment status
   * Pull request review
   * Pull request review comment
   * Create
   * Release
1. _"Where can this GitHub App be installed?"_

   Unless you want to make this app and its connected services available to the entirety of GitHub, set this to _"Only on this account"_.

1. Click _"Create GitHub app"_
1. Click _"Generate Private Key"_. This will download a PEM file. Make a note of its filename and download location.
1. Make a note of the GitHub Application ID found under the _"About"_ header labeled _"ID"_.
1. Double base64 encode the PEM file downloaded above, eg.:

   ```
   base64 -w0 <filename.pem> | base64 -w0 > /tmp/pemb64.b64
   ```

### GitLab Configuration

To configure GitLab to use failfast-ci, add a robot user, a group, and make the robot a master of the group.

1. From the _"Users"_ section of the _Admin Area_ create a _"New User"_.
1. Give it a _"Name"_, _"User Name"_, and _"Email"_.

   Note: with many email systems you can use an existing email address with the "+" notation for adding additional "sub-email" addresses, eg. `gitlab_admin+robot1@domain.dom`.

1. Uncheck _"Can Create Group"_.
1. _"Create User"_
1. Click on the _"Impersonation Tokens"_ heading.
1. Add a name for the application that will use this token, eg. `failfast-ci`. This name is an arbitrary string.
1. Check both _"api"_ and _"read_user"_.
1. Click _"Create impersonation token"_.
1. Save the Token shown for insertion into the Values

## Values

Add the necessary changes to your values.yaml for a helm deployment.

### API Section

Add the url for the failfast-ci api and any optional settings.

* api
  * image
    * repository: The repository uri for the api container image
    * tag: The api container image tag
    * pullPolicy: Use `"Always"` if not pinning versions or upgrades will not be picked up.
  * replicas: number of api servers needed to satisfy the request load
  * url: **Required** - The url at which the failfast-ci api will be listening for GitHub webhooks
  * resources: See inline comments

### Worker Section

* worker
  * image
    * repository: The repository uri for the worker container image
    * tag: The worker container image tag
    * pullPolicy: Use `"Always"` if not pinning versions or upgrades will not be picked up.
  * replicas: number of api servers needed to satisfy the job load
  * resources: See inline comments

### Redis Section

Add the url to connect to the redis server for message processing between the api server and the worker.

* redis
  * url: **Required** The url needed to connect to an installed redis server.

# GitHub Section

Add the Context, Integration Id, and Integration PEM for failfast-ci to interact with GitHub.

* github
  * context: **Required** The context is the group or user in which failfast-ci should operate.

    In `https://github.com/samsung-cnct/chart-failfast-ci` the context is `samsung-cnct`.

  * integrationId: **Required** The integration ID is the GitHub Application ID we recorded in the [GitHub Configuration](github-configuration) section above base64 encoded.
  * integrationPem: **Required** The double-base64 file we created in the [GitHub Configuration](github-configuration) section above (in the example named "/tmp/pemb64.b64").

### GitLab Section

Add the api link if not using the public gitlab, namespace, user, and token.

* gitlab
  * api: The url of your gitlab instance (defaults to https://gitlab.com).
  * namespace: **Required** The namespace is what GitHub calls context. It's the group or user in which failfast-ci should operate.

  In `https://gitlab.com/mygroup/myrepo` the namespace is `mygroup`.

  * user: **Required** The robot user created in the [GitLab Configuration](gitlab-configuration) section above.
  * token: **Required** The robot user token created in the [GitLab Configuration](gitlab-configuration) section above.

### Service

* service
  * name: The name of the kubernetes Service primitive. Defaults to "failfast-ci-api".
  * type: The kubernetes Service type. Defaults to "ClusterIP"

### Ingress

Enable this (recommended) unless you've set the Service type to LoadBalancer and configure it for your ingress server. Add your hostname and enable the correct annotations.

* ingress
  * enabled: Whether or not the ingress primitive is enabled. Default: false.
  * hosts: A list of hostnames for which the ingress controller should listen. Add an entry to this to your public facing hostname.
  * annotations: A list of annotatiuons. Common annotations include `kubernetes.io/ingress.class: nginx` to use the nginx ingress controller class, and `kubernetes.io/tls-acme: "true"` to use kube-lego for Let's Encrypt certificate generation and installation (requires tls).
  * tls: The list of tls entries to add
    * list items require a secretName (arbitrary unique string name) and hosts list. The hosts list should contain the list of hostnames for which the ingress controller should listen for tls connections.
>>>>>>> Create documenetation
