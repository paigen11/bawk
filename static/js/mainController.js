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

bawkApp.controller('mainController', function($scope, $http, $location, $cookies){

	checkUsername()

	if($location.path() == '/'){
		$http.post('http://localhost:5000/get_posts', {
			username: $scope.username
		}).then(function successCallback(response){
			$scope.posts = response.data;

		})
		console.log($scope.username)
		$http.post('http://localhost:5000/get_trending_users',{

			username: $scope.username
		}).then(function successCallback(response){
			$scope.users = response.data;
		})
	}

	// function to create profile for site
	$scope.register = function(){
		$http.post('http://localhost:5000/register_submit', {
			username: $scope.username,
			password: $scope.password,
			email: $scope.email,
			avatar: $scope.avatar
		}).then(function successCallback(response){
			if(response.data == 'registration successful'){
				$scope.loggedIn = true;
				$cookies.put('username', $scope.username);
			}
			else if(response.data == 'username taken'){
				$scope.loggedIn = false;
				$scope.usernameTaken = true;
			}
		})
		
	}

	// function to log in after creating profile
	$scope.login = function(){
		$http.post('http://localhost:5000/login_submit', {
			username: $scope.username,
			password: $scope.password
		}).then(function successCallback(response){
			if(response.data){
				$scope.loggedIn = true;
				$cookies.put('username', $scope.username);
				$scope.avatar = response.data;
				$cookies.put('avatar', $scope.avatar);
			}
			else if(response.data == 'no match'){
				$scope.loggedIn = false;
				$scope.noMatch = true;
			}
		})
	}

	//logout function
	$scope.logout = function(){
		$cookies.remove('username');
		$scope.loggedIn = false;
	};

	//add post content to database and update the feed
	$scope.newPost = function(){
		$http.post('http://localhost:5000/post_submit', {
			username: $scope.username,
			avatar: $scope.avatar,
			content: $scope.content
		}).then(function successCallback(response){
			console.log("post saved");
			if($location.path() == '/'){
				$http.get('http://localhost:5000/get_posts', {

				}).then(function successCallback(response){
					$scope.posts = response.data;
				})
			}
		})
	}

	$scope.follow = function(){
		$http.post('http://localhost:5000/follow', {
			username: $scope.username

		})
	}

	$scope.followUser = function(id, index){
		$scope.users.splice(index,1);
		if($scope.users.length == 0){
			$scope.everyoneFollowed = true;
		}

		$http.post('http://localhost:5000/follow', {
			username: $scope.username,
			following_id: id
		})
	}

	// $scope.vote = function(){
	// 	$http.post('http://localhost:5000/process_vote', {
	// 		username: $scope.username,


	// 	})
	// 	console.log('voted');
	// }

	// function to check if user's been to site before and log them back in when they return
	function checkUsername(){
		if($cookies.get('username') != null){
			$scope.loggedIn = true;
			$scope.username = $cookies.get('username');
		}
	}

});