
// With this query we can simply creating a cosin_similiarity relationships between two article nodes.
// Note: With this methods, first we should define the relationships in the json files and then locate these files in the file system of neo4j with the following address.
// /var/lib/neo4j/import

CALL apoc.periodic.iterate(
	"CALL apoc.load.json('file:///ge_rel14.json') YIELD value
     MATCH (a:Article{id:value.id1})
     MATCH (b:Article{id:value.id2})
     WHERE NOT EXISTS((a)-[:SIMILARITY]-(b))
     RETURN a,b, value.cosine_similarity AS cos",
	"CREATE (a)-[:SIMILARITY{cosine_similarity:cos}]->(b)",
	{batchSize:1000, parallel:false})
    