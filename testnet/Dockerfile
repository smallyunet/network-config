FROM pellnetwork/pellnode:v1.0.1

RUN pellcored init pellcored-testnet --chain-id ignite_186-1

COPY app.toml /root/.pellcored/config/app.toml
COPY client.toml /root/.pellcored/config/client.toml
COPY config.toml /root/.pellcored/config/config.toml
COPY genesis.json /root/.pellcored/config/genesis.json

CMD ["pellcored", "start"]