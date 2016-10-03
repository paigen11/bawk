# import flask stuff
from flask import Flask, render_template, redirect, request, jsonify
# import the mysql module
from flaskext.mysql import MySQL
import bcrypt as bcrypt

# set up mysql connection here later
mysql = MySQL()
app = Flask(__name__)
app.config['MYSQL_DATABASE_USER'] = 'x'
app.config['MYSQL_DATABASE_PASSWORD'] = 'x'
app.config['MYSQL_DATABASE_DB'] = 'bawk_db'
app.config['MYSQL_DATABASE_HOST'] = '127.0.0.1'
mysql.init_app(app)

conn = mysql.connect()
cursor = conn.cursor()

app.secret_key = "FHNOGVOIWHWNQFQW(FHGNRUOGEWOUGHEW"

@app.route('/')
def index():
	return render_template('index.html')

@app.route('/register')
def register():
	if request.args.get('username'):
		# the username variable is set in the query string
		return render_template('index.html', 
			message = "That username is already taken.")
	else:
		return render_template('index.html')

@app.route('/register_submit', methods=['POST'])
def register_submit():
	data = request.get_json()
	username = data['username']
	# first check to see if username is already taken. this means a select statement
	check_username_query = "SELECT * FROM user WHERE username = '%s'" % username
	# print check_username_query
	cursor.execute(check_username_query)
	check_username_result = cursor.fetchone()
	if check_username_result is None:
		#no match. insert
		email = data['email']
		password = data['password'].encode('utf-8')
		hashed_password = bcrypt.hashpw(password, bcrypt.gensalt())
		username_insert_query = "INSERT INTO user (username, password, email) VALUES ('%s', '%s', '%s')" % (username, hashed_password, email)
		cursor.execute(username_insert_query)
		conn.commit()
		return "You are logged in type page"
	else:
		# second if it is taken, send them back to the register page with a message
		# if it's not taken then insert the user into mysql	
		return redirect('/index?username=taken')
	
	

@app.route('/login_submit', methods=['POST'])
def login_submit():
	data = request.get_json()
	username = data['username']
	password = data['password']

	check_password_query = "SELECT password FROM user where username = '%s'" % username
	cursor.execute(check_password_query)

	check_password_result = cursor.fetchone()
	# to check a hash against english:
	if bcrypt.hashpw(password.encode('utf-8'), check_password_result[0].encode('utf-8')) == check_password_result[0].encode('utf-8'):
		#we have a match
		print "Match!"
		return 'true';

@app.route('/get_posts', methods=['GET'])
def get_posts():
	get_posts_query = "SELECT bawks.avatar, user.username, content, total_votes, time, location FROM bawks JOIN user ON user_id = user.id"
	cursor.execute(get_posts_query)

	get_post_result = cursor.fetchall()	
	return jsonify(get_post_result)	
		

if __name__ == '__main__':
	app.run(debug=True)	