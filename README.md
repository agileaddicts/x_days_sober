# x_days_sober

## Deployment on fly.io

The application name on fly.io is `xdayssober`. It is connected to the `lifttribe-staging-pg` Postgres database.

To connect to the staging datbase, use `fly proxy 6543:5432 -a lifttribe-staging-pg` and then connect to Postges locally using port 6543.

Connect to a remote console using `fly ssh console` and inside the running container, use `./app/bin/x_days_sober remote`.

Manual deployment can be done via `fly deploy --remote-only`

## Resources

* Design inspired by: https://pocket.tailwindui.com/
* Color Palette: https://coolors.co/d81e5b-102e4a-5ab1bb-fffd98-fff8f0
* "Logo" from: https://handcrafts.undraw.co/app
* Icons: https://heroicons.com/

## No License

This repository does not include any License and therefore grants no License to anyone. See [No License](https://choosealicense.com/no-permission/) for more information.

This repository is public for others to learn. Please note that it includes source code (e.g. the template used) for which a commercial license must be purchased to be used. 
