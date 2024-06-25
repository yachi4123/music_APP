import os
#set auth with spotify lib
from flask import Flask,session,url_for,redirect,request
from spotipy import Spotify
from spotipy.oauth2 import SpotifyOAuth
from spotipy.cache_handler import FlaskSessionCacheHandler
app = Flask(__name__)
#to store secrert ley so that noone else can acesses it genetar string of 64 random byte
app.config['SECRET_KEY'] = os.urandom(64)

    
client_id='c258cad72f774f70a87c0833dc20cb98'
client_secret='e2235e6fe1a240239462b754643b822a'
redirect_url='http://127.0.0.1:5000/callback'
    #permissions needed to access spotify api
scope='playlist-read-private '#we need to accse provate data
    #stroe access token in flask session
    #as changes in code stored its reloaded*/ecrte

cache_handler = FlaskSessionCacheHandler(session)
sp_oauth=SpotifyOAuth(client_id=client_id,client_secret=client_secret,redirect_url=redirect_url,scope=scope,cache_handler=cache_handler,show_dialog=True )
sp=Spotify(auth_manager=sp_oauth)#client
#create authentication object to authorise the session
@app.route('/')
def home():
    #if logged in
    if not sp_oauth.validate_token(cache_handler.get_cached_token()):#not expire and we can move thru app
        auth_url=sp_oauth.get_authorize_url() #login if not already logged in
        return redirect(auth_url) #rediredt to auth url page
    return redirect(url_for('get_playlist')) #if logged in take to homepage
@app.route('/callback')
def callback():#not login countinouly if we add more permisions so login again
    sp_oauth.get_access_token(request.args['code'])
    return redirect(url_for('get_playlist'))
@app.route("/get_playlist")
def get_playlists():
    if not sp_oauth.validate_token(cache_handler.get_cached_token()):
      auth_url=sp_oauth.get_authorize_url() #login if not already logged in
    return redirect(auth_url)
   
   
playlists=sp.current_user_playlists()
#iterate trhu every part of plyalists and get name and url
playlists_info=[(pl['name'],pl['external_urls']['spotify'])for pl in playlists['items']]
playlists_html='<br>'.join([f'{name}:{url}' for name,url in playlists_info])

return playlists_html

@app.route("/logout")
def logout():
    session.clear()
    return redirect(url_for('home'))
if __name__ == '__main__':
    app.run(debug=True)
#session->conatiner to store data and acess data as user moves from page to page to store data we store asscess token to interacrt with stotipy api