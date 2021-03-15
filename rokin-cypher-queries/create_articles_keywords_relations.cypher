
// create relationships between articles and keywords from json file.

CALL apoc.periodic.iterate("CALL apoc.load.json('file:///keyw_scores.json') YIELD value     
MATCH (a:Articles{id:value.id})    
MATCH (b:Keyword{body:value.keyword})    
WHERE NOT EXISTS((a)-[:CONTAINS]-(b)) 
RETURN a,b, value.scores AS sc",	
"CREATE (a)-[:CONTAINS{score:sc}]->(b)",{batchSize:1000, parallel:false})