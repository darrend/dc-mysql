up:
    just daemon
    docker compose logs -f

down:
    docker compose down

drop:
    docker compose down -v

setup:
    just drop
    just up

daemon:
    docker compose up -d

ps:
    docker compose ps



