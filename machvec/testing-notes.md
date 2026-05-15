t2 inst fio
t2 inst sysbench
git clone https://github.com/FraSharp/hackbench.git
cd hackbench
gcc -g -Wall -O2 -o hackbench hackbench.c -lpthread

Common usage ./hackbench -pTl 4000

git clone https://github.com/intel/lmbench.git
cd lmbench && make results

cd /usr/src/


cd /root/perftest/results

export PATH=/root/perftest/custom:$PATH

for i in 1 2 3 4 5; do
  taskset -c 0 lat_null   | tee -a $RUN/lat_null.txt
  taskset -c 0,1 lat_ctx  | tee -a $RUN/lat_ctx.txt
  lat_pf                  | tee -a $RUN/lat_pf.txt
done


