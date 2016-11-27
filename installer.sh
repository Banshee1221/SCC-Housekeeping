# This is the global installer that can start the setup for either the hosts
# or client machine. The client setup process should be a lot simpler than
# the host since you actually want to manage the clients through ansible
# playbooks, sicne you can just easily execute that from the host.

VAL=0
for var in "$@"
do
  if [[ $var == "-h" ]] || [[ $var == "--help" ]]
  then
    printf "\n\tThis script starts the installer for either the headnode
\tor the compute nodes in the cluster and must be executed
\ton each of the respective nodes individually.\n\n\tUsage:
\t  ./installer.sh --head:\tThis will configure the head node.
\t  ./installer.sh --compute:\tThis will configure the compute node.\n\n"
    exit 0
  else
    ((VAL++))
  fi
done

if [ $VAL -gt 1 ]
then
  echo "Error: Don't pass more than one argument"
  exit 1
fi

while test $# -gt 0
do
  case "$1" in
      --head)
          cd head
          sudo bash ./setup.sh
          cd -
          exit 0
          ;;
      --compute)
          cd nodes
          sudo bash ./setup.sh
          cd -
          exit 0
          ;;
  esac
  shift
done

exit 0
