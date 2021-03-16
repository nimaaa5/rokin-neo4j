import pandas as pd
import numpy as np
from gensim.models import Word2Vec, KeyedVectors

if __name__ == '__main__':
    data = pd.read_json(r'article_data_english_november_from_2015_bert2tag_kp50_complete_26.01_postprocessed.json')
    data = data.values.flatten()
    data = data[data != np.array(None)]
    data = pd.DataFrame(data).drop_duplicates().values
    data = data.flatten()

    wv = KeyedVectors.load("w2v-nov-eng-2015-sg.wordvectors")

    from datetime import datetime

    j = 0
    df = pd.DataFrame(columns=['keyword', 'sim_keyword', 'score'])
    for i in range(0, data.shape[0]):
        try:
            t1 = datetime.now()
            sim = wv.most_similar(positive=[data[i]], negative=[], topn=30)
            for s in sim:
                df.loc[j] = [data[i]] + [s[0]] + [s[1]]
                j += 1
            print(datetime.now() - t1)
        except KeyError:
            print('Error')
        if i % 5000 == 0:
            df.to_json('k2k' + str(i) + '.json', orient='records')
            df = pd.DataFrame(columns=['keyword', 'sim_keyword', 'score'])
            print('{0} is done '.format(i))