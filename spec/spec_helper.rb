set :path, '$PATH:/usr/bin'

def os_version
  command("cat /etc/fedora-release").stdout
end
