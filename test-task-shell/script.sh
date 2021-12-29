wget https://raw.githubusercontent.com/GreatMedivack/files/master/list.out -Nq

date=$(date +"%m_%d_%Y")

if [ -z "$1" ]; then
	server_name='DEFAULT_SERVER'
else
	server_name=$1;
fi


exec cat ./list.out | grep 'Error\|CrashLoopBackOff' | awk {'print $1'} | sed 's/-[0-9].*//g' > ./${server_name}_${date}_failed.out
exec cat ./list.out | grep Running | awk {'print $1'}  | sed 's/-[0-9].*//g'  > ./${server_name}_${date}_running.out



runningAmount=$(wc ./${server_name}_${date}_running.out | awk {'print $1'})
errorAmount=$(wc  ./${server_name}_${date}_failed.out | awk {'print $1'})
restartAmount=$(cat ./list.out | awk {'print $4'} | grep -v '0\|RESTARTS' |  wc -l)



echo 'Количество работающих сервисов:' $runningAmount > ./${server_name}_${date}_report.out
echo 'Количество сервисов с ошибками:' $errorAmount >> ./${server_name}_${date}_report.out
echo 'Количество перезапустившихся сервисов:' $restartAmount >> ./${server_name}_${date}_report.out
echo 'User' $(whoami) >> ./${server_name}_${date}_report.out
echo 'Дата' $(date +"%m/%d/%Y") >> ./${server_name}_${date}_report.out


if [ -e ./archives/SERVER_DATE.tar.gz ]; then
	echo 'Файл архива уже существует';	
else
	tar cvzf ./archives/SERVER_DATE.tar.gz *.out >> /dev/null
fi


rm  *.out

if gunzip -t archives/SERVER_DATE.tar.gz; then
	echo "Скрипт отработал успешно";
else
	echo "Архив повреждён";
fi
