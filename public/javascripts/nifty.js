/**
 * Nifty - rounded corners with CSS and Javascript
 * 
 * Idea from Nifty Corners Cube 
 * @see http://www.html.it/articoli/niftycube/index.html
 * 
 * @author benben(ben-na@163.com)
 * 
 * 2007-10-9
 */

/**
 * Rounded corners with css selector
 * 
 * @param {String} selector - select elements
 *   Example:
 *     #id
 *     ul#id
 *     div#id h3
 *     .abc
 *     div.abc
 *     div.abc ul li
 *     
 * @param {Object} options
 *   options = {
 *   	top: 'all', // left, right, all, none
 *   	bottom: 'all',  // left, right, all, none
 *   	size: 'middle',  // small, middle, big or other @see Nifty.config
 *      sameHeight: false  // if make the elements same height 
 *   }
 */
var Nifty = function(selector, options) {
	var parts = selector.split(',');
	var elms = [];
	for (var i = 0; i < parts.length; ++i) {
		Nifty.combin(elms, Nifty.$$(Nifty.strip(parts[i])));
	}
	Nifty.round(elms, options);
}

/**
 * Rounded corners
 * 
 * @param {Element | String | Array<Element|String>} elms
 * @param {Object} options - @see Nifty
 */
Nifty.round = function(elms, options) {
	if (elms.constructor != Array) {
		elms = [elms];
	}
	options = options || { };
	options.top = options.top || 'all';	// left, right, all, none
	options.bottom = options.bottom || 'all';
	options.size = options.size || 'middle'; // small, middle, big
	
	for (var i = 0; i < elms.length; ++i) {
		var elm = Nifty.$(elms[i]);
		Nifty._fixIE(elm);
		if (options.top != 'none') {
			var corner = Nifty._createCorner(elm, 'top', options);
			elm.style.paddingTop = '0';
			elm.insertBefore(corner, elm.firstChild);
		}
		if (options.bottom != 'none') {
			var corner = Nifty._createCorner(elm, 'bottom', options);
			elm.style.paddingBottom = '0';
			elm.appendChild(corner);
		}
	}
	
	if (options.sameHeight) {
		Nifty._sameHeight(elms);
	}
}

/**
 * This config will be use to round corner
 * 
 * each have three parts
 *   1. round size(px)
 *   2. css prefix
 *   3. css postfix number
 *   
 * @see nifty.css
 */
Nifty.config = {
	small: [2, 'ts', 1],
	middle: [5, 't', 4],
	big: [10, 'tb', 8]
}

Nifty.$ = function(elm) {
	if (typeof elm == 'string') {
		elm = document.getElementById(elm);
	}
	return elm;
}

Nifty.strip = function(s) {
	return s.replace(/^\s+/, '').replace(/\s+$/, '');
}

Nifty.$$ = function(selector) {
	// div#id tag1 tag2
	// div.style tag1 tag2
	var regexp = /^(\w+)?(#(\w+))?(\.(\w+))?(\s([\w\s]+))?$/;
	var matches = selector.match(regexp);
	if (!matches) {
		return [];
	}
	
	var elms = [];
	if (matches[2]) { // #id 
		var t = Nifty.$(matches[3]);
		if (!t || matches[1] && t.tagName.toLowerCase() != matches[1].toLowerCase()) {
			return [];
		}
		elms.push(t);
	} else if (matches[4]) { // .styleclass
		var tags = document.getElementsByTagName(matches[1] || '*');
		for (var i = 0; i < tags.length; ++i) {
			if (Nifty.hasClassName(tags[i], matches[5])) {
				elms.push(tags[i]);
			}
		}
	} else if (matches[1]) {	// tag without id and styleclass, ignore children tag
		return document.getElementsByTagName(matches[1]);
	} else {
		return [];
	}
	
	if (matches[6]) { // children tags
		var s = Nifty.strip(matches[7]); 
		if (s.length > 0) {
			var tags = s.split(/\s+/);
			for (var i = 0; i < tags.length; ++i) {
				var t = [];
				for (var j = 0; j < elms.length; ++j) {
					Nifty.combin(t, Nifty.getChildren(elms[j], tags[i]));
				}
				elms = t;
			}
		}
	}
	return elms;
}

Nifty.combin = function(des, src) {
	src = src || [];
	for (var i = 0; i < src.length; ++i) {
		des.push(src[i]);
	}
	return des;
}

Nifty.hasClassName = function(elm, className) {
	var classNames = elm.className.split(/\s+/);
	for (var i = 0; i < classNames.length; ++i) {
		if (classNames[i] == className) {
			return true;
		}
	}
	return false;
}

Nifty.getStyle = function(elm, name) {
	if (elm.currentStyle) {	// IE
		return elm.currentStyle[name];
	}
	if (document.defaultView && document.defaultView.getComputedStyle) {	// DOM
		return document.defaultView.getComputedStyle(elm, '')[name];
	}
	return null;
}

Nifty.ele = function(name) {
	return document.createElement(name);
}

Nifty.rgb2hex = function(rgb) {
	var regexp = /(\d+),\s*(\d+),\s*(\d+)/;
	var matches = rgb.match(regexp);
	if (matches) {
		var result = '#';
		for (var i = 1; i < 4; ++i) {
			var v = parseInt(matches[i]).toString(16);
			if (v.length == 1) {
				v = '0' + v;
			}
			result += v;
		}
		return result;
	}
	return '#ffffff';
}

Nifty.getBk = function(elm) {
	var c = Nifty.getStyle(elm, 'backgroundColor');
	if (c.indexOf('rgb') == 0) {
		c = Nifty.rgb2hex(c);
	}
	return c;
}

Nifty.getParentBk = function(elm) {
	var elm = elm.parentNode;
	var c = 'transparent';
	while (elm && elm.tagName.toLowerCase() != 'html' && (c = Nifty.getBk(elm)) == 'transparent') {
		elm = elm.parentNode;
	}
	return c == 'transparent' ? '#ffffff' : c;
}

Nifty.getChildren = function(elm, tag) {
	var result = [];
	for (var i = 0; i < elm.childNodes.length; ++i) {
		var node = elm.childNodes[i];
		if (node.tagName && node.tagName.toLowerCase() == tag.toLowerCase()) {
			result.push(node);
		}
	}
	return result;
}

Nifty._fixIE = function(elm) {
	if (elm.currentStyle && elm.currentStyle.hasLayout == false) {
		elm.style.display = 'inline-block';
	}
}

Nifty._getStyle = function(elm, name, unit) {
	var style = Nifty.getStyle(elm, name);
	if (style && style.indexOf(unit) != -1) {
		return parseInt(style);
	}
	return Number.NaN;
}

Nifty._createCorner = function(elm, side, options) {
	var corner = Nifty.ele('b');
	corner.className = 'niftycorners';
	corner.style.background = 'transparent';
	corner.style.marginLeft = '-' + Nifty.getStyle(elm, 'paddingLeft');
	corner.style.marginRight = '-' + Nifty.getStyle(elm, 'paddingRight');
	
	var config = Nifty.config[options.size];
	Nifty._setMargin(elm, corner, side, config[0]);
	if (side == 'top') {
		for (var i = 1; i <= config[2]; ++i) {
			var strip = Nifty._createStrip(elm, config[1] + i, options.top);
			corner.appendChild(strip);
		}
	} else {
		for (var i = config[2]; i > 0; --i) {
			var strip = Nifty._createStrip(elm, config[1] + i, options.bottom);
			corner.appendChild(strip);
		}
	}
	return corner;
}

Nifty._setMargin = function(elm, corner, side, size) {
	var m = side == 'top' ? 'paddingTop' : 'paddingBottom';
	var n = side == 'top' ? 'marginBottom' : 'marginTop';
	var p = Nifty._getStyle(elm, m, 'px');
	if (isNaN(p)) {
		corner.style[n] = Nifty.getStyle(elm, m);
	} else {
		corner.style[n] = p - size + 'px';
	}
}

Nifty._createStrip = function(elm, style, side) {
	var x = Nifty.ele('b');
	x.className = style;
	x.style.backgroundColor = 'transparent';
	x.style.borderColor = Nifty.getParentBk(elm);
	if (side == 'left') {
		x.style.borderRightWidth = '0';
    	x.style.marginRight = '0';
	} else if (side == 'right') {
		x.style.borderLeftWidth = '0';
		x.style.marginLeft= '0';
	}
	return x;
}

Nifty._sameHeight = function(elms) {
	var max = 0;
	for (var i = 0; i < elms.length; ++i) {
		elms[i].style.height = 'auto';
		var h = elms[i].offsetHeight;
		if (h > max)  {
			max = h;
		}
	}
	for (var i = 0; i < elms.length; ++i) {
		var gap = max - elms[i].offsetHeight;
		if (gap > 0) {
			var t = Nifty.ele('b');
			t.className = 'niftyfill';
			t.style.height = gap + 'px';
			var nc = elms[i].lastChild;
			if (nc.className == 'niftycorners') {
				elms[i].insertBefore(t, nc);
			} else {
				elms[i].appendChild(t);
			}
		}
	}
}
