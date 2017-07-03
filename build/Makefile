all: sessionmgr

sessionmgr: ../sessionmgr.go ../*.tpl ../*.sh
	go build ../sessionmgr.go && cp ../*.tpl . && cp ../*.sh .
