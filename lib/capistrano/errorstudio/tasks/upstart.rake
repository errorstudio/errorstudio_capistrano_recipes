namespace :upstart do
  desc "Generate cron scripts"
  task :generate_upstart_scripts do
    on roles(:web) do
      fetch(:upstart_scripts).each do |template|
        set(:upstart_filename,"#{fetch(:application)}_#{fetch(:rails_env)}_#{File.basename(template)}".gsub('.erb','.conf'))
        buffer = ERB.new(File.read(template)).result(binding)
        upload! StringIO.new(buffer), "#{shared_path}/#{fetch(:upstart_filename)}"
        execute "sudo mv -f #{shared_path}/#{fetch(:upstart_filename)} /etc/init/#{fetch(:upstart_filename)} && sudo chown root:root /etc/init/#{fetch(:upstart_filename)}"
      end
    end
  end
end
