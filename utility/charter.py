import pandas as pd
data = pd.read_csv('result.txt',sep='\s+',header=None)
data = pd.DataFrame(data)
x = [0.000001 * i for i in range(1, 11)]
print(x)

import matplotlib.pyplot as plt
y_throughput = data[0]
y_ratio = data[1]
y_avg = data[2]

plt.subplot(2, 2, 1) # row 1, col 2 index 1
plt.plot(x, y_throughput,'r--')
plt.title("Throughput per Error rate")
plt.xlabel('Error rate')
plt.ylabel('Throughput')


plt.subplot(2, 2, 2) # row 1, col 2 index 1
plt.plot(x, y_ratio,'r--')
plt.title("PTR per Error rate")
plt.xlabel('Error rate')
plt.ylabel('Ratio')

plt.subplot(2, 2, 3) # row 1, col 2 index 1
plt.plot(x, y_avg,'r--')
plt.title("Avg E2E per Error rate")
plt.xlabel('Error rate')
plt.ylabel('Avg delay')

plt.show()