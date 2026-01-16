#!/bin/bash

touch .env

echo "POSTGRES_PORT=$POSTGRES_PORT" >> .env
echo "POSTGRES_HOST=$POSTGRES_HOST" >> .env
echo "POSTGRES_USER=$POSTGRES_USER" >> .env
echo "POSTGRES_PASS=$POSTGRES_PASS" >> .env
echo "POSTGRES_DATABASE=$POSTGRES_DATABASE" >> .env
echo "PORT=$PORT" >> .env
echo "MIGRATE_CONFIG_PREFIX=$ENV" >> .env
echo "IS_ON_SERVER=true" >> .env