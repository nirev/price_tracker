# Price Tracker

[![Build Status](https://travis-ci.org/nirev/price_tracker.svg?branch=master)](https://travis-ci.org/nirev/price_tracker)

A simple price tracker application.

## Description

Some assumptions:
- percentage change is stored with two decimal cases at most
- no scheduling, the updating of prices could be run by cron
- no assumption on how to run. `PriceTracker.run` could be exposed
as a Mix task or runnable escript
- host and api_key are configured via ENV_VARS, check `PriceTracker.PriceFetcher.API`

Dependencies:
- Runtime:
  - ecto: database interface
  - httpoison: http requests
  - poison: JSON parsing
  - postgrex: ecto's postgres adapter
  - timex: manipulating dates
- dev and test:
  - bypass: for testing external API calls
  - credo: static analysis for styling issues
  - dialyxir: static analysis for type checking
  - earmark: for documentation
  - ex_doc: for documentation
  - mox: testing, creates mocks for behaviours

## Usage

Environment:
- elixir 1.5.1
- erlang 20.0

### "installing"

```shell
git clone git@github.com:nirev/price_tracker.git
cd price_tracker
mix deps.get
```

### running tests

```shell
mix test
```

### documentation

Documentation is available at https://nirev.github.io/price_tracker/ <br>
It was generated with ex_doc using:

```shell
mix docs
```

### static code analysis

[Credo](https://github.com/rrrene/credo) is used for code styling check

```shell
mix credo
```

[Dialyxir](https://github.com/jeremyjh/dialyxir) for warnings regarding 
type mismatch and other common mistakes.

The first run takes a while, as it must build a lookup table.

```shell
mix dialyzer
```

