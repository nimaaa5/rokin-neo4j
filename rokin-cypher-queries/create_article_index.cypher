
// create index to improve searching articles

CREATE INDEX index_article_id FOR (a:Article) ON (n.id)