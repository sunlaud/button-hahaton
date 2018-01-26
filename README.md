#Wi-Fi button for hackaton

## Install tools
`npm install nodemcu-tool`

## Upload code

`node_modules/nodemcu-tool/bin/nodemcu-tool.js -p /dev/ttyUSB0 upload src/util.lua`


## Terminal
`socat READLINE,history=$HOME/.com_port_history /dev/ttyUSB0,raw,echo=0,crnl,b115200`
