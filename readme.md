#Wanderlust (Social Post) App

##What is it?
---
This is a Yik Yak/Twitter type clone. The app allows the user to register/login and link a jpg image to their user profile, it hashes the password using bcrypt and displays the notes of the user's followers. The user can follow other users, vote on their messages, and view their own profile and tweets in a separate profile page.

##Languages Used
---
  * HTML5
  * CSS3
  * Bootstrap
  * AngularJS
  * JavaScript
  * AJAX
  * Compass/SASS
  * Python
  * Flask
  * Jinja
  * MySQL

##Live Demo Link
---
TBD

##Github Link
---
[Github](https://github.com/paigen11/bawk)

##Authors
---
Paige Niedringhaus

##Screenshots
---
Start screen when new users come to the site for the first time
![alt text](https://github.com/paigen11/bawk/blob/master/screenshots/login-screen.png)

New user sign up modal
![alt text](https://github.com/paigen11/bawk/blob/master/screenshots/sign-up.png)

Message displaying when username is taken
![alt text](https://github.com/paigen11/bawk/blob/master/screenshots/username-taken.png)

Message displaying when username and password don't match
![alt text](https://github.com/paigen11/bawk/blob/master/screenshots/user-not-recognized.png)

Logged in view showing users' posts the user is following and more users they can follow
![alt text](https://github.com/paigen11/bawk/blob/master/screenshots/logged-in-view.png)

Message that displays after user's already voted on post once
![alt text](https://github.com/paigen11/bawk/blob/master/screenshots/already-voted-message.png)

Profile page view the user can navigate to to see only their own posts
![alt text](https://github.com/paigen11/bawk/blob/master/screenshots/user-profile.png)

##Further Info
---
The site is set up on the Twitter Bootstrap framework and styled with SASS through Compass. Each piece of the site (nav bar, login dropdowns, etc.) have their own SCSS files, which are all compiled into the main styles.scss file at the end.

When users first come to the site they see messages from all other users, but when they login to their own accounts, they'll only see messages from themselves and users they've chosen to follow. 

When users newly register with the site, their passwords are hashed on the back-end MySQL database through bcrypt and a cookie is dropped on to their local machine so they'll be remembered in the future if they come back without logging out first.

On the front end, the site is built using one AngularJS controller that takes all the data in JSON format, and passes it back to Python on the back end, which translates it through `data = request.get_json()`. In this way, the data can then be loaded into the MySQL database, which is connected through Flask. 

Similarly, when that data needs to be recalled from MySQL, queries can be written recalling specific data, which is then delivered through Flask's Jinja Python templating engine to the front-end.

So Angular on the front end keeps things updating in real-time with its lovely `ng-repeat` methods and Jinja and MySQL on the backend store and deliver the key pieces of data called for by the user.

Getting Angular to play nice with Flask and Bootstrap was a trial, and more than once, odd Angular-specific bugs were encountered. 

One such bug was getting Angular to reload the page when the user switched from the home page view to the user profile page view. This was finally solved using a native JavaScript location.reload() function called whenever the user clicked on the link for the home or profile pages. 

Another bug was getting just the message that a user voted on to display a sign telling them they couldn't vote more than once (since the posts were being displayed through ng-repeat, each one would show the message even though the user only voted on one). I got around this by putting the messages up in the navbar on a set timeout, so they'd show for a second then disappear again. This got around the ng-repeat problem.

##Requirements
---
There's a number of requirements to set this up to run like I did. Prepare yourself...

For the front end of the site, Twitter's [Bootstrap](http://getbootstrap.com/getting-started/) framework was used in conjunction with [AngularJS](https://angularjs.org/), and the Angular modules of [ngCookies and ngRoutes](https://code.angularjs.org/1.5.8/). Since Bootstrap's JavaScript files were employed for site responsiveness, Google's [jQuery](https://ajax.googleapis.com/ajax/libs/jquery/2.2.4/jquery.min.js) script is also needed. Styling was done with SASS through [Compass](http://compass.kkbox.com/). This is optional, but it makes the styling process quicker.

For the back end of the site, you'll need to set up a virtual environment, by running `virtualenv 'newFolderName'` in the command line to create the environment for your site to live in. Next, run `pip install flask` (for the Flask framework), then `pip install flask-mysql` (for the connection the MySQL database), then `pip install bcrypt` (for the bcrypt password hashing). Finally, when all that's done and the database is created, run `python main.py` in the command line to spin up your Python file, which can then be accessed at localhost:5000 or whatever port you choose. Documentation on working with Flask can be found [here](http://flask.pocoo.org/).

##Code Examples
---
Python script that runs when a user up or down votes a message, it translates the JSON from Angular to data Python can read, sends it back to the MySQL database. Then if the user hasn't voted on the post, the post count gets updated and it's reflected on the front end and all the posts are reloaded through the get_posts_query. If the user has already voted on the post, a message telling them so is displayed instead.


```python
@app.route('/process_vote', methods=['POST'])
def process_vote():
  data = request.get_json()
  pid = data['vid']
  vote_type = data['voteType']
  username = data['username']

  get_user_id_query = "SELECT id FROM user WHERE username = '%s'" % username
  cursor.execute(get_user_id_query)
  get_user_id_result = cursor.fetchone()

  check_user_votes_query = "SELECT * FROM votes INNER JOIN user ON user.id = votes.uid WHERE user.username = '%s' AND votes.pid = '%s'" % (username, pid)
  cursor.execute(check_user_votes_query)
  check_user_votes_result = cursor.fetchone()

  # it's possible we get none back because the user hasn't voted on this post
  if check_user_votes_result is None:
    # print "I am here"
    insert_user_vote_query = "INSERT INTO votes (pid, uid, vote_type) VALUES ('%s', '%s', '%s')" %(pid,get_user_id_result[0], vote_type)
    cursor.execute(insert_user_vote_query)
    conn.commit()

    update_post_votes = "SELECT SUM(vote_type) AS user_votes FROM votes WHERE pid = '%s'" %(pid)
    cursor.execute(update_post_votes)
    post_vote = cursor.fetchone()
    conn.commit()

    update_vote_query = "UPDATE bawks SET bawks.total_votes = %s WHERE bawks.id = %s" % (post_vote[0], pid)
    cursor.execute(update_vote_query)
    conn.commit()

    get_posts_query = "SELECT user.avatar, user.username, content, total_votes, time, location, user_id, bawks.id FROM bawks LEFT JOIN user ON user_id = user.id LEFT JOIN follow on following_id = bawks.user_id WHERE follow.following_id IN (SELECT following_id from follow where follower_id = '%s') GROUP BY user.avatar, user.username, content, total_votes, time, location, user_id, bawks.id UNION SELECT user.avatar, user.username, content, total_votes, time, location, user_id, bawks.id FROM bawks LEFT JOIN user ON user_id = user.id WHERE user.id = '%s' ORDER BY time ASC" % (get_user_id_result[0], get_user_id_result[0]) 

    cursor.execute(get_posts_query)
    get_post_result = cursor.fetchall() 
    conn.commit()
    if get_post_result:
      print 'voteCounted'
      return jsonify(get_post_result)
  else:
    print 'alreadyVoted'
    return jsonify('alreadyVoted')  
``` 


Angular JavaScript function that allows a user to post a message, save it to the back end, and then update all the existing messages instantly so they see their message appear at the top of messages

```javascript
$scope.newPost = function(){
    var submitPost = {
      username: $scope.username,
      avatar: $scope.avatar,
      content: $scope.content
    }

    if($scope.username == undefined){
      $scope.logIn = true;
      $timeout(function(){
        $scope.logIn = false;
      }, 1500);
    }
    else if($scope.username){
        $http.post(path + 'post_submit', submitPost)
        .then(function(response) {
        console.log("post saved");
        if($location.path() == '/'){
          $http.post(path + 'get_posts', submitPost)
          .then(function successCallback(response){
            $scope.posts = response.data;
          })
        }
      })
    }   
  }
```

JavaScript function to check if the username for the site is stored as a cookie on the user's local machine when they come to the site.

```javascript
  function checkUsername(){
    if($cookies.get('username') != null){
      $scope.signIn = true;
      $scope.loggedIn = true;
      $scope.username = $cookies.get('username');
      $scope.avatar = $cookies.get('avatar');
    }else if ($cookies.get('username') == undefined){
      $scope.signIn = false;
      console.log('new user');
    }
  }
```

##Additional Improvements
---
 * Add the ability to unfollow users
 * Add the ability to filter or sort timelines by upvotes or downvotes instead of just chronologically
 * Add the ability to see other user's profiles and posts by clicking on them 
 * Add the ability to search for users or invite them to join Wanderlust
