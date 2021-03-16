import json
from datetime import datetime
import numpy as np
import pandas as pd
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import pairwise_kernels

if __name__ == '__main__':
    with open('german_articles.json') as f:
        data = json.load(f)

    df = pd.DataFrame(data)
    ls_text = df['text']


    def calculate_tf_idf(list1):
        global vectorizer
        now0 = datetime.now()
        if "vectorizer" not in globals():
            print("calc vectorizer")
            vectorizer = TfidfVectorizer(ngram_range=(1, 2), min_df=3, lowercase=True)
        docs_transformed = None
        if "docs_transformed" not in globals():
            docs_transformed = vectorizer.fit_transform(list1)

        print(datetime.now() - now0)

        return docs_transformed


    docs_transformed = calculate_tf_idf(ls_text)
    # now0 = datetime.now()
    # cos = pairwise_kernels(docs_transformed[0:1000, :], docs_transformed, n_jobs=100, metric='cosine')
    # print(datetime.now() - now0)

    df_rel = pd.DataFrame(columns=['id1', 'id2', 'cosine_similarity'])
    now0 = datetime.now()
    for i in range(0, df.shape[0]):
        now1 = datetime.now()
        cos = pairwise_kernels(docs_transformed[i * 1000: (i + 1) * 1000, :], docs_transformed, n_jobs=100,
                               metric='cosine')
        for j in range(0, len(cos)):
            cos[j] = np.round(cos[j], decimals=3)
            indices = cos[j].argsort()[-21:][::-1]
            z = 0
            for idx in indices:
                if idx != i * 1000 + j:
                    df_rel.loc[(i * 20000) + j * (len(indices) - 1) + z] = [df['id'][i * 1000 + j]] + [
                        df['id'][idx]] + [cos[j][idx]]
                    z += 1
        print("Time of {} is {}".format(i, datetime.now() - now1))
        if i % 5 == 4:
            df_rel.to_json(r'ge_rel' + str(i) + '.json', orient='records')
            df_rel = pd.DataFrame(columns=['id1', 'id2', 'cosine_similarity'])
    print(datetime.now() - now0)
