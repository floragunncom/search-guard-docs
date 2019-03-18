    $(document).ready(function() {
		$( "#chatTitleBar" ).on( "click", function() { toggleChat()	} );		
		$( "#chatLink" ).on( "click", function() {	toggleChat() } );				
	});
    
    function toggleChat() {
		var height = $( "#chatcontainer" ).height();
		$( "#chatcontainer" ).height(height == '600' ? '32px' : '600px');    	
    }
    