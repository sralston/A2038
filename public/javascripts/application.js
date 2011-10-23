// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

	var lastEventNum;
	var interval;
	var ping_time = 10000; 

	jQuery.stopUpdateButton = function() {
		$("#stopUpdateButton").attr("disabled","disabled");
		$("#startUpdateButton").removeAttr("disabled");
		interval=window.clearInterval(interval);
	}
	
	jQuery.startUpdateButton = function() {
		$("#startUpdateButton").attr("disabled","disabled");
		$("#stopUpdateButton").removeAttr("disabled");
		$.requestLoginUpdate();
	}

	jQuery.inputHighlight = function(color) {
		$(".login_input").each(function() {
			$(this).focus(function() {
				$(this).css({"background" : color, "border" : "4px solid #5a5a5a"});
			});
			$(this).blur(function() {
				$(this).css({"background" : "#5a5a5a", "border" : "4px solid black" });
			});
		});
	}
	
	jQuery.stop_requests = function () {
		interval=window.clearInterval(interval);
	}
	
	jQuery.no_updates = function(eventText) {
		$("#waiting_no_updates").fadeOut(1200, function() { 
			$(this).html(eventText).fadeIn(1200, function() {
				$(this).fadeOut(1200, function () {
					$(this).html("Waiting for other players...").fadeIn(1200, function () { } );			
				}); 
			});
		});
	}
	
	jQuery.login = function(player_num, eventText) {
		$("#player"+player_num).css("background-color","#3e6a4b");
	}
	
	jQuery.logout = function(player_num, eventText) {	
		$("#player"+player_num).css("background-color","#a83b46");
	}
	
	jQuery.redirect = function(new_addr) {
		window.location = new_addr;
	}

	jQuery.requestLoginUpdate = function () {

		interval = setInterval(function() {
			$.get('/login/update',
				{ last_event_num : lastEventNum },
				function(data) {
					//do stuff when receive back in JSON
					interval=window.clearInterval(interval); // pause the request to handle updates.
					$("waiting_updates").fadeOut(1500, function () { } ).html("");
					$.each(data, function(x, events) {
						$.each(events, function(y, event) {
							switch(event.code) {
								case 'LOGIN_PLAYER':
									$.login(event.value, event.text);
									break;
								case 'LOGOUT_PLAYER':
									$.logout(event.value, event.text);
									break;
								case 'NO_UPDATE':
									$.no_updates(event.text);
									break;
								case 'LOGIN_ALL_IN':
									$.redirect(event.text);
									break;
							}  // end of switch
						});
					});
				
					lastEventNum = data[data.length-1].event.id;
					$.requestLoginUpdate();
				}, "json"
			);
		}, ping_time);
	};
