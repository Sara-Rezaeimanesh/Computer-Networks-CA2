sim_time = 100
fsize = 0
sent = 0
recieved = 0
throughput = 0
packet_transfer_ratio = 0
sum_e2e_delay = 0
avg_e2e_delay = 0
packet_start_time = {}

f = open('tcp-exp.tr','r+')
lines = f.read().splitlines()
lines = [line.split() for line in lines]

for i, line in enumerate(lines):
    if line[34] == "ack":
        continue
    if line[0] == "s" and (line[8] == "0" or line[8] == "1") and line[40] != "0":
        sent += 1
        packet_start_time[line[40]] = float(line[2]);
    
    if line[0] == "r" and (line[8] == "7" or line[8] == "8") and line[40] != "0":
        fsize += float(line[36])
        recieved += 1
        sum_e2e_delay += float(line[2]) - packet_start_time[line[40]]
    

sent /= 2 #because every node sends a packet to itself first
throughput = (fsize * 8) / sim_time
packet_transfer_ratio = recieved / sent
avg_e2e_delay = (sum_e2e_delay) / recieved
print("\nThroughput:", throughput)
print("Packet Transfer Ratio:", packet_transfer_ratio)
print("Avg End to End Delay:", avg_e2e_delay, "s")
f = open("result.txt", "a")
f.write(str(throughput) + ' ' + str(packet_transfer_ratio) + ' ' + str(avg_e2e_delay) + '\n')
f.close()