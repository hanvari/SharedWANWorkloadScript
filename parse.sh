#streams=( "iperf-1" )

logFiles=('nfs_main_traffic_with_bg_none.log')
for i in 1 2 4 8 12 16
do
  logFiles+=("nfs_main_traffic_with_bg_nfs_tcp${i}_cp.log")
done

_iperf1=()
_gftp1=()
_gftp2=()
_gftp4=()
_gftp8=()
_gftp16=()
_udt=()

_iperf1_err=()
_gftp1_err=()
_gftp2_err=()
_gftp4_err=()
_gftp8_err=()
_gftp16_err=()
_udt_err=()

for logFile in "${logFiles[@]}"
do
  #nfs_main_traffic_with_bg_nfs_tcp8_cp.log
  #iperf-1
  output="$(cat $logFile | grep -n iperf-1$ | awk -F ":" -vlogFile=$logFile '{system("sed -n \""$1+7"\"p " logFile)}' | awk '{print $7}' | awk '{x[NR]=$0; s+=$0; n++} END{a=s/n; for (i in x){ss += (x[i]-a)^2} sd = sqrt(ss/n); printf "%.2f\t%.2f\n", a, sd}')"
  _iperf1+=( $(echo $output | awk '{print $1}') )
  _iperf1_err+=( $(echo $output | awk '{print $2}') )
  echo $output

  #gridFTP-n (n=1,2,4,8,16)
  for p in 1 2 4 8 16
  do
    output="$(cat $logFile | grep -A1 gridFTP-$p$ | paste - - - | awk '{print (14*8*2^10)/$3}' | awk '{x[NR]=$0; s+=$0; n++} END{a=s/n; for (i in x){ss += (x[i]-a)^2} sd = sqrt(ss/n); printf "%.2f\t%.2f\n", a, sd}')"
    varArray="_gftp${p}"
    varArrayErr="_gftp${p}_err"
    #ToDo: complete..."
    echo $output
    
  done

  #UDT
  cat $logFile | grep -A10 UDT$ | grep real | awk '{print (14*8*2^10)/$2}' | awk '{x[NR]=$0; s+=$0; n++} END{a=s/n; for (i in x){ss += (x[i]-a)^2} sd = sqrt(ss/n); printf "%.2f\t%.2f\n", a, sd}'

done
