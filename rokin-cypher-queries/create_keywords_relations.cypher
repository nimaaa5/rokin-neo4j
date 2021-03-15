
CALL apoc.periodic.iterate("CALL apoc.load.json('file://data.json') YIELD value     
MATCH (a:Keyword{body:value.keyword})    
MATCH (b:Keyword{body:value.sim_keyword})    
WHERE NOT EXISTS((a)-[:RELATED_TO]-(b)) 
RETURN a,b, value.score AS sc",	
"CREATE (a)-[:RELATED_TO{score:sc}]->(b)",{batchSize:1000, parallel:false})