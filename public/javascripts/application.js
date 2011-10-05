// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

	jQuery.inputHighlight = function(color) {
		$(".login_input").each(function() {
			$(this).focus(function() {
				$(this).css({"background" : color});
			});
			$(this).blur(function() {
				$(this).css({"background" : "#c4c4c4"});
			});
		});
	}
	
	
