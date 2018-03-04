import pandas as pd

kdd_names = \
(pd.read_csv("kddcup.names", skiprows=1, header=None)
 .loc[:, 0]
 .map(lambda i: i.split(":")[0])
 .values
 .tolist()
)

pd.DataFrame(None, columns=kdd_names).to_csv('kdd.csv', index=False)
