#/bin/sh

# Default values 
NUM_OSD=5
NUM_TEST=2
NUM_DISK=10
NORG=0
NONET=0
NOVM=0
NODISK=0

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -o|--osd)
        NUM_OSD="$2"
        shift # past argument
        shift # past value
        ;;
        -t|--test)
        NUM_TEST="$2"
        shift # past argument
        shift # past value
        ;;
        -d|--disk)
        NUM_DISK="$2"
        shift # past argument
        shift # past value
        ;;
        -p|--prefix)
        PREFIX="$2"
        shift # past argument
        shift # past value
        ;;
        --norg)
        NORG=1
        shift # past argument
        ;;
        --nonet)
        NONET=1
        shift # past argument
        ;;
        --novm)
        NOVM=1
        shift # past argument
        ;;
        --nodisk)
        NODISK=1
        shift # past argument
        ;;
        -h|--help)
        echo "Usage: $0 [-o|--osd] [-t|--test] [-d|--disk] [p|--prefix] [--nonet] [--novm] [--nodisk] [-h|--help]"
        exit 0
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

[ "$NORG" -eq "0" ] && ./create_rg.sh $PREFIX

[ "$NONET" -eq "0" ] && ./create_nics.sh $NUM_OSD $NUM_TEST $PREFIX

[ "$NOVM" -eq "0" ] && ./create_vms.sh $NUM_OSD $NUM_TEST $PREFIX

[ "$NODISK" -eq "0" ] && ./create_disks.sh $NUM_OSD $NUM_DISK $PREFIX