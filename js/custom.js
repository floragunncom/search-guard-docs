$(document).ready(function () {
	// The left navigation is initialised in js/all.js with the bundled "tendina"
	// accordion plugin. Tendina cancels the click (preventDefault) on every <a>
	// that is immediately followed by a <ul>, so section links such as
	// "Getting Started" or "Authorization" only folded/unfolded and never loaded
	// their own page. Take click handling away from tendina so the link is always
	// followed, and drive the fold state ourselves.
	var $nav = $('.js-menu-vertical');

	if (!$nav.length) {
		return;
	}

	// Clicking a section link both toggles the section and loads its page, so the
	// fold has to outlive the page load that follows it. Remember the section the
	// user folded; every other section falls back to the default (unfolded when it
	// is the page we are on).
	var FOLDED_KEY = 'sgNavFoldedSection';

	function readFolded() {
		try {
			return window.sessionStorage.getItem(FOLDED_KEY);
		} catch (e) {
			return null; // storage unavailable (private mode, cookies blocked)
		}
	}

	function writeFolded(slug) {
		try {
			if (slug) {
				window.sessionStorage.setItem(FOLDED_KEY, slug);
			} else {
				window.sessionStorage.removeItem(FOLDED_KEY);
			}
		} catch (e) {
			// storage unavailable: sections just always come back unfolded
		}
	}

	// left_navigation_item.html marks the current page with class "selected" on
	// the <a>. Grab it before destroying tendina, which strips every "selected".
	var $active = $nav.find('a.selected');

	if ($nav.data('tendina')) {
		$nav.tendina('destroy');
	}

	// destroy() expands everything and drops all "selected" classes, so rebuild the
	// state from scratch. On <li> elements "selected" now means "unfolded" only;
	// the current page is highlighted through a.selected instead.
	$nav.find('ul').hide();
	$nav.find('li').removeClass('selected');
	$active.addClass('selected');

	var folded = readFolded();

	// A remembered fold only applies to the page it was made on.
	if (folded !== $active.attr('href')) {
		writeFolded(null);
		folded = null;
	}

	// The path down to the current page always has to be visible. Walk up from the
	// <li>, not the <a>, so the current item's own submenu is not caught here and
	// can stay folded.
	$active.parent('li').parentsUntil($nav, 'li').addClass('selected').children('ul').show();

	if (!folded) {
		$active.parent('li').addClass('selected');
		$active.next('ul').show();
	}

	// Toggle the section without cancelling the click, so the browser still
	// follows the link and loads the section's page.
	$nav.on('click', 'a', function (event) {
		// A modifier or non-primary click opens the link in a new tab or window and
		// leaves this page standing, so the section here must not toggle.
		if (event.which > 1 || event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) {
			return;
		}

		var $link = $(this);
		var $submenu = $link.next('ul');

		if (!$submenu.length) {
			writeFolded(null); // a leaf, nothing to remember
			return;
		}

		// Read the fold state from the submenu's own display rather than :visible,
		// which is also false whenever an ancestor is hidden (ReSmenu swaps the
		// whole nav for a <select> below 974px).
		if ($submenu.css('display') !== 'none') {
			$link.parent('li').removeClass('selected');
			$submenu.hide();
			writeFolded($link.attr('href'));
		} else {
			$link.parent('li').addClass('selected');
			$submenu.show();
			writeFolded(null);
		}
	});
});
