
enable
configure terminal
service internal
line con 0
exec-timeout 0 0    
exit
line vty 0 4
exec-timeout 0 0
end

term shell

function power() {
	if (( $1 )); then
		p=$1
		power=`sh int te0/1/$p tra | grep Rx | cut -d "=" -f 2 | cut -d " " -f 2`
		echo Rx Power: $power dBm
	else;
		echo Usage: power <port>
		echo ""
	fi
}

function start() {
	if (( $1 )); then
		p=$1
		show platform hardware subslot 0/1 module device "test pm prbs $p start 31"
	else;
		echo Usage: start <port>
		echo ""
	fi
}

function stop() {
	if (( $1 )); then
		p=$1
		show platform hardware subslot 0/1 module device "test pm prbs $p start 0"
	else;
		echo Usage: stop <port>
		echo ""
	fi

}

function check() {
	if (( $1 )); then
		p=$1
		show platform hardware subslot 0/1 module device "test pm prbs $p status"
	else;
		echo Usage: check <port>
		echo ""
	fi
}

function redo() {
	if (( $1 )); then
		p=$1
		stop $p
		sleep 5
		start $p
		sleep 5
		miscerrs=`check 1 | tail 2 | head 1 | cut -d " " -f 6`
		echo PRBS restarted
		echo ""
	else;
		echo Usage: redo <port>
		echo ""
	fi
}

function lockstat() {
	if (( $1 )); then
		p=$1
		lockstatus=`check $p | cut -d " " -f 4 | cut -d "," -f 1 | tail 2 | head 1`
		echo Lock Status: $lockstatus
	else;
		echo Usage: lockstat <port>
		echo ""
	fi
}


function prbstest() {
if (( $1 && $2 )); then
	p=$1
	length=$2
	redo $p
	echo "Resetting Error Count..."
	echo " "
	sleep 10
	lockstat $p
	errbit=0
	exitbit=0
	echo " "
	let err=`check $p | tail 2 | cut -d " " -f 6`
	if [[ $err -lt 0 ]]; then
		let err = 0 - $err
	fi
	echo Error Count: $err
	if [[ $err -gt 1 ]]; then
		exitbit=1
	fi
	echo " "
	echo "Starting $length minute test..."
	echo " "
	for x in `sh int | nl | cut -d":" -f 1 | head $length`; do
		if [[ $exitbit == 1 ]]; then
			let placeholdervar=0
		else;
			let x=$x
			let y=$x /2
			if [[ $x -ge 2 ]]; then
				for a in 1 2 3 4 5 6; do
					sleep 10
					let err=`check $p | tail 2 | cut -d " " -f 6`
					if [[ $err -lt 0 ]]; then
						let err = 0 - $err
					fi
					if [[ $errbit -lt 0 ]]; then
						let errbit = 0 - $errbit
					fi
					let errbit= $errbit + $err
					echo Error count: $errbit
				done
				echo " $errbit Error(s) in $x minutes."
				if [[ $errbit -le $y ]]; then
					echo " "
				else;
					echo " "
					echo "Too many errors :("
					exitbit=1
					echo " "
				fi
			else;
				for z in 1 2 3 4 5 6; do
					sleep 10
					let err=`check $p | tail 2 | cut -d " " -f 6`
						if [[ $err -lt 0 ]]; then
							let err = 0 - $err
						fi
						if [[ $errbit -lt 0 ]]; then
							let errbit = 0 - $errbit
						fi
					let errbit= $errbit + $err
					echo Error count: $errbit
				done
				echo " $errbit Error(s) in $x minute."
				if [[ $errbit -gt 1 ]]; then
					echo " "
					echo "Too many errors :("
					exitbit=1
					echo " "
				fi
				echo " "
			fi
		fi
	done
	power $p
	lockstat $p
	echo " "
else;
	echo " "
	echo "Usage: prbstest <port> <time>"
	echo " "
fi
}


wr

