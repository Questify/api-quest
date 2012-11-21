
# ### Module dependencies.

express   = require('express')
http      = require('http')
mongoose  = require('mongoose')
lingo     = require('lingo')


# Connect to mongoose if not already connected

if !module.parent
  conn = mongoose.createConnection 'localhost', 'app-quest'
require('./model')

# Application layer

app = express()
app.set 'port', process.env.PORT || 3001
app.set 'views', "#{__dirname}/views"
app.set 'view engine', 'jade'
app.use express.favicon()
app.use express.bodyParser()
app.use express.methodOverride()
app.use (req, res, next) ->
  req._ = lingo.en
  req._.t = req._.translate
  res.locals._ = req._
  next()
app.use app.router



# # Routes

Quests = conn.model('Quest')

# ## GET /quests/
#
# Returns a table of all the quests available.

app.get '/', (req, res) ->
  Quests.find (err, quests) ->
    throw err if err?
    switch req.type
      when 'json' then res.json quests
      else
        res.render 'index', quests: quests



# Start listening for incoming requests.

http.createServer(app).listen app.get('port'), ->
  console.log "api-quest is listening on port #{app.get 'port'}"
