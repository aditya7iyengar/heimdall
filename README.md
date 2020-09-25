# Heimdall

Share sensitive information with temporary urls and encryption!

![heimdall](https://media4.giphy.com/media/xE1QISPzqbUek/giphy.gif)

## Naming

Heimdall (pronounced _Haim-Dawl_) in norse mythology is the "ever-vigilant" god
who guards Bifrost (pronounced _Byff-Rost_), the rainbow bridge that leads to
Asgard.

## A Simple Solution for a Simple Use Case

You need to share your SSN with someone. You don't want to say it out loud
on phone (you have people around you), and you also don't want send is as an
email because it will be readily available to anyone who accesses (and hacks)
that email in the future.

Heimdall allows you to share secure information such as your SSN using a
__temporary__ link which disappears in 5 mins or any configurable amount of
time. In this way, if someone does find a way to get the link in the future, it
would likely be expired. You can also choose to encrypt the information using
AES encryption for added security and the key could be something unique to
the receiver (like the name of their first pet). This further decreases the
number of people that could decrypt the information.

## Local setup

### Docker + Ngrok (Recommended)

I recommend running it using `docker` so you won't have to install all the
dependencies on your host machine.

Once you have `docker` installed, you can just run the following command to
get the server up and running:

`$ docker run -p 127.0.0.1:4010:4010 aditya7iyengar/heimdall:latest`

This command will start up an instance of `Heimdall` locally on your port
`4010`. So, you can access the app at: `http://localhost:4010`

To expose it to publically (to share information with someone), you can use
a tunneling service like `ngrok` or `localtunnel`. Here's how to expose your
port using `ngrok`:

`$ ngrok http 4010`

The above command should return a url through which your local port can be
accessed by anyone. Make sure to stop the `ngrok` process once the information
is already shared.

### Elixir + Ngrok (for Elixir developers)

`Heimdall` is a web app written using [Elixir](https://elixir-lang.org/) and
[Phoenix Framework](phoenixframework.org). Here are the requirements to run it
locally:

- Elixir ~> 1.10.4
- Erlang ~> 22.3.4
- NodeJS ~> 11.15
- Direnv

You can get the server up and running at the default port `4010` by running:

```
$ git clone aditya7iyengar/heimdall
$ cd heimdall
$ direnv allow .
$ mix deps.get
$ mix phx.server
```

_NOTE: You can override defaults by creating `.envrc.custom` file to override
`.envrc` contents_

This command will start up an instance of `Heimdall` locally on your port
`4010`. So, you can access the app at: `http://localhost:4010`

To expose it to publically (to share information with someone), you can use
a tunneling service like `ngrok` or `localtunnel`. Here's how to expose your
port using `ngrok`:

`$ ngrok http 4010`

The above command should return a url through which your local port can be
accessed by anyone. Make sure to stop the `ngrok` process once the information
is already shared.


## Roadmap

- [ ] Add "add aesir" link
- [ ] Make `Dockerfile` more env friendly
- [ ] Add ttl to aesir form in the UI
- [ ] Add wrong attempts to aesirs
- [ ] Add geography/IP filter
- [ ] Add limit to number of times the link is decrypted
- [ ] Add an API endpoint for adding aesirs
- [ ] Add a `cli` app that talks to the API
- [ ] Add show/hide key button
- [ ] Add notes for `ngrok` integration
- [ ] Deploy w/ `k8s`
- [ ] Add CD
- [ ] Add documentation
- [ ] Add PGP support
- [ ] Add `credo`
- [ ] Add `dialyzer`
- [ ] Add `inch-ci`
- [ ] Clean up errors/messages using error helpers/gettext
