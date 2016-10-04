$(document).ready(function(){
	$('.vote').click(function(){
		var vid = $(this).attr('post_id')

		if($(this).hasClass('vote-up')){
			var voteType = 1;
		}else{
			var voteType = -1;
		}
		$ajax({
			url: '/process-vote',
			type: 'post',
			data: {vid: vid, voteType: voteType},
			success: function(result){
				console.log(result)
			}
		})
	});
});