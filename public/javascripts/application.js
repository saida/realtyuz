// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// http://www.webyfi.com/?p=222
// function remove_field(element, item) {
//   element.up(item).remove();
// }

// https://github.com/mislav/will_paginate/wiki/ajax-pagination
document.observe("dom:loaded", function() {
  // the element in which we will observe all clicks and capture
  // ones originating from pagination links
  var container = $(document.body)

  if (container) {
    var img = new Image
    img.src = '/images/spinner.gif'

    function createSpinner() {
      return new Element('img', { src: img.src, 'class': 'spinner' })
    }

    container.observe('click', function(e) {
     	var el = e.element()
			if (el.match('.pagination.ajax a')) {
			  el.up('.pagination.ajax').insert(createSpinner())
        new Ajax.Request(el.href, { method: 'get' })
        e.stop()
      }
    })
  }
})