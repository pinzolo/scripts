#! /bin/sh

if [ $# -eq 0 ]; then
  echo "tell me your plugin name"
  exit 1
fi

# set your language
LANG="ja"

PLUGIN_NAME=$1
REDMINE_VERSION="2.3.1"

mkdir $PLUGIN_NAME
cd ${PLUGIN_NAME}
#wget http://rubyforge.org/frs/download.php/76933/redmine-${REDMINE_VERSION}.tar.gz
cp ~/archives/redmine/redmine-${REDMINE_VERSION}tar.gz .
tar xvf redmine-${REDMINE_VERSION}.tar.gz
cd redmine-${REDMINE_VERSION}
cat > config/database.yml <<_EOS_
development:
  adapter: sqlite3
  database: db/redmine_dev.db

test:
  adapter: sqlite3
  database: db/redmine_test.db
_EOS_

bundle install --path vendor/bundle --without rmagick
bundle exec rake generate_secret_token
bundle exec rake db:migrate
bundle exec rake redmine:load_default_data REDMINE_LANG=${LANG}
bundle exec rails g redmine_plugin ${PLUGIN_NAME}

cd plugins/${PLUGIN_NAME}
git init .
git add .
git commit -m "initialized"
