
// return similar articles to a custom article that is one to three steps away from that article. 
// more details: For an article with a desired id $article_id, it return all the paths with 1 to 3 lengths 
// and then calculate the sum of the inverse of the cosine similarity values and store them in totalSimilarity variable.
// Afterwards, it finds the path with minimum value of totoalSimilarity.
// Finally it returns all the similar articles by the minSimilarity and limit

MATCH path = (a:Article)-[:SIMILARITY*1..3]-(a2:Article)
WHERE a.id = $article_id 
WITH a, a2, reduce(total=0, h in relationships(path) |total + (1/h.cosine_similarity)) as totalSimilarity, nodes(path) as hops
WITH a, a2.id as similarArticle, min(totalSimilarity) as minSimilarity, hops
UNWIND hops as hop
RETURN DISTINCT similarArticle, minSimilarity, collect(hop.id)
ORDER BY minSimilarity 
LIMIT $limit

