# Server-side Code

exec = require("child_process").exec
fs = require("fs")
compileTex = (data, cb)->
  fs.writeFile "../../public/compiled.tex",data
  tex = exec "pdflatex -interaction=nonstopmode ../../public/compiled.tex", (error,stdout,stderr)->
    console.log "stdout: " + stdout
    console.log "stderr: " + stderr
    console.log "exec error: " + error  if error isnt null
    cb()
    
exports.actions =
  
  init: (cb) ->
    cb "SocketStream version #{SS.version} is up and running. This message was sent over Socket.IO so everything is working OK."

  # Quick Chat Demo
  sendMessage: (message, cb) ->
    if message.length > 0                             # Check for blank messages
      SS.publish.broadcast 'newMessage', message      # Broadcast the message to everyone
      cb true                                         # Confirm it was sent to the originating client
    else
      cb false
  
  compile: (data, cb) ->
    result=
      success: true
      message: "/compiled.pdf"
    compileTex data, ->
      cb result
