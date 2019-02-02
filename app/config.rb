class Config
  extend Dry::Configurable

  setting :database, reader: true do
    setting :name, ENV['WATCHMEN_DATABASE_NAME'] || 'watchmen_database'
    setting :credentials do
      setting :host, ENV['WATCHMEN_DATABASE_HOST'] || 'localhost'
      setting :port, ENV['WATCHMEN_DATABASE_PORT'] || '8086'
      setting :username, ENV['WATCHMEN_DATABASE_USERNAME']
      setting :password, ENV['WATCHMEN_DATABASE_PASSWORD']
    end
  end
end
