import os
os.chdir("/home/data/")

import pandas as pd
import numpy as np

# Create a large dataframe
letters = pd.Series(list('ABCD'))
df = pd.DataFrame(data=np.random.randn(10**7, 10), 
                  columns=[letters.sample(1).iloc[0] + str(i).zfill(2) for i in range(10)])

# Create a couple of categorical columns
df.iloc[:, 0] = pd.cut(df.iloc[:, 0], 6, labels=['EN', 'RU', 'PO', 'AR', 'FR', 'ES'])
df.iloc[:, 1] = pd.cut(df.iloc[:, 1], 4, labels=['Ignore', 'Alert', 'Critical', 'Shutdown'])

# Significant digits reduction
df = df.applymap(lambda x: round(x, 2) if type(x) != str else x)

# Save as csv to test with tools
df.to_csv('fromPandas.csv', index=False)

