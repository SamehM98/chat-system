# Introduction

This is API app for a chat system with ability to get, create, update Applications, Chats and Messages.

# Environment

- Docker
- Ruby on Rails
- Sidekiq
- Elasticsearch

  # Getting started

  - Make sure you have docker, docker compose installed.
  - Clone the project ` git clone https://github.com/SamehM98/chat-system.git `
  - If you user ID is not 1000, as assumed in the env, you should run ``` sed  -i "/APP_USER_ID=/c\APP_USER_ID=$(id -u)" .env ```.
  - Run the project by running the docker container ` docker compose up `

  # Accessing the application

  The base URL for the application is ` http://localhost:3000 `
  You can access the sidekiq dashboard using ` http://localhost:3000/sidekiq/scheduled `
