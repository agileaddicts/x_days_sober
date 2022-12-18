# x_days_sober

## Deployment on fly.io

The application name on fly.io is `xdayssober`. It is connected to the `lifttribe-staging-pg` Postgres database.

To connect to the staging datbase, use `fly proxy 6543:5432 -a lifttribe-staging-pg` and then connect to Postges locally using port 6543.

Connect to a remote console using `fly ssh console --config ./fly.toml` and inside the running container, use `./app/bin/x_days_sober remote`.

Manual deployment can be done via `fly deploy --remote-only`
