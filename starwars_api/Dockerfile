FROM elixir:1.14.4-alpine

WORKDIR /

COPY . .
RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix deps.compile && \
    mix compile

ENV MIX_ENV=prod

EXPOSE 80

CMD ["mix", "run", "--no-halt"]