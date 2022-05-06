import Config

if File.exists?("config/dev_proxy.secret.exs") do
  import_config "dev_proxy.secret.exs"
end
