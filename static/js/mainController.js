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
		$http.get('http://localhost:5000/get_posts', {

		}).then(function successCallback(response){
			console.log(response);
			$scope.posts = response.data;
			console.log($scope.posts);
		})
	}

	// function to create profile for site
	$scope.register = function(){
		$http.post('http://localhost:5000/register_submit', {
			username: $scope.username,
			password: $scope.password,
			email: $scope.email
		})

		console.log("success");
	}

	// function to log in after creating profile
	$scope.login = function(){
		$http.post('http://localhost:5000/login_submit', {
			username: $scope.username,
			password: $scope.password
		}).then(function successCallback(response){
			if(response.data == 'true'){
				$scope.loggedIn = true;
				$cookies.put('username', $scope.username);
			}
		})
	}

	//logout function
	$scope.logout = function(){
			$cookies.remove('username');
			$scope.loggedIn = false;
	};

	// function to check if user's been to site before and log them back in when they return
	function checkUsername(){
		if($cookies.get('username') != null){
			$scope.loggedIn = true;
			$scope.username = $cookies.get('username');
		}
	}
});