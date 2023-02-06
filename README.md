Well this is just an tor related's tool kit. I pretend to collect some interesting tools for privacity and anonymity purposes.
I pretend to include here:
- Reverse shells over tor: Since they are very useful and not very common to find on internet.
- TorHost: An simple script that I made for manage ephemeral hidden services (mainly for listener purposes, but u can do whatever u want with it).

# Torhost.sh
Is an easy way to create and manage ephemeral hidden services for do whatever u want to do. It's mainly thinked for listener purposes but you know.
By default it uses port 80. Can be upgraded to establish TLS conecction but is not my priority right now. Tested on Debian based systems (Kali, Debian, Parrot) but might work in systemd based systems.

### Options
- install - Torhost will check if u have an hidden service set up on /etc/tor/torrc, if not, it will set up for you.
- start - Start your hidden service.
- stop - Stop your hidden service.
- change - Change hidden service hostname's and print the new one.
- check - Check the hostname of your hidden service.

#### Usage/Examples

```bash
sudo bash torhost.sh install
sudo bash torhost.sh check
```


![App Screenshot](https://user-images.githubusercontent.com/124470922/216985174-c1696384-2a18-41d9-8df8-29ae31043c8c.png)
