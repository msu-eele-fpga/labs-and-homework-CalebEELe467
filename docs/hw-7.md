

# Hw 7 : Linux Command Line Practice
## Overview
Familierized myself with various command line tools in linux.

## Deliverables

### Problem 1 
`wc -w lorem-ipsum.txt`

![Problem 1 output](/docs/assets/hw-7_assets/Problem1.png)

### Problem 2 
`wc -m lorem-ipsum.txt`

![Problem 2 output](/docs/assets/hw-7_assets/problem2.png)

### Problem 3 
`wc -l lorem-ipsum.txt`

![Problem 3 output](/docs/assets/hw-7_assets/problem3.png)

### Problem 4
`sort -h files-sizes.txt`

![Problem 4 Output](/docs/assets/hw-7_assets/problem4.png)

### Problem 5 
`sort -hr files-sizes.txt`

![Problem 5 Output](/docs/assets/hw-7_assets/problem5.png)



### Problem 6
`cut -d ',' -f 3 log.csv `

![Problem 6 output](/docs/assets/hw-7_assets/problem6.png)

### Problem 7
`cut -d ',' -f 2-3 log.csv`

![Problem 7 output](/docs/assets/hw-7_assets/problem7.png)

### Problem 8
`cut -d ',' -f 1,4 log.csv`

![Problem 8 output](/docs/assets/hw-7_assets/problem8.png)

### Problem 9
`head -n 3 gibberish.txt`

![Problem 9 output](/docs/assets/hw-7_assets/problem9.png)

### Problem 10
`tail -n 2 gibberish.txt`

![Problem 10 output](/docs/assets/hw-7_assets/problem10.png)

### Problem 11
`tail -n 20 log.csv`

![Problem 11 output](/docs/assets/hw-7_assets/problem11.png)

### Problem 12
`grep 'and' gibberish.txt`

![Problem 12 output](/docs/assets/hw-7_assets/problem12.png)

### Problem 13
`grep -w -n 'we'  gibberish.txt`

![Problem 13 output](/docs/assets/hw-7_assets/problem13.png)


### Problem 15
`grep -c -i 'FPGAs'  fpgas.txt`

![Problem 15 output](/docs/assets/hw-7_assets/problem15.png)

### Problem 17
`grep -c -i -r '--' hdl/*`

![Problem 17 output](/docs/assets/hw-7_assets/problem17.png)

### Problem 18
`ls > ls-output.txt`

![Problem 18 output](/docs/assets/hw-7_assets/problem18.png)

### Problem 19
`sudo dmesg | grep 'CPU'`

![Problem 19 output](/docs/assets/hw-7_assets/problem19.png)

### Problem 20
`find hdl -iname '*.vhd' | wc -l`

![Problem 20 output](/docs/assets/hw-7_assets/problem20.png)

### Problem 21 
`grep -c -i -r '--' hdl/* | wc -l`

![Problem 21 output](/docs/assets/hw-7_assets/problem21.png)

### Problem 22 
`cat fpgas.txt | grep -n -i 'fpgas' | cut -d ':' -f 1`

![Problem 22 output](/docs/assets/hw-7_assets/problem22.png)

### Problem 23
`du -h * | sort -hr | head -n 3`

![Problem 23 output](/docs/assets/hw-7_assets/problem22.png)














