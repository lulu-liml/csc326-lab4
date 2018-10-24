import bottle
from bottle import run, route, template, static_file, redirect, request
from oauth2client.client import OAuth2WebServerFlow
from oauth2client.client import flow_from_clientsecrets
from googleapiclient.errors import HttpError
from googleapiclient.discovery import build
import httplib2
from beaker.middleware import SessionMiddleware
from collections import OrderedDict


# the record dict is used to store top 20 most popular keywords
record = OrderedDict()
user_email = ''

session_opts = {
    'session.type': 'memory',
    'session.cookie_expires': True,
    'session.auto': True
}
app = SessionMiddleware(bottle.app(), session_opts)

def getUserEmail(credentials):
    token = credentials.id_token['sub']
        
    http = httplib2.Http()
    http = credentials.authorize(http)
    
    # Get user email
    users_service = build('oauth2', 'v2', http=http)
    user_document = users_service.userinfo().get().execute() 
    user_email = user_document['email']
    return user_email
    
@route('/',method='GET')
def index():
    global user_email,record
    session = bottle.request.environ.get('beaker.session')
    if user_email:
        record = session[user_email]
    else:
        record = OrderedDict()
        
    return template('index',keywords='',record=record,  user_email=user_email)

@route('/login_step1',method='POST')
def login_step1():
    return template('login')
@route('/login_step2',method='POST')
def login_step2():
    global user_email,record
    
    user_email = request.forms.get('email')
    session = bottle.request.environ.get('beaker.session')
    if  user_email not in session:
        flow = flow_from_clientsecrets("client_secret_236907109154-1us7tahjvssjcmtfk3orivipcjr4lult.apps.googleusercontent.com.json",scope='https://www.googleapis.com/auth/plus.me https://www.googleapis.com/auth/userinfo.email', redirect_uri="http://35.175.88.130:80/redirect")
        auth_uri = flow.step1_get_authorize_url()
        bottle.redirect(str(auth_uri))
    else:
        record = session[user_email]
        return template('index',keywords='',record=record, user_email=user_email)
        

@route('/logout',method='POST')
def logout():
    global user_email
    user_email = ''
    record = OrderedDict()
    redirect("/")
    
    
@route('/redirect')
def redirect_page():
    global user_email,record
    CLIENT_ID = '236907109154-1us7tahjvssjcmtfk3orivipcjr4lult.apps.googleusercontent.com'
    CLIENT_SECRET = 'mvAagtXMQyUTMS0EMkTRhsOM'
    SCOPE = 'https://www.googleapis.com/auth/calendar'
    REDIRECT_URI = 'http://35.175.88.130:80/redirect'
    code = request.query.get('code', '')
    flow = OAuth2WebServerFlow(client_id=CLIENT_ID,client_secret=CLIENT_SECRET,scope=SCOPE,redirect_uri=REDIRECT_URI)        
    credentials = flow.step2_exchange(code)
    
    session = bottle.request.environ.get('beaker.session')
    session[user_email] = OrderedDict()
    record = session[user_email]
    
    return template('index',keywords='',record=record, user_email=user_email)
# the route to load the logo image
@route('/static/<filename>')
def server_static(filename):
    return static_file(filename,root='./static_file')
    
@route('/',method='POST')
def result():
    global user_email,record
    session = bottle.request.environ.get('beaker.session')
    if user_email in session:
        session[user_email]=record
    else:
        record = OrderedDict()
    keywords = request.forms.get('keywords')
    return template('index',keywords=keywords,record=record, user_email=user_email)

run(app=app, host='0.0.0.0', port=80)
