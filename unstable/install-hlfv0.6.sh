(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-baseimage:x86_64-0.1.0
docker tag hyperledger/fabric-baseimage:x86_64-0.1.0 hyperledger/fabric-baseimage:latest

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin")   open http://localhost:8080
            ;;
"Linux")    if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                 xdg-open http://localhost:8080
	        elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
                       #elif other types bla bla
	        else   
		            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
            ;;
*)          echo "Playground not launched - this OS is currently not supported "
            ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �/Y �[o�0�yx�@B(�21��K�AI`�S��&�Ҳ��}v� !a]�j�$�$r9�o���c��"M;�� B��������u�]���w�$IBM�DQ�R��Ů(�5 �(e�(� ��X)�N�^�����D8�eP���"DRl�H>�Cފ�Hj�7 �g��6�9kD��֊`��S>]��^�)�z-��b���G/��K�+�K#�!?�$�=���N���kˡ9������G��$(�Ѷ�,ߑs�R{
��"D������lb��a�N�&1����U�s5s0iP�CA��Z���&b4W'3����In�۩E�$��N��[�)�x<��M.����Ÿ��Q�&��1�<1!�����U�����x�^��l��mbܕ��J���B��(6K�;��W���]��ڷ$\����C�!
ݖ��h�6hD.B!��X�?p`�L��i�&��VU<�DEw�49�߿�е�k$�S��W �K�j��<-�����t�괊Cuv3������� u;�}d�������(���lܗZ�P�oy����c��"���}�	o�7����^S�n��m�����4�M�}�ۭ}�m��l�Qy�]78�w��BS�tk�t5|y�K�!�cPY�R�m���KUi�`��±��K�Pa?PAT�<�ޞ�u�%�M�g����Gi���}"���_=;<���U���p8���p8���p8���p�&?�יd (  