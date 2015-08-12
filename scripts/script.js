YUI().use('node', 'event', 'event-valuechange', function(Y) {

	// ShareThis
	Y.all('#shareThisLink #shareIcon').on('click', function(){
		Y.all('.sharethis').toggleClass('block');
	});

	var navLast;
	// Left sidebar dropdown menus
	var navEnter = function(e){
		if (!e.currentTarget.one('.nav') || navLast === e.currentTarget) return;
		
		e.currentTarget.one('.nav').setStyle('display', 'block');
		
		if (navLast)
			navLast.one('.nav').setStyle('display', 'none');
		
		navLast = e.currentTarget
	};
	var navSidebarLi = Y.all('nav.sidebar-menu > ul > li');
	navSidebarLi.on('mouseenter', navEnter);
	
	var navSubHeight = 109;
	Y.all('nav.sidebar-menu li .nav').each(function(el) {
		
		el.setStyle('height', navSubHeight);
	});

	// Mobile menu
	Y.one('select').on('change', function(){
		var selIndex = this.get("selectedIndex");
		var attrOpts = this.get("options");
		window.location = attrOpts.item(selIndex).get('value');
	});
	// http://yuilibrary.com/yui/docs/attribute/attribute-event.html

	var nua = navigator.userAgent;
	var is_native_android = (nua.indexOf('Mozilla/5.0') > -1 && nua.indexOf('Android ') > -1 && nua.indexOf('AppleWebKit') > -1 && nua.indexOf('Chrome') < 0);
	
	if (is_native_android) {
		console.log('is_android');
		Y.one('#logo_svg').setStyles({
			position: 'absolute',
			top: '0'
		});
		Y.one('#logo_svg image').setStyles({
			position: 'absolute'
		});
		Y.one('.mobile-menu').setStyles({
			position: 'absolute',
			margin: '0'
		});
		Y.one('#attrSel').setStyles({
			position:'fixed',
			top: '73px',
			display: 'block',
			margin: '0'
		});
	}
}); // YUI closes
