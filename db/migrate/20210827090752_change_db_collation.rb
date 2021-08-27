class ChangeDbCollation < ActiveRecord::Migration[6.1]
  execute "ALTER DATABASE `#{ActiveRecord::Base.connection.current_database}` CHARACTER SET utf8 COLLATE utf8_general_ci;"
end
