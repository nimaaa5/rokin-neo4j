//articles_by_keywords

// return the similar articles by their keywords and sort them by the sum of their defined keywords scores with limit

MATCH path = (a:Article)-[r:CONTAINS]->(k:Keyword)
WHERE k.body IN ['plm', 'product development', 'ptc']    // define the list of keywords to check an article have one or more of these keywords
WITH a, collect(k.body) as k_body, collect(r.score) as col_score, sum(r.score) as sc // group the keywords by their article and calculate the sum of their scores
RETURN a, k_body, col_score, sc ORDER BY sc DESC LIMIT $limit  // retrieve the articles by their collected scores of their keywords and sort them in descending order and limit them to $limit 