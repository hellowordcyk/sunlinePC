/** A bunch of useful utilitiy javascript methods available to all pages 
includes:cookie tools,ajax tools(base prototype.js)
**/

/*
Returns a space delimited value of a select list. There's strangely no in-built way of doing this for multi-selects
*/
function getMultiSelectValues(selectObject) 
{
    var selectedValues = '';
    for (var i = 0; i < selectObject.length; i++)
    {
        if(selectObject.options[i].selected)
        {
            if (selectObject.options[i].value && selectObject.options[i].value.length > 0)
                selectedValues = selectedValues + ' ' + selectObject.options[i].value;
        }
    }

    return selectedValues;
}

function getMultiSelectValuesAsArray(selectObject)
{
    var selectedValues = new Array();
    for (var i = 0; i < selectObject.length; i++)
    {
        if(selectObject.options[i].selected)
        {
            if (selectObject.options[i].value && selectObject.options[i].value.length > 0)
                selectedValues[selectedValues.length] = selectObject.options[i].value;
        }
    }
    return selectedValues;
}

/*
  Returns true if the value is the array
*/
function arrayContains(array, value)
{
    for (var i = 0; i < array.length; i++)
    {
        if (array[i] == value)
        {
            return true;
        }
    }

    return false;
}

/*
Adds a class name to the given element
*/
function addClassName(elementId, classNameToAdd) 
{
    var elem = document.getElementById(elementId);
    if (elem)
    {
        elem.className = elem.className + ' ' + classNameToAdd;
    }
}

/*
 Removes all class names to from the given element
 */
function removeClassName(elementId, classNameToRemove) 
{
    var elem = document.getElementById(elementId);
    if (elem)
    {
        elem.className = (' ' + elem.className + ' ').replace(' ' + classNameToRemove + ' ', ' ');
    }
}

/*
    Returns the field as an encoded string (assuming that the id == the field name
*/
function getEscapedFieldValue(id)
{

    var e = document.getElementById(id);

    if (e.value)
    {
        return id + '=' + encodeURIComponent(e.value);
    }
    else
    {
        return '';
    }
}

/*
    Returns a concatenated version of getEscapedFieldValue
*/
function getEscapedFieldValues(ids)
{
    var s = '';
    for (i = 0; i < ids.length; i++)
    {
        s = s + '&' + getEscapedFieldValue(ids[i]);
    }
    return s;
}

/*
 Toggles hide / unhide an element. Also attemots to change the "elementId + header" element to have the headerOpened / headerClosed class.
 Also saves the state in a cookie
*/
function toggle(elementId) 
{
    var elem = document.getElementById(elementId);
    if (elem)
    {
        if (readFromConglomerateCookie("bimis.conglomerate.cookie", elementId, '1') == '1')
        {
            elem.style.display = "none";
            removeClassName(elementId + 'header', 'headerOpened');
            addClassName(elementId + 'header', 'headerClosed');
            saveToConglomerateCookie("bimis.conglomerate.cookie", elementId, '0');
        }
        else
        {
            elem.style.display = "";
            removeClassName(elementId + 'header', 'headerClosed');
            addClassName(elementId + 'header', 'headerOpened');
            eraseFromConglomerateCookie("bimis.conglomerate.cookie", elementId);
        }
    }
}

function toggleDivsWithCookie(elementShowId, elementHideId)
{
    var elementShow = document.getElementById(elementShowId);
    var elementHide = document.getElementById(elementHideId);
    if (elementShow.style.display == 'none')
    {
        elementHide.style.display = 'none';
        elementShow.style.display = 'block';
        saveToConglomerateCookie("bimis.views.cong.cookie", elementShowId, '1');
        saveToConglomerateCookie("bimis.views.cong.cookie", elementHideId, '0');
    }
    else
    {
        elementShow.style.display = 'none';
        elementHide.style.display = 'block';
        saveToConglomerateCookie("bimis.views.cong.cookie", elementHideId, '1');
        saveToConglomerateCookie("bimis.views.cong.cookie", elementShowId, '0');
    }
}

/*
 Similar to toggle. Run this on page load.
*/
function restoreDivFromCookie(elementId, cookieName, defaultValue)
{
    if (defaultValue == null)
        defaultValue = '1';

    var elem = document.getElementById(elementId);
    if (elem)
    {
        if (readFromConglomerateCookie(cookieName, elementId, defaultValue) != '1')
        {
            elem.style.display = "none";
            removeClassName(elementId + 'header', 'headerOpened');
            addClassName(elementId + 'header', 'headerClosed')
        }
        else
        {
            elem.style.display = "";
            removeClassName(elementId + 'header', 'headerClosed');
            addClassName(elementId + 'header', 'headerOpened')
        }
    }
}

/*
 Similar to toggle. Run this on page load.
*/
function restore(elementId)
{
    restoreDivFromCookie(elementId, "bimis.conglomerate.cookie", '1');
}

// Cookie handling functions

function saveToConglomerateCookie(cookieName, name, value)
{
    var cookieValue = getCookieValue(cookieName);
    cookieValue = addOrAppendToValue(name, value, cookieValue);
    saveCookie(cookieName, cookieValue, 365);
}

function readFromConglomerateCookie(cookieName, name, defaultValue)
{
    var cookieValue = getCookieValue(cookieName);
    var value = getValueFromCongolmerate(name, cookieValue);
    if(value != null)
    {
        return value;
    }

    return defaultValue;
}

function eraseFromConglomerateCookie(cookieName, name)
{
    saveToConglomerateCookie(cookieName, name,"");
}

function getValueFromCongolmerate(name, cookieValue)
{
    var newCookieValue = null;
    // a null cookieValue is just the first time through so create it
    if(cookieValue == null)
    {
        cookieValue = "";
    }
    var eq = name + "=";
    var cookieParts = cookieValue.split('|');
    for(var i = 0; i < cookieParts.length; i++) {
        var cp = cookieParts[i];
        while (cp.charAt(0)==' ') {
            cp = cp.substring(1,cp.length);
        }
        // rebuild the value string exluding the named portion passed in
        if (cp.indexOf(name) == 0) {
            return cp.substring(eq.length, cp.length);
        }
    }
    return null;
}

//either append or replace the value in the cookie string
function addOrAppendToValue(name, value, cookieValue)
{
    var newCookieValue = "";
    // a null cookieValue is just the first time through so create it
    if(cookieValue == null)
    {
        cookieValue = "";
    }

    var cookieParts = cookieValue.split('|');
    for(var i = 0; i < cookieParts.length; i++) {
        var cp = cookieParts[i];

        // ignore any empty tokens
        if(cp != "")
        {
            while (cp.charAt(0)==' ') {
                cp = cp.substring(1,cp.length);
            }
            // rebuild the value string exluding the named portion passed in
            if (cp.indexOf(name) != 0) {
                newCookieValue += cp + "|";
            }
        }
    }

    // always append the value passed in if it is not null or empty
    if(value != null && value != '')
    {
        var pair = name + "=" + value;
        if((newCookieValue.length + pair.length) < 4020)
        {
            newCookieValue += pair;
        }
    }
    return newCookieValue;
}

function getCookieValue(name)
{
    var eq = name + "=";
    var ca = document.cookie.split(';');
    for(var i=0;i<ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') {
            c = c.substring(1,c.length);
        }
        if (c.indexOf(eq) == 0) {
            return c.substring(eq.length,c.length);
        }
    }

    return null;
}

/**
*@param name cookie name
*@param value cookie value
*@param days expires days
*@param path cookie path
*@param domain cookie domain
*@param secure cookie secure
*/
function saveCookie(name,value,days)
{
  var ex;
  var ck;
	var argv = saveCookie.arguments;
	var argc = saveCookie.arguments.length;
	var path = (argc > 3) ? argv[3] : null;
	var domain = (argc > 4) ? argv[4] : null;
	var secure = (argc > 5) ? argv[5] : false;

  if (days) {
    var d = new Date();
    d.setTime(d.getTime()+(days*24*60*60*1000));
    ex = "; expires="+d.toGMTString();
  }
  else {
    ex = "";
  }
  document.cookie = name + "=" + value + ex +((path == null) ? "" : ("; path=" + path)) +((domain == null) ? "" : ("; domain=" + domain))
+((secure == true) ? "; secure" : "");
}

/*
Reads a cookie. If none exists, then it returns and 
*/
function readCookie(name, defaultValue)
{
  var cookieVal = getCookieValue(name);
  if(cookieVal != null)
  {
      return cookieVal;
  }

  // No cookie found, then save a new one as on!
  if (defaultValue)
  {
      saveCookie(name, defaultValue, 365);
      return defaultValue;
  }
  else
  {
      return null;
  }
}

function eraseCookie(name)
{
  saveCookie(name,"",-1);
}

/*
Ajax load from url into htmlElementId
with evalScripts enabled
with loadind indicator
*/
function ajaxLoadPage(htmlElementId,url)
{
	  var el = $(htmlElementId);
	  el.innerHTML='<img src="/images/loading.gif" />loading...';

    new Ajax.Updater(htmlElementId,url,
    {method:'get',
    asynchronous:true,
    evalScripts:true});    
}
function reportError(request)
{
	
  //onFailure:reportError,
	alert('Sorry. There was an error.');
}
