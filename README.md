# docker-tor

## Usage
docker run -v <host-path>:/home/tor/.torrc:ro -p 9050:9050 tor:latest

OR

docker run -p 9050:9050 tor:latest /home/tor/bin/tor [args]
