#/bin/sh

# Default values 
NUM_OSD=5
NUM_TEST=2
NUM_DISK=10

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
        -h|--help)
        echo "Usage: $0 [-o|--osd] [-t|--test] [-d|--disk] [-h|--help]"
        exit 0
        ;;
        *)    # unknown option
        POSITIONAL+=("$1") # save it in an array for later
        shift # past argument
        ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

./create_nics.sh $NUM_OSD $NUM_TEST

./create_vms.sh $NUM_OSD $NUM_TEST

./create_disks.sh $NUM_OSD $NUM_DISK