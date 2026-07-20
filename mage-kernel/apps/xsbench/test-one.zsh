#!/bin/zsh -e

if [[ -z $MIND_ROOT ]]; then
        echo '$MIND_ROOT not set!' >/dev/stderr
        exit 1
fi
source $MIND_ROOT/scripts/config.sh
cd $MIND_ROOT/apps/xsbench

if [[ $# -lt 4 || $# -gt 5 ]]; then
	echo 'args: cn, fh, bs, lmem_mib [, enable_perf]!'
	exit 1
fi

cn=$1
fh=$2
bs=$3
local_mem_mib=$4
enable_perf=${5:-0}

log_root='/tmp/logs'
output_log="$log_root/$fh.log"
mkdir -p $log_root

generate-pretest-logs $cn $fh $bs $local_mem_mib

export OMP_NUM_THREADS=$fh
if [[ $enable_perf == 1 ]]; then
    sudo sysctl -w kernel.perf_event_paranoid=-1
	sudo sysctl -w kernel.kptr_restrict=0
	$MIND_ROOT/mind_linux/tools/perf/perf record -F 99 -a --call-graph fp -o $log_root/$fh.perf.data -- \
        /usr/bin/time -v \
        ./XSBench/openmp-threading/XSBench -t $fh -m history -s XL -l 34 -p 5000000 -G unionized -g 30000 \
        |& tee $output_log
else
	/usr/bin/time -v \
		./XSBench/openmp-threading/XSBench -t $fh -m history -s XL -l 34 -p 5000000 -G unionized -g 30000 \
		|& tee $output_log
fi

generate-posttest-logs $cn $fh $bs $local_mem_mib
echo "test-one: done."
