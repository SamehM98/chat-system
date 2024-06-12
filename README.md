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

# API Documentation

### Applications
#### Creating an application

- Endpoint: `POST api/v1/applications/`
- Body:
  ```json
  {
    "name": "Application 101"
  }
  ```
- Response
  ```json
  {
    "token": "Mxw6tenzvKxS1ndVNvxG8NvZ",
    "name": "Application 101",
    "chats_count": 0,
    "created_at": "2024-06-12T20:36:30.094Z",
    "updated_at": "2024-06-12T20:36:30.094Z"
  }
  ```
#### Getting an application

- Endpoint: `GET api/v1/applications/{token}`
- Response
  ```json
  {
    "token": "Mxw6tenzvKxS1ndVNvxG8NvZ",
    "name": "Application 101",
    "chats_count": 0,
    "created_at": "2024-06-12T20:36:30.094Z",
    "updated_at": "2024-06-12T20:36:30.094Z"
  }
  ```

#### Updating an application

- Endpoint: `PUT /api/v1/applications/{token}`
- Body:
  ```json
  {
    "name": "Application 102"
  }
  ```
- Response
  ```json
  {
    "token": "Mxw6tenzvKxS1ndVNvxG8NvZ",
    "name": "Application 102",
    "chats_count": 0,
    "created_at": "2024-06-12T20:36:30.094Z",
    "updated_at": "2024-06-12T20:36:30.094Z"
  }
  ```

### Chats
#### Creating a chat

- Endpoint `POST /api/v1/applications/{token}/chats`
- Response
```json
 {
    "chat_number": 1
 }
````

#### Getting a chat
- Endpoint ` GET /api/v1/applications/{token}/chats/{chat_number} `
- Response
```json
{
    "chat_number": 1,
    "messages_count": 0,
    "created_at": "2024-06-12T20:51:14.432Z",
    "updated_at": "2024-06-12T20:51:14.432Z"
}
```

#### Listing all chats of an app
- Endpoint ` GET /api/v1/applications/{token}/chats/ `
- Response
```json
[
  {
    "chat_number": 1,
    "messages_count": 0,
    "created_at": "2024-06-12T20:51:14.432Z",
    "updated_at": "2024-06-12T20:51:14.432Z"
  }
]
```

### Messages

#### Creating a message
- Endpoint ` POST /api/v1/applications/{token}/chats/{chat_number}/messages `
- Body:
```json
  {
      "body": "This is a message"
  }
```
- Response
```json
{
    "number": 1,
    "body": "This is a message"
}
```

#### Updating a message
- Endpoint ` PUT /api/v1/applications/{token}/chats/{chat_number}/messages/{message_number} `
- Body:
```json
  {
      "body": "This is a message updated"
  }
```
- Response
```json
{
    "number": 1,
    "body": "This is a message updated"
}
```

#### Getting a single message
- Endpoint ` GET /api/v1/applications/{token}/chats/{chat_number}/messages/{message_number} `
- Response
```json
{
    "number": 1,
    "body": "This is a message updated"
}
```

#### Searching through messages of a specific chat
- Endpoint ` GET /api/v1/applications/{token}/chats/{chat_number}/messages/search/query?={search_query} `
- Response
```json
[
  {
      "number": 1,
      "body": "This is a message updated"
  },
  {
      "number": 3,
      "body": "message"
  }
]
```


