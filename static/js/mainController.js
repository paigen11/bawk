var bawkApp = angular.module('bawkApp', ['ngRoute', 'ngCookies'], function($interpolateProvider){
	$interpolateProvider.startSymbol('{$');
    $interpolateProvider.endSymbol('$}');
	});

bawkApp.config(function($locationProvider) {
    $locationProvider.html5Mode({
      enabled: true,
      requireBase: false
    });
});

var path = 'http://localhost:5000/'

bawkApp.controller('mainController', function($scope, $http, $location, $cookies, $timeout, $route){

	checkUsername()

	if($location.path() == '/'){
		$http.post(path + 'all_posts', {
		}).then(function successCallback(response){
			$scope.posts = response.data;
		})
		if($cookies.get('username')){
				$http.post(path + 'get_posts', {
					username: $scope.username
				}).then(function successCallback(response){
					$scope.posts = response.data;
					// console.log(response.data);
				})
				$http.post(path + 'get_trending_users',{
					username: $scope.username
				}).then(function successCallback(response){
					$scope.users = response.data;
					// console.log(response.data);
			})
		}	
	}

	
	if($location.path() == '/profile'){
		$http.post(path + 'profile', {
			username: $scope.username
		}).then(function successCallback(response){
			$scope.posts = response.data;
			$scope.profilePage = true;
		})
	}

	// reloads the page so the user sees the new location page
	$scope.profile = function(){
		location.reload();
	}

	// reloads the page so the user sees the home page again
	$scope.home = function(){
		location.reload();
	}

	// function to create profile for site
	$scope.register = function(){
		$http.post(path + 'register_submit', {
			username: $scope.username,
			password: $scope.password,
			email: $scope.email,
			avatar: $scope.avatar
		}).then(function successCallback(response){
			if(response.data == 'registration successful'){
				$scope.loggedIn = true;
				$cookies.put('username', $scope.username);
				$cookies.put('avatar', $scope.avatar);
				if($cookies.get('username')){
					$http.post(path + 'get_posts', {
						username: $scope.username
					}).then(function successCallback(response){
						$scope.posts = response.data;
					})
					$http.post(path + 'get_trending_users',{
						username: $scope.username
					}).then(function successCallback(response){
						$scope.users = response.data;
					})
				}	
			}
			else if(response.data == 'username taken'){
				$scope.loggedIn = false;
				$scope.usernameTaken = true;
			}
		})
		
	}

	// function to log in after creating profile
	$scope.login = function(){
		$http.post(path + 'login_submit', {
			username: $scope.username,
			password: $scope.password
		}).then(function successCallback(response){
			if(response.data == 'noMatch'){
				$scope.loggedIn = false;
				$scope.noMatch = true;
			}else if(response.data){
				$scope.loggedIn = true;
				$cookies.put('username', $scope.username);
				$scope.avatar = response.data;
				$cookies.put('avatar', $scope.avatar);
				$scope.signIn = true;
				
				if($cookies.get('username')){
					$http.post(path + 'get_posts', {
						username: $scope.username
					}).then(function successCallback(response){
						$scope.posts = response.data;
						// console.log(response.data);
					})
					$http.post(path + 'get_trending_users',{
						username: $scope.username
					}).then(function successCallback(response){
						$scope.users = response.data;
						// console.log(response.data);
					})
					$route.reload();
				}
			}
		})
	}	

	//logout function
	$scope.logout = function(){
		$cookies.remove('username');
		$cookies.remove('avatar');
		$scope.username = '';
		$scope.avatar = '';
		$scope.loggedIn = false;
		$scope.everyoneFollowed = false;
		checkUsername();
		if($location.path() == '/'){
			$http.post(path + 'all_posts', {
			}).then(function successCallback(response){
				$scope.posts = response.data;
			})
			$route.reload();
		}	
		// console.log('reload successful')
	};

	//add post content to database and update the feed
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


	$scope.follow = function(){
		$http.post(path + 'follow', {
			username: $scope.username
		})
	}

	$scope.followUser = function(id, index){
		$scope.users.splice(index,1);
		if($scope.users.length == 0){
			$scope.everyoneFollowed = true;
		}
		$http.post(path + 'follow', {
			username: $scope.username,
			following_id: id
		})
		if($cookies.get('username')){
			$http.post(path + 'get_posts', {
				username: $scope.username
			}).then(function successCallback(response){
				$scope.posts = response.data;
			})
			$route.reload();
		}
		// console.log('route reload')
	}

	$scope.vote = function(vid, voteType){
		if ($cookies.get('username') == undefined){
			$scope.noVote = true;
			$timeout(function(){
				$scope.noVote = false;
			}, 1500);
			console.log('logInToVote')
		}else if($cookies.get('username')){
			if(voteType == true){
				var voteType = 1;
			}else if(voteType == false){
				var voteType = -1;
			}
			$http.post(path + 'process_vote', {
				vid: vid,
				voteType: voteType,
				username: $scope.username
			}).then(function successCallback(response){
				if(response.data == 'alreadyVoted'){
					$scope.alreadyVoted = true;
					$timeout(function(){
						$scope.alreadyVoted = false;
					}, 1500);
					console.log('alreadyVoted')
				}
				else if(response.data){
					$scope.posts = response.data;
					console.log(response.data);
				}
			})
		}		
	}

	// function to check if user's been to site before and log them back in when they return
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

});
