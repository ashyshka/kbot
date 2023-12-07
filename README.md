# kbot

# Create simple telegram bot to executing some command

**Step by stem instruction to reproducing this**

- 01. Just doing setup Codespace WorkSpace or executing needed command to get and install packages which needed, this example for using with CodeSpace (but at the local git repo this will working similar)
```
go mod init github.com/ashyshka/kbot
go install github.com/spf13/cobra-cli@latest
cobra-cli init
cobra-cli add version
```
- 02. Getting package gopkg.in/telebot.v3
```
- 02.01 `go get "gopkg.in/telebot.v3"` - this is can be used before declaring inside kbot.go
- 02.02 `go get`- adding import for this package to kbot.go and just doing `go get`
```
- 03. Creating telegram bot, named t.me/ashyshka_bot and getting token for HTTP API
- 04. Export this token to env var, named TELE_TOKEN
- 05. Making build go application (telegram bot) with several version, extending functions
- right now, we can start bot and do simple command like /start hello - will show messages like that
```
Andrii Shyshka, [07.12.23 23:30]
/start

Andrii Shyshka, [07.12.23 23:31]
/start hello

kbot, [07.12.23 23:54]
Hello! I'm Kbot 1.0.2
```
