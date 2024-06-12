#!/bin/bash

set -e

# remove pre-existing server.pid file if it exists
if [ -f /home/chat_system_backend_user/chat_system/tmp/pids/server.pid ]; then
  rm /home/chat_system_backend_user/chat_system/tmp/pids/server.pid
fi

gem install bundler -v 2.4.22 --force
bundle install


# ensure that database service is accepting connections
  while ! timeout 1 bash -c "echo > /dev/tcp/development_db/3306";
do
 printf "Waiting 10 second until the database is receiving connections.."
  sleep 10
done


for i in {1..3}; do
 if rails db:migrate:status | grep -q 'up'; then
    echo "------Migrations already up to date---------"
    break
 else
    if rails db:migrate; then
      echo "Migration successful."
      break
    else
      echo "Migration failed, retrying in 20 seconds..."
      sleep 20
    fi
 fi
done


gem install overcommit -v 0.59.1
overcommit --install
overcommit --sign

exec "$@"
