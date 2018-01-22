echo "=============================="
echo " td-agent Installation Script "
echo "=============================="
echo "This script requires superuser access to install apt packages."
echo "You will be prompted for your password by sudo."

# clear any previous sudo permission
sudo -k

# run inside sudo
sudo sh <<SCRIPT
  curl https://packages.treasuredata.com/GPG-KEY-td-agent | apt-key add -

  # add treasure data repository to apt
  echo "deb http://packages.treasuredata.com/2/ubuntu/xenial/ xenial contrib" > /etc/apt/sources.list.d/treasure-data.list

  # update your sources
  apt-get update

  # install the toolbelt
  apt-get install -y td-agent --allow-unauthenticated

SCRIPT

# message
echo ""
echo "Installation completed. Happy Logging!"
echo ""
echo "NOTE: In case you need any of these:"
echo "  1) security tested binary with a clear life cycle management"
echo "  2) advanced monitoring and management"
echo "  3) support SLA"
echo "Please check Fluentd Enterprise (https://www.treasuredata.com/fluentd/)."
