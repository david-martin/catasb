# CATalogASB EC-2 Deployment

catasb is a collection of playbooks to create an OpenShift environment with a Service Catalog & Ansible Service Broker in EC-2.

### Overview
These playbooks will:
  * Create a public VPC if it does not exist
  * Create a security group if it does not exist
  * Create an instance with a specific Name if does not exist
  * Associate an elastic ip to instance
  * Configure a hostname with elastic ip through Route53
  * Setup Origin through `oc cluster up`
  * Install Service Catalog on Origin
  * Install Ansible Service Broker on Origin

### Pre-Reqs
  * Ansible needs to be installed so its source code is available to Python.
    * Check to see if Ansible modules are available to Python
          $ python -c "import ansible;print(ansible.__version__)"
          2.2.2.0
    * MacOS requires Ansible to be installed from `pip` and not `brew`
          $ python -c "import ansible;print(ansible.__version__)"
          Traceback (most recent call last):
          File "<string>", line 1, in <module>
          ImportError: No module named ansible

          brew uninstall ansible
          pip install ansible

          $ python -c "import ansible;print(ansible.__version__)"
          2.2.2.0
  * Install python dependencies (This is needed for python2. Use pip2 if using python3)
        $ pip install boto boto3 six
  * Configure a SSH Key in your AWS EC-2 account for the given region
  * Create a hosted zone in Route53
  * Set these environment variables:
    * AWS_ACCESS_KEY_ID
    * AWS_SECRET_ACCESS_KEY
    * AWS_SSH_PRIV_KEY_PATH  - Path to your private ssh key to use for the ec2 instances

### Execute
  * Navigate to the `ec2` folder
        $ cd catasb/ec2
  * Edit the variables file `ec2/common_vars`
    * Note the following and update:
      * AWS_SSH_KEY_NAME="splice"
      * TARGET_DNS_ZONE="ec2.dog8code.com"
        * Needs to match a hosted zone entry in your Route53 account, we will create a subdomain under it for the ec2 instance
  * Create our infrastructure in ec2 if it doesn't exist
        $ ./run_create_infrastructure.sh
  * Run the setup script
        $ ./run_setup_environment.sh
  * Open a Web Browser
    * Visit: `https://apiserver-service-catalog.USERNAME.ec2.dog8code.com`
      * Accept the SSL certificate for the apiserver-service-catalog endpoint
      * Ignore the text that appears and proceed to the main OpenShift URL next
      * Note: must accept the new SSL cert, each time you reset your OpenShift environment
    * Visit: `https://<USERNAME>.ec2.dog8code.com:8443`
      * Where `<USERNAME>` is the value of `whoami` when you launched `run_setup_environment.sh`

### Cleanup

* To terminate the ec2 instance and cleanup the associated EBS volumes run the below
      $ ./terminate_instance.sh

* To reset the ec2 instance back to clean origin and deployment of ASB and Service Catalog run the below
      $ ./reset_environment.sh

### Tested with
  * ansible 2.2.2.0 & 2.3.0.0
    * Problems were seen using ansible 2.0
