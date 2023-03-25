import pandas as pd
data = pd.read_csv('result.txt',sep='\s+',header=None)
data = pd.DataFrame(data)
x = [1000 * i for i in range(0, 8)]

import matplotlib.pyplot as plt
y_throughput = data[0]

plt.plot(x, y_throughput,'r--')
plt.title("Throughput per Packet Size")
plt.xlabel('Packet Size')
plt.ylabel('Throughput')

plt.show()