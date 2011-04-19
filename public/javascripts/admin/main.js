jQuery(document).ready(function(){
    jQuery('ul.accordion').accordion({ 
        autoheight: false,
        header: ".opener",
        active: '.selected',
        selectedClass: 'active',
        alwaysOpen: false,
        event: "click"
    });
		
		jQuery('.ex').hover(function() {
			(this).addClass('hover');
		});
		
		jQuery('.ex').click(function() {
				jQuery('.info-top').fadeOut();
		});
});