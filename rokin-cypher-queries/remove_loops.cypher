
// It may sometimes happen that loops are formed during the relationship creating process. 
// This query ensures that there are no loops in our graph.
// For example: a->a or a->b->a

call apoc.periodic.iterate("MATCH (a:Article)-[:SIMILARITY]->(b:Article)-[r:SIMILARITY]->(a:Article) return r", "DELETE r", {batchSize:1000})
yield batches, total return batches, total  