
// create articles from json file 

CALL apoc.periodic.iterate("CALL apoc.load.json('file:///data.json') YIELD value",	
"CREATE (a:Article{id:value.id, title:value.title, text:value.text, url:value.url, date:value.date})",{batchSize:1000, parallel:true})