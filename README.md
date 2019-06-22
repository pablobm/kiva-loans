# Kiva Loans

A site I built back in 2009. An experiment involving [Sinatra](http://www.sinatrarb.com/), the [Google Maps API](https://developers.google.com/maps/), [Heroku](https://www.heroku.com/) and the [Kiva API](http://build.kiva.org/).

The site was accessible at http://kiva-loans.herokuapp.com, but has since been shut down.

## How to run locally

Install dependencies:

```
$ bundle install
```

Copy the sample env file and fill it out with the appropriate values:

```
$ cp .env.sample .env
$ vi .env
```

Run:

```
$ rackup
```

## License

This work is in the Public Domain. Do whatever you like with it.
