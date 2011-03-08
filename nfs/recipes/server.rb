package "nfs-kernel-server"

service "nfs-kernel-server" do
  service_name "nfs-kernel-server"
  restart_command "/usr/sbin/invoke-rc.d nfs-kernel-server restart && sleep 1"
  supports value_for_platform(
    "default" => { "default" => [:restart] }
  )
  action :enable
end

template "/etc/exports" do
  source "exports.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, "service[nfs-kernel-server]"
end
