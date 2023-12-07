# kbot

# Create simple telegram bot to executing some command

**Step by stem instruction to reproducing this**

- 01. Just setup Codespace WorkSpace or setup needed command to get and install packages which needed, this example for using with CodeSpace (at the local git repo will working similar)
```
go mod init github.com/ashyshka/kbot
go install github.com/spf13/cobra-cli@latest
cobra-cli init
cobra-cli add version
```
- 02. Get package gopkg.in/telebot.v3
```
- 02.01 go get "gopkg.in/telebot.v3" - can be used before declare inside kbot.go
- 02.02 - add import this package to kbot.go and just do go get 
```
- 03. Create telegram bot, named t.me/ashyshka_bot and get token for HTTP API
- 04. Export this token to env var, named TELE_TOKEN
- 05. Make build bot with several version, extending functions
- right now, we can start bot and do simple command like /start hello - will show messages like that
```
Andrii Shyshka, [07.12.23 23:30]
/start

Andrii Shyshka, [07.12.23 23:31]
/start hello

kbot, [07.12.23 23:54]
Hello! I'm Kbot 1.0.2
```