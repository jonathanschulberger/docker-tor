# docker-tor

must mount torrc file
- docker run -v <host-path>:/home/tor/.torrc:ro [...]
OR override CMD
must publish ports for socks proxy and control port
- docker run -p 9050:9050 [...]
restart if failure
- docker run --restart=always
