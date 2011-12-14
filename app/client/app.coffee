# Client-side Code

# Bind to socket events
SS.socket.on 'disconnect', ->  $('#message').text('SocketStream server is down :-(')
SS.socket.on 'reconnect', ->   $('#message').text('SocketStream server is up :-)')

notify = (view)->
  $("#templates-notice").mustache(view).purr 
    usingTransparentPNG: true
    fadeInSpeed: 500
    fadeOutSpeed: 1000
    removeTimer: 1000  
# This method is called automatically when the websocket connection is established. Do not rename/delete
exports.init = ->
  $("#typeset").button().click (e)->
    $('#pad').pad 'getContents':'padContent', (data)->
      if data
        SS.server.app.compile data, (result)->
          if result.success
            console.log result.message
            pdf = new PDFObject
              url: result.message
            pdf.embed('pdf')
          else
            notify
              title: "Error"
              message: result.message
          
        
  $('#pad').pad({'padId':'latex-pad','showChat':'false', 'showControls':'true', 'userName':""}); 
  $('#epframepad').attr 'style', 'width:100%;height:600px'
  $('#pad').show()
  # Make a call to the server to retrieve a message
  SS.server.app.init (response) ->
    $('#message').text(response)

  # Start the Quick Chat Demo
  SS.client.demo.init()
#   
  $(->
    pdf = new PDFObject
      url: "/compiled.pdf"
    pdf.embed('pdf')  
  )
