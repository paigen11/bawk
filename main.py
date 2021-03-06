# import flask stuff
from flask import Flask, render_template, redirect, request, jsonify, session
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

@app.route('/register_submit', methods=['POST'])
def register_submit():
	data = request.get_json()
	username = data['username']
	# first check to see if username is already taken. this means a select statement
	check_username_query = "SELECT * FROM user WHERE username = %s"
	# print check_username_query
	cursor.execute(check_username_query, (username))
	check_username_result = cursor.fetchone()
	if check_username_result is None:
		#no match. insert
		email = data['email']
		password = data['password'].encode('utf-8')
		hashed_password = bcrypt.hashpw(password, bcrypt.gensalt())
		avatar = data['avatar']
		# print avatar
		username_insert_query = "INSERT INTO user (username, password, email, avatar) VALUES (%s, %s, %s, %s)"
		cursor.execute(username_insert_query, (username, hashed_password, email, avatar))
		conn.commit()
		return "registration successful"
	else:
		# second if it is taken, send them back to the register page with a message
		# if it's not taken then insert the user into mysql	
		print 'username taken'
		return "username taken"
	
@app.route('/login_submit', methods=['POST'])
def login_submit():
	data = request.get_json()
	username = data['username'] 
	password = data['password']
	session['username'] = username

	check_password_query = "SELECT password, id FROM user where username = %s"
	cursor.execute(check_password_query, (username))
	check_password_result = cursor.fetchone()

	check_avatar_query = "SELECT avatar FROM user WHERE username = %s"
	cursor.execute(check_avatar_query, (username))
	check_avatar_result = cursor.fetchone()

	# to check a hash against english:
	if check_avatar_result == None:
		return jsonify('noMatch')

	if bcrypt.hashpw(password.encode('utf-8'), check_password_result[0].encode('utf-8')) == check_password_result[0].encode('utf-8'):
		#we have a match
		return jsonify(check_avatar_result[0])

@app.route('/post_submit', methods=['POST'])
def post_submit():
	data = request.get_json()
	username = data['username']
	content = data["content"]
	
	get_user_id_query = "SELECT id FROM user WHERE username = %s"
	cursor.execute(get_user_id_query, (username))
	get_user_id_result = cursor.fetchone()
	
	insert_post_query = "INSERT INTO bawks (content, user_id) VALUES (%s, %s)"
	cursor.execute(insert_post_query, (content, get_user_id_result[0]))
	conn.commit()
	return render_template('index.html')


@app.route('/all_posts', methods=['POST'])
def all_posts():
	get_all_posts_query = "SELECT user.avatar, user.username, content, total_votes, time, location FROM bawks INNER JOIN user ON user.id = bawks.user_id ORDER BY time ASC"
	cursor.execute(get_all_posts_query)	
	get_all_post_result = cursor.fetchall()	
	conn.commit()
	# print get_all_post_result
	return jsonify(get_all_post_result)

@app.route('/profile', methods=['GET','POST'])
def profile_page():
	if request.method == 'GET':
		if session['username']: 
			return render_template('/profile.html')

	elif request.method == 'POST':
		data = request.get_json()
		username = data['username']
		print username

		get_user_id_query = "SELECT id FROM user WHERE username = %s"
		cursor.execute(get_user_id_query, (username))
		get_user_id_result = cursor.fetchone()

		get_user_posts_query = "SELECT user.avatar, user.username, content, total_votes, time, location FROM bawks INNER JOIN user ON user.id = bawks.user_id WHERE user.id = %s ORDER BY time ASC" 

		cursor.execute(get_user_posts_query, (get_user_id_result[0]))
		get_post_result = cursor.fetchall()
		# print get_post_result	
		conn.commit()

		if get_post_result is not None:
			return jsonify(get_post_result)

@app.route('/get_posts', methods=['POST'])
def get_posts():
	data = request.get_json()
	username = data['username']
	
	get_user_id_query = "SELECT id FROM user WHERE username = %s"
	cursor.execute(get_user_id_query, (username))
	get_user_id_result = cursor.fetchone()

	get_posts_query = "SELECT user.avatar, user.username, content, total_votes, time, location, user_id, bawks.id FROM bawks LEFT JOIN user ON user_id = user.id LEFT JOIN follow on following_id = bawks.user_id WHERE follow.following_id IN (SELECT following_id from follow where follower_id = %s) GROUP BY user.avatar, user.username, content, total_votes, time, location, user_id, bawks.id UNION SELECT user.avatar, user.username, content, total_votes, time, location, user_id, bawks.id FROM bawks LEFT JOIN user ON user_id = user.id WHERE user.id = %s ORDER BY time ASC" 
	
	cursor.execute(get_posts_query, (get_user_id_result[0], get_user_id_result[0]))

	get_post_result = cursor.fetchall()	
	conn.commit()
	if get_post_result is not None:
		return jsonify(get_post_result)

@app.route('/process_vote', methods=['POST'])
def process_vote():
	data = request.get_json()
	pid = data['vid']
	vote_type = data['voteType']
	username = data['username']

	get_user_id_query = "SELECT id FROM user WHERE username = %s"
	cursor.execute(get_user_id_query, (username))
	get_user_id_result = cursor.fetchone()

	check_user_votes_query = "SELECT * FROM votes INNER JOIN user ON user.id = votes.uid WHERE user.username = %s AND votes.pid = %s"
	cursor.execute(check_user_votes_query, (username, pid))
	check_user_votes_result = cursor.fetchone()

	# it's possible we get none back because the user hasn't voted on this post
	if check_user_votes_result is None:
		
		insert_user_vote_query = "INSERT INTO votes (pid, uid, vote_type) VALUES (%s, %s, %s)"
		cursor.execute(insert_user_vote_query, (pid, get_user_id_result[0], vote_type))
		conn.commit()

		update_post_votes = "SELECT SUM(vote_type) AS user_votes FROM votes WHERE pid = %s"
		cursor.execute(update_post_votes, (pid))
		post_vote = cursor.fetchone()
		conn.commit()

		update_vote_query = "UPDATE bawks SET bawks.total_votes = %s WHERE bawks.id = %s"
		cursor.execute(update_vote_query, (post_vote[0], pid))
		conn.commit()

		get_posts_query = "SELECT user.avatar, user.username, content, total_votes, time, location, user_id, bawks.id FROM bawks LEFT JOIN user ON user_id = user.id LEFT JOIN follow on following_id = bawks.user_id WHERE follow.following_id IN (SELECT following_id from follow where follower_id = %s) GROUP BY user.avatar, user.username, content, total_votes, time, location, user_id, bawks.id UNION SELECT user.avatar, user.username, content, total_votes, time, location, user_id, bawks.id FROM bawks LEFT JOIN user ON user_id = user.id WHERE user.id = %s ORDER BY time ASC"  

		cursor.execute(get_posts_query, (get_user_id_result[0], get_user_id_result[0]))
		get_post_result = cursor.fetchall()	
		conn.commit()
		if get_post_result:
			print 'voteCounted'
			return jsonify(get_post_result)
	else:
		print 'alreadyVoted'
		return jsonify('alreadyVoted')	

@app.route('/get_trending_users', methods=['POST'])
def get_trending_users():
	data = request.get_json()
	username = data['username']

	get_user_id_query = "SELECT id FROM user WHERE username = %s"
	cursor.execute(get_user_id_query, (username))
	get_user_id_result = cursor.fetchone()

	get_trending_query = "SELECT user.id, avatar, username FROM user LEFT JOIN follow on following_id = user.id WHERE follow.following_id NOT IN (SELECT following_id from follow where follower_id = {0}) AND following_id != {0} GROUP BY user.id, avatar, username".format(get_user_id_result[0])
	cursor.execute(get_trending_query)
	trending_users_result = cursor.fetchall()

	return jsonify(trending_users_result)

@app.route('/follow', methods=['POST'])
def follow():
	data = request.get_json()
	username = data['username']
	following_id = data['following_id']

	get_user_id_query = "SELECT id FROM user WHERE username = %s"
	cursor.execute(get_user_id_query, (username))
	get_user_id_result = cursor.fetchone()

	follow_query = "INSERT INTO follow (follower_id, following_id) VALUE (%s, %s)" 
	cursor.execute(follow_query, (get_user_id_result[0], following_id))
	conn.commit()
	return "it's working"
		

if __name__ == '__main__':
	app.run(debug=True)	