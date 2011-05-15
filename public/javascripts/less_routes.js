function less_json_eval(json){return eval('(' +  json + ')')}  

function less_get_params(obj){
   
  if (jQuery) { return obj }
  if (obj == null) {return '';}
  var s = [];
  for (prop in obj){
    s.push(prop + "=" + obj[prop]);
  }
  return s.join('&') + '';
}

function less_merge_objects(a, b){
   
  if (b == null) {return a;}
  z = new Object;
  for (prop in a){z[prop] = a[prop]}
  for (prop in b){z[prop] = b[prop]}
  return z;
}

function less_ajax(url, verb, params, options){
   
  if (verb == undefined) {verb = 'get';}
  var res;
  if (jQuery){
    v = verb.toLowerCase() == 'get' ? 'GET' : 'POST'
    if (verb.toLowerCase() == 'get' || verb.toLowerCase() == 'post'){p = less_get_params(params);}
    else{p = less_get_params(less_merge_objects({'_method': verb.toLowerCase()}, params))} 
     
     
    res = jQuery.ajax(less_merge_objects({async:false, url: url, type: v, data: p}, options)).responseText;
  } else {  
    new Ajax.Request(url, less_merge_objects({asynchronous: false, method: verb, parameters: less_get_params(params), onComplete: function(r){res = r.responseText;}}, options));
  }
  if (url.indexOf('.json') == url.length-5){ return less_json_eval(res);}
  else {return res;}
}
function less_ajaxx(url, verb, params, options){
   
  if (verb == undefined) {verb = 'get';}
  if (jQuery){
    v = verb.toLowerCase() == 'get' ? 'GET' : 'POST'
    if (verb.toLowerCase() == 'get' || verb.toLowerCase() == 'post'){p = less_get_params(params);}
    else{p = less_get_params(less_merge_objects({'_method': verb.toLowerCase()}, params))} 
     
     
    jQuery.ajax(less_merge_objects({ url: url, type: v, data: p, complete: function(r){eval(r.responseText)}}, options));
  } else {  
    new Ajax.Request(url, less_merge_objects({method: verb, parameters: less_get_params(params), onComplete: function(r){eval(r.responseText);}}, options));
  }
}
function articles_path(format, verb){ return '/articles' + format + '';}
function articles_ajax(format, verb, params, options){ return less_ajax('/articles' + format + '', verb, params, options);}
function articles_ajaxx(format, verb, params, options){ return less_ajaxx('/articles' + format + '', verb, params, options);}
function new_article_path(format, verb){ return '/articles/new' + format + '';}
function new_article_ajax(format, verb, params, options){ return less_ajax('/articles/new' + format + '', verb, params, options);}
function new_article_ajaxx(format, verb, params, options){ return less_ajaxx('/articles/new' + format + '', verb, params, options);}
function edit_article_path(id, format, verb){ return '/articles/' + id + '/edit' + format + '';}
function edit_article_ajax(id, format, verb, params, options){ return less_ajax('/articles/' + id + '/edit' + format + '', verb, params, options);}
function edit_article_ajaxx(id, format, verb, params, options){ return less_ajaxx('/articles/' + id + '/edit' + format + '', verb, params, options);}
function article_path(id, format, verb){ return '/articles/' + id + '' + format + '';}
function article_ajax(id, format, verb, params, options){ return less_ajax('/articles/' + id + '' + format + '', verb, params, options);}
function article_ajaxx(id, format, verb, params, options){ return less_ajaxx('/articles/' + id + '' + format + '', verb, params, options);}
function lists_path(format, verb){ return '/lists' + format + '';}
function lists_ajax(format, verb, params, options){ return less_ajax('/lists' + format + '', verb, params, options);}
function lists_ajaxx(format, verb, params, options){ return less_ajaxx('/lists' + format + '', verb, params, options);}
function new_list_path(format, verb){ return '/lists/new' + format + '';}
function new_list_ajax(format, verb, params, options){ return less_ajax('/lists/new' + format + '', verb, params, options);}
function new_list_ajaxx(format, verb, params, options){ return less_ajaxx('/lists/new' + format + '', verb, params, options);}
function edit_list_path(id, format, verb){ return '/lists/' + id + '/edit' + format + '';}
function edit_list_ajax(id, format, verb, params, options){ return less_ajax('/lists/' + id + '/edit' + format + '', verb, params, options);}
function edit_list_ajaxx(id, format, verb, params, options){ return less_ajaxx('/lists/' + id + '/edit' + format + '', verb, params, options);}
function list_path(id, format, verb){ return '/lists/' + id + '' + format + '';}
function list_ajax(id, format, verb, params, options){ return less_ajax('/lists/' + id + '' + format + '', verb, params, options);}
function list_ajaxx(id, format, verb, params, options){ return less_ajaxx('/lists/' + id + '' + format + '', verb, params, options);}
function products_path(format, verb){ return '/products' + format + '';}
function products_ajax(format, verb, params, options){ return less_ajax('/products' + format + '', verb, params, options);}
function products_ajaxx(format, verb, params, options){ return less_ajaxx('/products' + format + '', verb, params, options);}
function new_product_path(format, verb){ return '/products/new' + format + '';}
function new_product_ajax(format, verb, params, options){ return less_ajax('/products/new' + format + '', verb, params, options);}
function new_product_ajaxx(format, verb, params, options){ return less_ajaxx('/products/new' + format + '', verb, params, options);}
function edit_product_path(id, format, verb){ return '/products/' + id + '/edit' + format + '';}
function edit_product_ajax(id, format, verb, params, options){ return less_ajax('/products/' + id + '/edit' + format + '', verb, params, options);}
function edit_product_ajaxx(id, format, verb, params, options){ return less_ajaxx('/products/' + id + '/edit' + format + '', verb, params, options);}
function product_path(id, format, verb){ return '/products/' + id + '' + format + '';}
function product_ajax(id, format, verb, params, options){ return less_ajax('/products/' + id + '' + format + '', verb, params, options);}
function product_ajaxx(id, format, verb, params, options){ return less_ajaxx('/products/' + id + '' + format + '', verb, params, options);}
function categories_path(format, verb){ return '/categories' + format + '';}
function categories_ajax(format, verb, params, options){ return less_ajax('/categories' + format + '', verb, params, options);}
function categories_ajaxx(format, verb, params, options){ return less_ajaxx('/categories' + format + '', verb, params, options);}
function new_category_path(format, verb){ return '/categories/new' + format + '';}
function new_category_ajax(format, verb, params, options){ return less_ajax('/categories/new' + format + '', verb, params, options);}
function new_category_ajaxx(format, verb, params, options){ return less_ajaxx('/categories/new' + format + '', verb, params, options);}
function edit_category_path(id, format, verb){ return '/categories/' + id + '/edit' + format + '';}
function edit_category_ajax(id, format, verb, params, options){ return less_ajax('/categories/' + id + '/edit' + format + '', verb, params, options);}
function edit_category_ajaxx(id, format, verb, params, options){ return less_ajaxx('/categories/' + id + '/edit' + format + '', verb, params, options);}
function category_path(id, format, verb){ return '/categories/' + id + '' + format + '';}
function category_ajax(id, format, verb, params, options){ return less_ajax('/categories/' + id + '' + format + '', verb, params, options);}
function category_ajaxx(id, format, verb, params, options){ return less_ajaxx('/categories/' + id + '' + format + '', verb, params, options);}
function companies_path(format, verb){ return '/companies' + format + '';}
function companies_ajax(format, verb, params, options){ return less_ajax('/companies' + format + '', verb, params, options);}
function companies_ajaxx(format, verb, params, options){ return less_ajaxx('/companies' + format + '', verb, params, options);}
function new_company_path(format, verb){ return '/companies/new' + format + '';}
function new_company_ajax(format, verb, params, options){ return less_ajax('/companies/new' + format + '', verb, params, options);}
function new_company_ajaxx(format, verb, params, options){ return less_ajaxx('/companies/new' + format + '', verb, params, options);}
function edit_company_path(id, format, verb){ return '/companies/' + id + '/edit' + format + '';}
function edit_company_ajax(id, format, verb, params, options){ return less_ajax('/companies/' + id + '/edit' + format + '', verb, params, options);}
function edit_company_ajaxx(id, format, verb, params, options){ return less_ajaxx('/companies/' + id + '/edit' + format + '', verb, params, options);}
function company_path(id, format, verb){ return '/companies/' + id + '' + format + '';}
function company_ajax(id, format, verb, params, options){ return less_ajax('/companies/' + id + '' + format + '', verb, params, options);}
function company_ajaxx(id, format, verb, params, options){ return less_ajaxx('/companies/' + id + '' + format + '', verb, params, options);}
function groupers_path(format, verb){ return '/groupers' + format + '';}
function groupers_ajax(format, verb, params, options){ return less_ajax('/groupers' + format + '', verb, params, options);}
function groupers_ajaxx(format, verb, params, options){ return less_ajaxx('/groupers' + format + '', verb, params, options);}
function new_grouper_path(format, verb){ return '/groupers/new' + format + '';}
function new_grouper_ajax(format, verb, params, options){ return less_ajax('/groupers/new' + format + '', verb, params, options);}
function new_grouper_ajaxx(format, verb, params, options){ return less_ajaxx('/groupers/new' + format + '', verb, params, options);}
function edit_grouper_path(id, format, verb){ return '/groupers/' + id + '/edit' + format + '';}
function edit_grouper_ajax(id, format, verb, params, options){ return less_ajax('/groupers/' + id + '/edit' + format + '', verb, params, options);}
function edit_grouper_ajaxx(id, format, verb, params, options){ return less_ajaxx('/groupers/' + id + '/edit' + format + '', verb, params, options);}
function grouper_path(id, format, verb){ return '/groupers/' + id + '' + format + '';}
function grouper_ajax(id, format, verb, params, options){ return less_ajax('/groupers/' + id + '' + format + '', verb, params, options);}
function grouper_ajaxx(id, format, verb, params, options){ return less_ajaxx('/groupers/' + id + '' + format + '', verb, params, options);}
function groups_path(format, verb){ return '/groups' + format + '';}
function groups_ajax(format, verb, params, options){ return less_ajax('/groups' + format + '', verb, params, options);}
function groups_ajaxx(format, verb, params, options){ return less_ajaxx('/groups' + format + '', verb, params, options);}
function new_group_path(format, verb){ return '/groups/new' + format + '';}
function new_group_ajax(format, verb, params, options){ return less_ajax('/groups/new' + format + '', verb, params, options);}
function new_group_ajaxx(format, verb, params, options){ return less_ajaxx('/groups/new' + format + '', verb, params, options);}
function edit_group_path(id, format, verb){ return '/groups/' + id + '/edit' + format + '';}
function edit_group_ajax(id, format, verb, params, options){ return less_ajax('/groups/' + id + '/edit' + format + '', verb, params, options);}
function edit_group_ajaxx(id, format, verb, params, options){ return less_ajaxx('/groups/' + id + '/edit' + format + '', verb, params, options);}
function group_path(id, format, verb){ return '/groups/' + id + '' + format + '';}
function group_ajax(id, format, verb, params, options){ return less_ajax('/groups/' + id + '' + format + '', verb, params, options);}
function group_ajaxx(id, format, verb, params, options){ return less_ajaxx('/groups/' + id + '' + format + '', verb, params, options);}
function adverts_path(format, verb){ return '/adverts' + format + '';}
function adverts_ajax(format, verb, params, options){ return less_ajax('/adverts' + format + '', verb, params, options);}
function adverts_ajaxx(format, verb, params, options){ return less_ajaxx('/adverts' + format + '', verb, params, options);}
function new_advert_path(format, verb){ return '/adverts/new' + format + '';}
function new_advert_ajax(format, verb, params, options){ return less_ajax('/adverts/new' + format + '', verb, params, options);}
function new_advert_ajaxx(format, verb, params, options){ return less_ajaxx('/adverts/new' + format + '', verb, params, options);}
function edit_advert_path(id, format, verb){ return '/adverts/' + id + '/edit' + format + '';}
function edit_advert_ajax(id, format, verb, params, options){ return less_ajax('/adverts/' + id + '/edit' + format + '', verb, params, options);}
function edit_advert_ajaxx(id, format, verb, params, options){ return less_ajaxx('/adverts/' + id + '/edit' + format + '', verb, params, options);}
function advert_path(id, format, verb){ return '/adverts/' + id + '' + format + '';}
function advert_ajax(id, format, verb, params, options){ return less_ajax('/adverts/' + id + '' + format + '', verb, params, options);}
function advert_ajaxx(id, format, verb, params, options){ return less_ajaxx('/adverts/' + id + '' + format + '', verb, params, options);}
function statuses_path(format, verb){ return '/statuses' + format + '';}
function statuses_ajax(format, verb, params, options){ return less_ajax('/statuses' + format + '', verb, params, options);}
function statuses_ajaxx(format, verb, params, options){ return less_ajaxx('/statuses' + format + '', verb, params, options);}
function new_status_path(format, verb){ return '/statuses/new' + format + '';}
function new_status_ajax(format, verb, params, options){ return less_ajax('/statuses/new' + format + '', verb, params, options);}
function new_status_ajaxx(format, verb, params, options){ return less_ajaxx('/statuses/new' + format + '', verb, params, options);}
function edit_status_path(id, format, verb){ return '/statuses/' + id + '/edit' + format + '';}
function edit_status_ajax(id, format, verb, params, options){ return less_ajax('/statuses/' + id + '/edit' + format + '', verb, params, options);}
function edit_status_ajaxx(id, format, verb, params, options){ return less_ajaxx('/statuses/' + id + '/edit' + format + '', verb, params, options);}
function status_path(id, format, verb){ return '/statuses/' + id + '' + format + '';}
function status_ajax(id, format, verb, params, options){ return less_ajax('/statuses/' + id + '' + format + '', verb, params, options);}
function status_ajaxx(id, format, verb, params, options){ return less_ajaxx('/statuses/' + id + '' + format + '', verb, params, options);}
function hambriefs_path(format, verb){ return '/hambriefs' + format + '';}
function hambriefs_ajax(format, verb, params, options){ return less_ajax('/hambriefs' + format + '', verb, params, options);}
function hambriefs_ajaxx(format, verb, params, options){ return less_ajaxx('/hambriefs' + format + '', verb, params, options);}
function new_hambrief_path(format, verb){ return '/hambriefs/new' + format + '';}
function new_hambrief_ajax(format, verb, params, options){ return less_ajax('/hambriefs/new' + format + '', verb, params, options);}
function new_hambrief_ajaxx(format, verb, params, options){ return less_ajaxx('/hambriefs/new' + format + '', verb, params, options);}
function edit_hambrief_path(id, format, verb){ return '/hambriefs/' + id + '/edit' + format + '';}
function edit_hambrief_ajax(id, format, verb, params, options){ return less_ajax('/hambriefs/' + id + '/edit' + format + '', verb, params, options);}
function edit_hambrief_ajaxx(id, format, verb, params, options){ return less_ajaxx('/hambriefs/' + id + '/edit' + format + '', verb, params, options);}
function hambrief_path(id, format, verb){ return '/hambriefs/' + id + '' + format + '';}
function hambrief_ajax(id, format, verb, params, options){ return less_ajax('/hambriefs/' + id + '' + format + '', verb, params, options);}
function hambrief_ajaxx(id, format, verb, params, options){ return less_ajaxx('/hambriefs/' + id + '' + format + '', verb, params, options);}
function gears_path(format, verb){ return '/gears' + format + '';}
function gears_ajax(format, verb, params, options){ return less_ajax('/gears' + format + '', verb, params, options);}
function gears_ajaxx(format, verb, params, options){ return less_ajaxx('/gears' + format + '', verb, params, options);}
function new_gear_path(format, verb){ return '/gears/new' + format + '';}
function new_gear_ajax(format, verb, params, options){ return less_ajax('/gears/new' + format + '', verb, params, options);}
function new_gear_ajaxx(format, verb, params, options){ return less_ajaxx('/gears/new' + format + '', verb, params, options);}
function edit_gear_path(id, format, verb){ return '/gears/' + id + '/edit' + format + '';}
function edit_gear_ajax(id, format, verb, params, options){ return less_ajax('/gears/' + id + '/edit' + format + '', verb, params, options);}
function edit_gear_ajaxx(id, format, verb, params, options){ return less_ajaxx('/gears/' + id + '/edit' + format + '', verb, params, options);}
function gear_path(id, format, verb){ return '/gears/' + id + '' + format + '';}
function gear_ajax(id, format, verb, params, options){ return less_ajax('/gears/' + id + '' + format + '', verb, params, options);}
function gear_ajaxx(id, format, verb, params, options){ return less_ajaxx('/gears/' + id + '' + format + '', verb, params, options);}
function repeaters_path(format, verb){ return '/repeaters' + format + '';}
function repeaters_ajax(format, verb, params, options){ return less_ajax('/repeaters' + format + '', verb, params, options);}
function repeaters_ajaxx(format, verb, params, options){ return less_ajaxx('/repeaters' + format + '', verb, params, options);}
function new_repeater_path(format, verb){ return '/repeaters/new' + format + '';}
function new_repeater_ajax(format, verb, params, options){ return less_ajax('/repeaters/new' + format + '', verb, params, options);}
function new_repeater_ajaxx(format, verb, params, options){ return less_ajaxx('/repeaters/new' + format + '', verb, params, options);}
function edit_repeater_path(id, format, verb){ return '/repeaters/' + id + '/edit' + format + '';}
function edit_repeater_ajax(id, format, verb, params, options){ return less_ajax('/repeaters/' + id + '/edit' + format + '', verb, params, options);}
function edit_repeater_ajaxx(id, format, verb, params, options){ return less_ajaxx('/repeaters/' + id + '/edit' + format + '', verb, params, options);}
function repeater_path(id, format, verb){ return '/repeaters/' + id + '' + format + '';}
function repeater_ajax(id, format, verb, params, options){ return less_ajax('/repeaters/' + id + '' + format + '', verb, params, options);}
function repeater_ajaxx(id, format, verb, params, options){ return less_ajaxx('/repeaters/' + id + '' + format + '', verb, params, options);}
function clubs_path(format, verb){ return '/clubs' + format + '';}
function clubs_ajax(format, verb, params, options){ return less_ajax('/clubs' + format + '', verb, params, options);}
function clubs_ajaxx(format, verb, params, options){ return less_ajaxx('/clubs' + format + '', verb, params, options);}
function new_club_path(format, verb){ return '/clubs/new' + format + '';}
function new_club_ajax(format, verb, params, options){ return less_ajax('/clubs/new' + format + '', verb, params, options);}
function new_club_ajaxx(format, verb, params, options){ return less_ajaxx('/clubs/new' + format + '', verb, params, options);}
function edit_club_path(id, format, verb){ return '/clubs/' + id + '/edit' + format + '';}
function edit_club_ajax(id, format, verb, params, options){ return less_ajax('/clubs/' + id + '/edit' + format + '', verb, params, options);}
function edit_club_ajaxx(id, format, verb, params, options){ return less_ajaxx('/clubs/' + id + '/edit' + format + '', verb, params, options);}
function club_path(id, format, verb){ return '/clubs/' + id + '' + format + '';}
function club_ajax(id, format, verb, params, options){ return less_ajax('/clubs/' + id + '' + format + '', verb, params, options);}
function club_ajaxx(id, format, verb, params, options){ return less_ajaxx('/clubs/' + id + '' + format + '', verb, params, options);}
function events_path(format, verb){ return '/events' + format + '';}
function events_ajax(format, verb, params, options){ return less_ajax('/events' + format + '', verb, params, options);}
function events_ajaxx(format, verb, params, options){ return less_ajaxx('/events' + format + '', verb, params, options);}
function new_event_path(format, verb){ return '/events/new' + format + '';}
function new_event_ajax(format, verb, params, options){ return less_ajax('/events/new' + format + '', verb, params, options);}
function new_event_ajaxx(format, verb, params, options){ return less_ajaxx('/events/new' + format + '', verb, params, options);}
function edit_event_path(id, format, verb){ return '/events/' + id + '/edit' + format + '';}
function edit_event_ajax(id, format, verb, params, options){ return less_ajax('/events/' + id + '/edit' + format + '', verb, params, options);}
function edit_event_ajaxx(id, format, verb, params, options){ return less_ajaxx('/events/' + id + '/edit' + format + '', verb, params, options);}
function event_path(id, format, verb){ return '/events/' + id + '' + format + '';}
function event_ajax(id, format, verb, params, options){ return less_ajax('/events/' + id + '' + format + '', verb, params, options);}
function event_ajaxx(id, format, verb, params, options){ return less_ajaxx('/events/' + id + '' + format + '', verb, params, options);}
function contacts_path(format, verb){ return '/contacts' + format + '';}
function contacts_ajax(format, verb, params, options){ return less_ajax('/contacts' + format + '', verb, params, options);}
function contacts_ajaxx(format, verb, params, options){ return less_ajaxx('/contacts' + format + '', verb, params, options);}
function new_contact_path(format, verb){ return '/contacts/new' + format + '';}
function new_contact_ajax(format, verb, params, options){ return less_ajax('/contacts/new' + format + '', verb, params, options);}
function new_contact_ajaxx(format, verb, params, options){ return less_ajaxx('/contacts/new' + format + '', verb, params, options);}
function edit_contact_path(id, format, verb){ return '/contacts/' + id + '/edit' + format + '';}
function edit_contact_ajax(id, format, verb, params, options){ return less_ajax('/contacts/' + id + '/edit' + format + '', verb, params, options);}
function edit_contact_ajaxx(id, format, verb, params, options){ return less_ajaxx('/contacts/' + id + '/edit' + format + '', verb, params, options);}
function contact_path(id, format, verb){ return '/contacts/' + id + '' + format + '';}
function contact_ajax(id, format, verb, params, options){ return less_ajax('/contacts/' + id + '' + format + '', verb, params, options);}
function contact_ajaxx(id, format, verb, params, options){ return less_ajaxx('/contacts/' + id + '' + format + '', verb, params, options);}
function reviews_path(format, verb){ return '/reviews' + format + '';}
function reviews_ajax(format, verb, params, options){ return less_ajax('/reviews' + format + '', verb, params, options);}
function reviews_ajaxx(format, verb, params, options){ return less_ajaxx('/reviews' + format + '', verb, params, options);}
function new_review_path(format, verb){ return '/reviews/new' + format + '';}
function new_review_ajax(format, verb, params, options){ return less_ajax('/reviews/new' + format + '', verb, params, options);}
function new_review_ajaxx(format, verb, params, options){ return less_ajaxx('/reviews/new' + format + '', verb, params, options);}
function edit_review_path(id, format, verb){ return '/reviews/' + id + '/edit' + format + '';}
function edit_review_ajax(id, format, verb, params, options){ return less_ajax('/reviews/' + id + '/edit' + format + '', verb, params, options);}
function edit_review_ajaxx(id, format, verb, params, options){ return less_ajaxx('/reviews/' + id + '/edit' + format + '', verb, params, options);}
function review_path(id, format, verb){ return '/reviews/' + id + '' + format + '';}
function review_ajax(id, format, verb, params, options){ return less_ajax('/reviews/' + id + '' + format + '', verb, params, options);}
function review_ajaxx(id, format, verb, params, options){ return less_ajaxx('/reviews/' + id + '' + format + '', verb, params, options);}
function directory_index_path(format, verb){ return '/directory' + format + '';}
function directory_index_ajax(format, verb, params, options){ return less_ajax('/directory' + format + '', verb, params, options);}
function directory_index_ajaxx(format, verb, params, options){ return less_ajaxx('/directory' + format + '', verb, params, options);}
function new_directory_path(format, verb){ return '/directory/new' + format + '';}
function new_directory_ajax(format, verb, params, options){ return less_ajax('/directory/new' + format + '', verb, params, options);}
function new_directory_ajaxx(format, verb, params, options){ return less_ajaxx('/directory/new' + format + '', verb, params, options);}
function edit_directory_path(id, format, verb){ return '/directory/' + id + '/edit' + format + '';}
function edit_directory_ajax(id, format, verb, params, options){ return less_ajax('/directory/' + id + '/edit' + format + '', verb, params, options);}
function edit_directory_ajaxx(id, format, verb, params, options){ return less_ajaxx('/directory/' + id + '/edit' + format + '', verb, params, options);}
function directory_path(id, format, verb){ return '/directory/' + id + '' + format + '';}
function directory_ajax(id, format, verb, params, options){ return less_ajax('/directory/' + id + '' + format + '', verb, params, options);}
function directory_ajaxx(id, format, verb, params, options){ return less_ajaxx('/directory/' + id + '' + format + '', verb, params, options);}
function home_index_path(format, verb){ return '/home' + format + '';}
function home_index_ajax(format, verb, params, options){ return less_ajax('/home' + format + '', verb, params, options);}
function home_index_ajaxx(format, verb, params, options){ return less_ajaxx('/home' + format + '', verb, params, options);}
function new_home_path(format, verb){ return '/home/new' + format + '';}
function new_home_ajax(format, verb, params, options){ return less_ajax('/home/new' + format + '', verb, params, options);}
function new_home_ajaxx(format, verb, params, options){ return less_ajaxx('/home/new' + format + '', verb, params, options);}
function edit_home_path(id, format, verb){ return '/home/' + id + '/edit' + format + '';}
function edit_home_ajax(id, format, verb, params, options){ return less_ajax('/home/' + id + '/edit' + format + '', verb, params, options);}
function edit_home_ajaxx(id, format, verb, params, options){ return less_ajaxx('/home/' + id + '/edit' + format + '', verb, params, options);}
function timelines_path(format, verb){ return '/timelines' + format + '';}
function timelines_ajax(format, verb, params, options){ return less_ajax('/timelines' + format + '', verb, params, options);}
function timelines_ajaxx(format, verb, params, options){ return less_ajaxx('/timelines' + format + '', verb, params, options);}
function new_timeline_path(format, verb){ return '/timelines/new' + format + '';}
function new_timeline_ajax(format, verb, params, options){ return less_ajax('/timelines/new' + format + '', verb, params, options);}
function new_timeline_ajaxx(format, verb, params, options){ return less_ajaxx('/timelines/new' + format + '', verb, params, options);}
function edit_timeline_path(id, format, verb){ return '/timelines/' + id + '/edit' + format + '';}
function edit_timeline_ajax(id, format, verb, params, options){ return less_ajax('/timelines/' + id + '/edit' + format + '', verb, params, options);}
function edit_timeline_ajaxx(id, format, verb, params, options){ return less_ajaxx('/timelines/' + id + '/edit' + format + '', verb, params, options);}
function timeline_path(id, format, verb){ return '/timelines/' + id + '' + format + '';}
function timeline_ajax(id, format, verb, params, options){ return less_ajax('/timelines/' + id + '' + format + '', verb, params, options);}
function timeline_ajaxx(id, format, verb, params, options){ return less_ajaxx('/timelines/' + id + '' + format + '', verb, params, options);}
function comments_path(format, verb){ return '/comments' + format + '';}
function comments_ajax(format, verb, params, options){ return less_ajax('/comments' + format + '', verb, params, options);}
function comments_ajaxx(format, verb, params, options){ return less_ajaxx('/comments' + format + '', verb, params, options);}
function new_comment_path(format, verb){ return '/comments/new' + format + '';}
function new_comment_ajax(format, verb, params, options){ return less_ajax('/comments/new' + format + '', verb, params, options);}
function new_comment_ajaxx(format, verb, params, options){ return less_ajaxx('/comments/new' + format + '', verb, params, options);}
function edit_comment_path(id, format, verb){ return '/comments/' + id + '/edit' + format + '';}
function edit_comment_ajax(id, format, verb, params, options){ return less_ajax('/comments/' + id + '/edit' + format + '', verb, params, options);}
function edit_comment_ajaxx(id, format, verb, params, options){ return less_ajaxx('/comments/' + id + '/edit' + format + '', verb, params, options);}
function comment_path(id, format, verb){ return '/comments/' + id + '' + format + '';}
function comment_ajax(id, format, verb, params, options){ return less_ajax('/comments/' + id + '' + format + '', verb, params, options);}
function comment_ajaxx(id, format, verb, params, options){ return less_ajaxx('/comments/' + id + '' + format + '', verb, params, options);}
function search_admin_users_path(format, verb){ return '/admin/users/search' + format + '';}
function search_admin_users_ajax(format, verb, params, options){ return less_ajax('/admin/users/search' + format + '', verb, params, options);}
function search_admin_users_ajaxx(format, verb, params, options){ return less_ajaxx('/admin/users/search' + format + '', verb, params, options);}
function admin_users_path(format, verb){ return '/admin/users' + format + '';}
function admin_users_ajax(format, verb, params, options){ return less_ajax('/admin/users' + format + '', verb, params, options);}
function admin_users_ajaxx(format, verb, params, options){ return less_ajaxx('/admin/users' + format + '', verb, params, options);}
function new_admin_user_path(format, verb){ return '/admin/users/new' + format + '';}
function new_admin_user_ajax(format, verb, params, options){ return less_ajax('/admin/users/new' + format + '', verb, params, options);}
function new_admin_user_ajaxx(format, verb, params, options){ return less_ajaxx('/admin/users/new' + format + '', verb, params, options);}
function edit_admin_user_path(id, format, verb){ return '/admin/users/' + id + '/edit' + format + '';}
function edit_admin_user_ajax(id, format, verb, params, options){ return less_ajax('/admin/users/' + id + '/edit' + format + '', verb, params, options);}
function edit_admin_user_ajaxx(id, format, verb, params, options){ return less_ajaxx('/admin/users/' + id + '/edit' + format + '', verb, params, options);}
function admin_user_path(id, format, verb){ return '/admin/users/' + id + '' + format + '';}
function admin_user_ajax(id, format, verb, params, options){ return less_ajax('/admin/users/' + id + '' + format + '', verb, params, options);}
function admin_user_ajaxx(id, format, verb, params, options){ return less_ajaxx('/admin/users/' + id + '' + format + '', verb, params, options);}
function redir_path(verb){ return '/adverts/redir';}
function redir_ajax(verb, params, options){ return less_ajax('/adverts/redir', verb, params, options);}
function redir_ajaxx(verb, params, options){ return less_ajaxx('/adverts/redir', verb, params, options);}
function forum_topic_posts_path(forum_id, topic_id, format, verb){ return '/forums/' + forum_id + '/topics/' + topic_id + '/posts' + format + '';}
function forum_topic_posts_ajax(forum_id, topic_id, format, verb, params, options){ return less_ajax('/forums/' + forum_id + '/topics/' + topic_id + '/posts' + format + '', verb, params, options);}
function forum_topic_posts_ajaxx(forum_id, topic_id, format, verb, params, options){ return less_ajaxx('/forums/' + forum_id + '/topics/' + topic_id + '/posts' + format + '', verb, params, options);}
function new_forum_topic_post_path(forum_id, topic_id, format, verb){ return '/forums/' + forum_id + '/topics/' + topic_id + '/posts/new' + format + '';}
function new_forum_topic_post_ajax(forum_id, topic_id, format, verb, params, options){ return less_ajax('/forums/' + forum_id + '/topics/' + topic_id + '/posts/new' + format + '', verb, params, options);}
function new_forum_topic_post_ajaxx(forum_id, topic_id, format, verb, params, options){ return less_ajaxx('/forums/' + forum_id + '/topics/' + topic_id + '/posts/new' + format + '', verb, params, options);}
function edit_forum_topic_post_path(forum_id, topic_id, id, format, verb){ return '/forums/' + forum_id + '/topics/' + topic_id + '/posts/' + id + '/edit' + format + '';}
function edit_forum_topic_post_ajax(forum_id, topic_id, id, format, verb, params, options){ return less_ajax('/forums/' + forum_id + '/topics/' + topic_id + '/posts/' + id + '/edit' + format + '', verb, params, options);}
function edit_forum_topic_post_ajaxx(forum_id, topic_id, id, format, verb, params, options){ return less_ajaxx('/forums/' + forum_id + '/topics/' + topic_id + '/posts/' + id + '/edit' + format + '', verb, params, options);}
function forum_topic_post_path(forum_id, topic_id, id, format, verb){ return '/forums/' + forum_id + '/topics/' + topic_id + '/posts/' + id + '' + format + '';}
function forum_topic_post_ajax(forum_id, topic_id, id, format, verb, params, options){ return less_ajax('/forums/' + forum_id + '/topics/' + topic_id + '/posts/' + id + '' + format + '', verb, params, options);}
function forum_topic_post_ajaxx(forum_id, topic_id, id, format, verb, params, options){ return less_ajaxx('/forums/' + forum_id + '/topics/' + topic_id + '/posts/' + id + '' + format + '', verb, params, options);}
function forum_topics_path(forum_id, format, verb){ return '/forums/' + forum_id + '/topics' + format + '';}
function forum_topics_ajax(forum_id, format, verb, params, options){ return less_ajax('/forums/' + forum_id + '/topics' + format + '', verb, params, options);}
function forum_topics_ajaxx(forum_id, format, verb, params, options){ return less_ajaxx('/forums/' + forum_id + '/topics' + format + '', verb, params, options);}
function new_forum_topic_path(forum_id, format, verb){ return '/forums/' + forum_id + '/topics/new' + format + '';}
function new_forum_topic_ajax(forum_id, format, verb, params, options){ return less_ajax('/forums/' + forum_id + '/topics/new' + format + '', verb, params, options);}
function new_forum_topic_ajaxx(forum_id, format, verb, params, options){ return less_ajaxx('/forums/' + forum_id + '/topics/new' + format + '', verb, params, options);}
function edit_forum_topic_path(forum_id, id, format, verb){ return '/forums/' + forum_id + '/topics/' + id + '/edit' + format + '';}
function edit_forum_topic_ajax(forum_id, id, format, verb, params, options){ return less_ajax('/forums/' + forum_id + '/topics/' + id + '/edit' + format + '', verb, params, options);}
function edit_forum_topic_ajaxx(forum_id, id, format, verb, params, options){ return less_ajaxx('/forums/' + forum_id + '/topics/' + id + '/edit' + format + '', verb, params, options);}
function forum_topic_path(forum_id, id, format, verb){ return '/forums/' + forum_id + '/topics/' + id + '' + format + '';}
function forum_topic_ajax(forum_id, id, format, verb, params, options){ return less_ajax('/forums/' + forum_id + '/topics/' + id + '' + format + '', verb, params, options);}
function forum_topic_ajaxx(forum_id, id, format, verb, params, options){ return less_ajaxx('/forums/' + forum_id + '/topics/' + id + '' + format + '', verb, params, options);}
function forums_path(format, verb){ return '/forums' + format + '';}
function forums_ajax(format, verb, params, options){ return less_ajax('/forums' + format + '', verb, params, options);}
function forums_ajaxx(format, verb, params, options){ return less_ajaxx('/forums' + format + '', verb, params, options);}
function new_forum_path(format, verb){ return '/forums/new' + format + '';}
function new_forum_ajax(format, verb, params, options){ return less_ajax('/forums/new' + format + '', verb, params, options);}
function new_forum_ajaxx(format, verb, params, options){ return less_ajaxx('/forums/new' + format + '', verb, params, options);}
function edit_forum_path(id, format, verb){ return '/forums/' + id + '/edit' + format + '';}
function edit_forum_ajax(id, format, verb, params, options){ return less_ajax('/forums/' + id + '/edit' + format + '', verb, params, options);}
function edit_forum_ajaxx(id, format, verb, params, options){ return less_ajaxx('/forums/' + id + '/edit' + format + '', verb, params, options);}
function forum_path(id, format, verb){ return '/forums/' + id + '' + format + '';}
function forum_ajax(id, format, verb, params, options){ return less_ajax('/forums/' + id + '' + format + '', verb, params, options);}
function forum_ajaxx(id, format, verb, params, options){ return less_ajaxx('/forums/' + id + '' + format + '', verb, params, options);}
function profile_friends_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/friends' + format + '';}
function profile_friends_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/friends' + format + '', verb, params, options);}
function profile_friends_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/friends' + format + '', verb, params, options);}
function new_profile_friend_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/friends/new' + format + '';}
function new_profile_friend_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/friends/new' + format + '', verb, params, options);}
function new_profile_friend_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/friends/new' + format + '', verb, params, options);}
function edit_profile_friend_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/friends/' + id + '/edit' + format + '';}
function edit_profile_friend_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/friends/' + id + '/edit' + format + '', verb, params, options);}
function edit_profile_friend_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/friends/' + id + '/edit' + format + '', verb, params, options);}
function profile_friend_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/friends/' + id + '' + format + '';}
function profile_friend_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/friends/' + id + '' + format + '', verb, params, options);}
function profile_friend_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/friends/' + id + '' + format + '', verb, params, options);}
function profile_blogs_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/blogs' + format + '';}
function profile_blogs_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/blogs' + format + '', verb, params, options);}
function profile_blogs_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/blogs' + format + '', verb, params, options);}
function new_profile_blog_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/blogs/new' + format + '';}
function new_profile_blog_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/blogs/new' + format + '', verb, params, options);}
function new_profile_blog_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/blogs/new' + format + '', verb, params, options);}
function edit_profile_blog_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/blogs/' + id + '/edit' + format + '';}
function edit_profile_blog_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/blogs/' + id + '/edit' + format + '', verb, params, options);}
function edit_profile_blog_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/blogs/' + id + '/edit' + format + '', verb, params, options);}
function profile_blog_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/blogs/' + id + '' + format + '';}
function profile_blog_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/blogs/' + id + '' + format + '', verb, params, options);}
function profile_blog_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/blogs/' + id + '' + format + '', verb, params, options);}
function profile_photos_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/photos' + format + '';}
function profile_photos_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/photos' + format + '', verb, params, options);}
function profile_photos_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/photos' + format + '', verb, params, options);}
function new_profile_photo_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/photos/new' + format + '';}
function new_profile_photo_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/photos/new' + format + '', verb, params, options);}
function new_profile_photo_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/photos/new' + format + '', verb, params, options);}
function edit_profile_photo_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/photos/' + id + '/edit' + format + '';}
function edit_profile_photo_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/photos/' + id + '/edit' + format + '', verb, params, options);}
function edit_profile_photo_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/photos/' + id + '/edit' + format + '', verb, params, options);}
function profile_photo_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/photos/' + id + '' + format + '';}
function profile_photo_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/photos/' + id + '' + format + '', verb, params, options);}
function profile_photo_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/photos/' + id + '' + format + '', verb, params, options);}
function profile_comments_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/comments' + format + '';}
function profile_comments_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/comments' + format + '', verb, params, options);}
function profile_comments_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/comments' + format + '', verb, params, options);}
function new_profile_comment_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/comments/new' + format + '';}
function new_profile_comment_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/comments/new' + format + '', verb, params, options);}
function new_profile_comment_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/comments/new' + format + '', verb, params, options);}
function edit_profile_comment_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/comments/' + id + '/edit' + format + '';}
function edit_profile_comment_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/comments/' + id + '/edit' + format + '', verb, params, options);}
function edit_profile_comment_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/comments/' + id + '/edit' + format + '', verb, params, options);}
function profile_comment_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/comments/' + id + '' + format + '';}
function profile_comment_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/comments/' + id + '' + format + '', verb, params, options);}
function profile_comment_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/comments/' + id + '' + format + '', verb, params, options);}
function profile_feed_items_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/feed_items' + format + '';}
function profile_feed_items_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/feed_items' + format + '', verb, params, options);}
function profile_feed_items_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/feed_items' + format + '', verb, params, options);}
function new_profile_feed_item_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/feed_items/new' + format + '';}
function new_profile_feed_item_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/feed_items/new' + format + '', verb, params, options);}
function new_profile_feed_item_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/feed_items/new' + format + '', verb, params, options);}
function edit_profile_feed_item_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/feed_items/' + id + '/edit' + format + '';}
function edit_profile_feed_item_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/feed_items/' + id + '/edit' + format + '', verb, params, options);}
function edit_profile_feed_item_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/feed_items/' + id + '/edit' + format + '', verb, params, options);}
function profile_feed_item_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/feed_items/' + id + '' + format + '';}
function profile_feed_item_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/feed_items/' + id + '' + format + '', verb, params, options);}
function profile_feed_item_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/feed_items/' + id + '' + format + '', verb, params, options);}
function profile_messages_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/messages' + format + '';}
function profile_messages_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/messages' + format + '', verb, params, options);}
function profile_messages_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/messages' + format + '', verb, params, options);}
function new_profile_message_path(profile_id, format, verb){ return '/profiles/' + profile_id + '/messages/new' + format + '';}
function new_profile_message_ajax(profile_id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/messages/new' + format + '', verb, params, options);}
function new_profile_message_ajaxx(profile_id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/messages/new' + format + '', verb, params, options);}
function edit_profile_message_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/messages/' + id + '/edit' + format + '';}
function edit_profile_message_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/messages/' + id + '/edit' + format + '', verb, params, options);}
function edit_profile_message_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/messages/' + id + '/edit' + format + '', verb, params, options);}
function profile_message_path(profile_id, id, format, verb){ return '/profiles/' + profile_id + '/messages/' + id + '' + format + '';}
function profile_message_ajax(profile_id, id, format, verb, params, options){ return less_ajax('/profiles/' + profile_id + '/messages/' + id + '' + format + '', verb, params, options);}
function profile_message_ajaxx(profile_id, id, format, verb, params, options){ return less_ajaxx('/profiles/' + profile_id + '/messages/' + id + '' + format + '', verb, params, options);}
function search_profiles_path(format, verb){ return '/profiles/search' + format + '';}
function search_profiles_ajax(format, verb, params, options){ return less_ajax('/profiles/search' + format + '', verb, params, options);}
function search_profiles_ajaxx(format, verb, params, options){ return less_ajaxx('/profiles/search' + format + '', verb, params, options);}
function profiles_path(format, verb){ return '/profiles' + format + '';}
function profiles_ajax(format, verb, params, options){ return less_ajax('/profiles' + format + '', verb, params, options);}
function profiles_ajaxx(format, verb, params, options){ return less_ajaxx('/profiles' + format + '', verb, params, options);}
function new_profile_path(format, verb){ return '/profiles/new' + format + '';}
function new_profile_ajax(format, verb, params, options){ return less_ajax('/profiles/new' + format + '', verb, params, options);}
function new_profile_ajaxx(format, verb, params, options){ return less_ajaxx('/profiles/new' + format + '', verb, params, options);}
function edit_profile_path(id, format, verb){ return '/profiles/' + id + '/edit' + format + '';}
function edit_profile_ajax(id, format, verb, params, options){ return less_ajax('/profiles/' + id + '/edit' + format + '', verb, params, options);}
function edit_profile_ajaxx(id, format, verb, params, options){ return less_ajaxx('/profiles/' + id + '/edit' + format + '', verb, params, options);}
function delete_icon_profile_path(id, format, verb){ return '/profiles/' + id + '/delete_icon' + format + '';}
function delete_icon_profile_ajax(id, format, verb, params, options){ return less_ajax('/profiles/' + id + '/delete_icon' + format + '', verb, params, options);}
function delete_icon_profile_ajaxx(id, format, verb, params, options){ return less_ajaxx('/profiles/' + id + '/delete_icon' + format + '', verb, params, options);}
function profile_path(id, format, verb){ return '/profiles/' + id + '' + format + '';}
function profile_ajax(id, format, verb, params, options){ return less_ajax('/profiles/' + id + '' + format + '', verb, params, options);}
function profile_ajaxx(id, format, verb, params, options){ return less_ajaxx('/profiles/' + id + '' + format + '', verb, params, options);}
function sent_messages_path(format, verb){ return '/messages/sent' + format + '';}
function sent_messages_ajax(format, verb, params, options){ return less_ajax('/messages/sent' + format + '', verb, params, options);}
function sent_messages_ajaxx(format, verb, params, options){ return less_ajaxx('/messages/sent' + format + '', verb, params, options);}
function messages_path(format, verb){ return '/messages' + format + '';}
function messages_ajax(format, verb, params, options){ return less_ajax('/messages' + format + '', verb, params, options);}
function messages_ajaxx(format, verb, params, options){ return less_ajaxx('/messages' + format + '', verb, params, options);}
function new_message_path(format, verb){ return '/messages/new' + format + '';}
function new_message_ajax(format, verb, params, options){ return less_ajax('/messages/new' + format + '', verb, params, options);}
function new_message_ajaxx(format, verb, params, options){ return less_ajaxx('/messages/new' + format + '', verb, params, options);}
function edit_message_path(id, format, verb){ return '/messages/' + id + '/edit' + format + '';}
function edit_message_ajax(id, format, verb, params, options){ return less_ajax('/messages/' + id + '/edit' + format + '', verb, params, options);}
function edit_message_ajaxx(id, format, verb, params, options){ return less_ajaxx('/messages/' + id + '/edit' + format + '', verb, params, options);}
function message_path(id, format, verb){ return '/messages/' + id + '' + format + '';}
function message_ajax(id, format, verb, params, options){ return less_ajax('/messages/' + id + '' + format + '', verb, params, options);}
function message_ajaxx(id, format, verb, params, options){ return less_ajaxx('/messages/' + id + '' + format + '', verb, params, options);}
function blog_comments_path(blog_id, format, verb){ return '/blogs/' + blog_id + '/comments' + format + '';}
function blog_comments_ajax(blog_id, format, verb, params, options){ return less_ajax('/blogs/' + blog_id + '/comments' + format + '', verb, params, options);}
function blog_comments_ajaxx(blog_id, format, verb, params, options){ return less_ajaxx('/blogs/' + blog_id + '/comments' + format + '', verb, params, options);}
function new_blog_comment_path(blog_id, format, verb){ return '/blogs/' + blog_id + '/comments/new' + format + '';}
function new_blog_comment_ajax(blog_id, format, verb, params, options){ return less_ajax('/blogs/' + blog_id + '/comments/new' + format + '', verb, params, options);}
function new_blog_comment_ajaxx(blog_id, format, verb, params, options){ return less_ajaxx('/blogs/' + blog_id + '/comments/new' + format + '', verb, params, options);}
function edit_blog_comment_path(blog_id, id, format, verb){ return '/blogs/' + blog_id + '/comments/' + id + '/edit' + format + '';}
function edit_blog_comment_ajax(blog_id, id, format, verb, params, options){ return less_ajax('/blogs/' + blog_id + '/comments/' + id + '/edit' + format + '', verb, params, options);}
function edit_blog_comment_ajaxx(blog_id, id, format, verb, params, options){ return less_ajaxx('/blogs/' + blog_id + '/comments/' + id + '/edit' + format + '', verb, params, options);}
function blog_comment_path(blog_id, id, format, verb){ return '/blogs/' + blog_id + '/comments/' + id + '' + format + '';}
function blog_comment_ajax(blog_id, id, format, verb, params, options){ return less_ajax('/blogs/' + blog_id + '/comments/' + id + '' + format + '', verb, params, options);}
function blog_comment_ajaxx(blog_id, id, format, verb, params, options){ return less_ajaxx('/blogs/' + blog_id + '/comments/' + id + '' + format + '', verb, params, options);}
function blogs_path(format, verb){ return '/blogs' + format + '';}
function blogs_ajax(format, verb, params, options){ return less_ajax('/blogs' + format + '', verb, params, options);}
function blogs_ajaxx(format, verb, params, options){ return less_ajaxx('/blogs' + format + '', verb, params, options);}
function new_blog_path(format, verb){ return '/blogs/new' + format + '';}
function new_blog_ajax(format, verb, params, options){ return less_ajax('/blogs/new' + format + '', verb, params, options);}
function new_blog_ajaxx(format, verb, params, options){ return less_ajaxx('/blogs/new' + format + '', verb, params, options);}
function edit_blog_path(id, format, verb){ return '/blogs/' + id + '/edit' + format + '';}
function edit_blog_ajax(id, format, verb, params, options){ return less_ajax('/blogs/' + id + '/edit' + format + '', verb, params, options);}
function edit_blog_ajaxx(id, format, verb, params, options){ return less_ajaxx('/blogs/' + id + '/edit' + format + '', verb, params, options);}
function blog_path(id, format, verb){ return '/blogs/' + id + '' + format + '';}
function blog_ajax(id, format, verb, params, options){ return less_ajax('/blogs/' + id + '' + format + '', verb, params, options);}
function blog_ajaxx(id, format, verb, params, options){ return less_ajaxx('/blogs/' + id + '' + format + '', verb, params, options);}
function login_path(verb){ return '/login';}
function login_ajax(verb, params, options){ return less_ajax('/login', verb, params, options);}
function login_ajaxx(verb, params, options){ return less_ajaxx('/login', verb, params, options);}
function logout_path(verb){ return '/logout';}
function logout_ajax(verb, params, options){ return less_ajax('/logout', verb, params, options);}
function logout_ajaxx(verb, params, options){ return less_ajaxx('/logout', verb, params, options);}
function signup_path(verb){ return '/signup';}
function signup_ajax(verb, params, options){ return less_ajax('/signup', verb, params, options);}
function signup_ajaxx(verb, params, options){ return less_ajaxx('/signup', verb, params, options);}
function state_select_path(verb){ return '/state_select';}
function state_select_ajax(verb, params, options){ return less_ajax('/state_select', verb, params, options);}
function state_select_ajaxx(verb, params, options){ return less_ajaxx('/state_select', verb, params, options);}
function map_path(verb){ return '/map';}
function map_ajax(verb, params, options){ return less_ajax('/map', verb, params, options);}
function map_ajaxx(verb, params, options){ return less_ajaxx('/map', verb, params, options);}
function upload_path(verb){ return '/upload';}
function upload_ajax(verb, params, options){ return less_ajax('/upload', verb, params, options);}
function upload_ajaxx(verb, params, options){ return less_ajaxx('/upload', verb, params, options);}
function best_path(verb){ return '/best';}
function best_ajax(verb, params, options){ return less_ajax('/best', verb, params, options);}
function best_ajaxx(verb, params, options){ return less_ajaxx('/best', verb, params, options);}
function popular_path(verb){ return '/popular';}
function popular_ajax(verb, params, options){ return less_ajax('/popular', verb, params, options);}
function popular_ajaxx(verb, params, options){ return less_ajaxx('/popular', verb, params, options);}
function worst_path(verb){ return '/worst';}
function worst_ajax(verb, params, options){ return less_ajax('/worst', verb, params, options);}
function worst_ajaxx(verb, params, options){ return less_ajaxx('/worst', verb, params, options);}
function main_path(verb){ return '/index';}
function main_ajax(verb, params, options){ return less_ajax('/index', verb, params, options);}
function main_ajaxx(verb, params, options){ return less_ajaxx('/index', verb, params, options);}
function newest_path(verb){ return '/newest';}
function newest_ajax(verb, params, options){ return less_ajax('/newest', verb, params, options);}
function newest_ajaxx(verb, params, options){ return less_ajaxx('/newest', verb, params, options);}
function twitterview_path(verb){ return '/twitterview';}
function twitterview_ajax(verb, params, options){ return less_ajax('/twitterview', verb, params, options);}
function twitterview_ajaxx(verb, params, options){ return less_ajaxx('/twitterview', verb, params, options);}
function skype_path(verb){ return '/skype';}
function skype_ajax(verb, params, options){ return less_ajax('/skype', verb, params, options);}
function skype_ajaxx(verb, params, options){ return less_ajaxx('/skype', verb, params, options);}
function aprs_path(verb){ return '/aprs';}
function aprs_ajax(verb, params, options){ return less_ajax('/aprs', verb, params, options);}
function aprs_ajaxx(verb, params, options){ return less_ajaxx('/aprs', verb, params, options);}
function home_path(verb){ return '';}
function home_ajax(verb, params, options){ return less_ajax('', verb, params, options);}
function home_ajaxx(verb, params, options){ return less_ajaxx('', verb, params, options);}
function latest_comments_path(verb){ return '/latest_comments.rss';}
function latest_comments_ajax(verb, params, options){ return less_ajax('/latest_comments.rss', verb, params, options);}
function latest_comments_ajaxx(verb, params, options){ return less_ajaxx('/latest_comments.rss', verb, params, options);}
function newest_members_path(verb){ return '/newest_members.rss';}
function newest_members_ajax(verb, params, options){ return less_ajax('/newest_members.rss', verb, params, options);}
function newest_members_ajaxx(verb, params, options){ return less_ajaxx('/newest_members.rss', verb, params, options);}
function tos_path(verb){ return '/tos';}
function tos_ajax(verb, params, options){ return less_ajax('/tos', verb, params, options);}
function tos_ajaxx(verb, params, options){ return less_ajaxx('/tos', verb, params, options);}
function aboutus_path(verb){ return '/aboutus';}
function aboutus_ajax(verb, params, options){ return less_ajax('/aboutus', verb, params, options);}
function aboutus_ajaxx(verb, params, options){ return less_ajaxx('/aboutus', verb, params, options);}
function sitesearch_path(verb){ return '/sitesearch';}
function sitesearch_ajax(verb, params, options){ return less_ajax('/sitesearch', verb, params, options);}
function sitesearch_ajaxx(verb, params, options){ return less_ajaxx('/sitesearch', verb, params, options);}
function about_path(verb){ return '/widget';}
function about_ajax(verb, params, options){ return less_ajax('/widget', verb, params, options);}
function about_ajaxx(verb, params, options){ return less_ajaxx('/widget', verb, params, options);}
function unsubscribe_path(verb){ return '/unsubscribe';}
function unsubscribe_ajax(verb, params, options){ return less_ajax('/unsubscribe', verb, params, options);}
function unsubscribe_ajaxx(verb, params, options){ return less_ajaxx('/unsubscribe', verb, params, options);}
function taf_path(verb){ return '/taf';}
function taf_ajax(verb, params, options){ return less_ajax('/taf', verb, params, options);}
function taf_ajaxx(verb, params, options){ return less_ajaxx('/taf', verb, params, options);}
function tafmail_path(verb){ return '/tafmail';}
function tafmail_ajax(verb, params, options){ return less_ajax('/tafmail', verb, params, options);}
function tafmail_ajaxx(verb, params, options){ return less_ajaxx('/tafmail', verb, params, options);}
function callsign_path(callsign, verb){ return '/callsign/' + callsign + '';}
function callsign_ajax(callsign, verb, params, options){ return less_ajax('/callsign/' + callsign + '', verb, params, options);}
function callsign_ajaxx(callsign, verb, params, options){ return less_ajaxx('/callsign/' + callsign + '', verb, params, options);}
function confirm_path(verb){ return '/confirm';}
function confirm_ajax(verb, params, options){ return less_ajax('/confirm', verb, params, options);}
function confirm_ajaxx(verb, params, options){ return less_ajaxx('/confirm', verb, params, options);}
