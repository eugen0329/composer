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
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� �/Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[�/�$!�:���Q����u|���`�_>H�&�W�&���;|Aq�)ǎ�Ņ@����i�cl����j_֩��f/�{-�
����O�ih/�{=��ه����O�^ɿ�&���W�����+���7������r��$AV�/���m��bo�˟@��_~I�s����e \.���J�e����Ӊ�ag���=���N�O�����EI��R�|R{�N�i�V��(>f���b�"��y8eS.a�4M�4�:$a��"�#��>M��ڎG�.�">��d�5�*�e��4�)�E����c���þԐ2:���WGpbCVk"/�A���&0�Z[�Ny��ty���,#�.��&���[�j��Z��P6m-hS���Zv�)�� n����W�،���@O+16)=�;�|<7�}��QQ��:�=��񔥇��VB�F��� �f�OX�z_^Ⱥ,R�B�#[�����ڷoЩ��*��wG�����o{�t���������Q��_)�(��e\�^'~����������@*�_
�^�Y��Bm�j~Y����\�@(k�R�Y��2C�gͥ�m-��0\M�nO�0�BE�r��,�Դ�����A4��F �<��5L���x�Fdb�P�S�S�&mdq���!9�G��9����'��6̅;g�ヸ��B��b�Mn1�zn���A�!⊠���z�ŌG�!i�^=ܧ� v0?�`����Сs͡��Չ�XD���Cq'������Y�M��I[,��oā�q�t1�S�b>��Cso୥bpc�S��L� O
��
p�����yxsh���H"S�n$L�^�[\c�ƨ��s��/;hS@�N��䒡ʅ�ʻ�R�L�ŭ�L�f�E�F�S q|~O�E�5�(�dz�>h���@���kp+O<��p `��Q�:��xY���"cR��M����� ��z`m:�������}�\)L�B�<@B��^�x�:tr �	>��-�F\Ę�2�`���>;��ߵs9䖓�%���D�b�ՇL�@�"=�cш�̢O�Q��>,>0����{f��_���4|����Q���R�A����x��ѧ���U�x���Y��Nt��:PC��f{��W�d�%��'�s>��v<�3�H'B�~Ĩ�*�#F};��rd��A��`� �EZ��`����4E�w���7��0EWrH<�0��'�5�%��;�b��V.�S^S�Q���lM�HM\L���C�f�ߛe�.�i���ռ���ž�@h]�.?���gN�ȅ�D�=�5af[8�ȑ�[���9k@@H\^d��!��
 y;?U2�x-�cb��a�59p�k9�;�u]�����f�ڔ�Q"��0~:h=��E�Fѥ>��6s0!����8N�H�YD��M��_��~a(�v�7�6cyb|�M����u-�WS�ͬ��C��db<�?�/��~����?$Y�����Ϝ�/����.�����������s�_��o�	�����������?3����JA�S�����'}�p�/�l��:N�l��0M���H@�.���Ca��(����U�?ʐ�+�ߏ�����J��?|�'��&�<i�'�ˬ�YB�+<�8�0��(�������ll��m3b2n�I���-�/�eK֓�9�6��s�i��nG�sln���_n�ۭ �Q���R��a��^���������/%���A+�_���j��Z����ޥ�?1����W>H���?$����J������ߛ9	�G(L���.@^����`�����%��7kpl�L̇0�н�4��ށ
��*@�tb�I�7���txs�;��H��H�\u:w��f�z3�7l�k���AS�(^��b�.u�A��U;Ǝ�Y�{�u�9Ҷxd\�ǈ�#}/8���sr��8m�<f	��i��� =����4�+qz��	'�h>Cm��LBDy�Z|g����haڳ'�&Te p�� j��a���ЬG����l�]wZ����Ҟ)-K�z��͎���#JH;#)ɜ�H^�n�@B�<�+���z�Z��|����?3����|��?#����RP����_���=�f����>�r�G���Rp��_��q1�c�W�_
*������?����?�zl h��T�e����t���GC�'��]����p�����Q�a	�DX�qX$@H�Ei�$)�����P��/��Ch���2pA��ʄ]�_�V�byñ9�5�f{�9Ҫ�l�m��Rx1�%���q�N+)54$wm'���ǫ{���(ǌ��v��7pD���������=n2�L?�SJN�v�*���x<�����?�b���j���A���y
�;�����rp��o__�.�?N���/����ۗ/+���O�8Zɿ|��_�z����t�����?X1ٟ���4]����O��,�Ѕ��bD�b�cۤ��K�.F!�K�,f{X�������L8��2��VE���_���#�������?]D��� �D4L^L�ݠ�nci�x�s�X鮑&����V�p�e���+�au]��S��0"7�3�`��(�|�G�|F�T��Nc�[����&���k��3[��ލ���/m}��GP��W
~�%�������W>i�?Ⱦ4Z�B�(C����q����'����R�Z�W���������]���X��a���ǳ�>�Y@���g�ݏ��{P����]P�z�F��=tw��ρnX�΁���~�9�Ѓ��6��2q�p��N�}1/�.���G��&1]���&�����k��4�Gx,�3��gr�CMf=Q'���7G����Q[x+.�K����Dӭ3�YO>�#ܖ�Q�2��8��n�u_;ms.���k ��ݚ�r.k)ZV�y:E��ڔ�9��t��nw�cC��B�w{�C ����䶷�<����à�bM p"�r65�y{WW\����Vd���Fg9�,3�V�֟��A��߃ j�;%6�NГr�&{+~f��ni���p�5��!��x����/m�����_
~���+��o�����Vn�o�2�����l�'������m�?���?�m�a��o��N2;M�p�g�?���qo(�g���@y�@wA޺d�d����5`�5M|��?�O΃���ɡ���-*�;��5Y/��Z�o�JOM���C|k�r�Z��0�SٌI2��u��(�Z"��r��դ��y��!�~��܇.���� ��Y>h��@�Dk�<�w�u7��+e0��j.uq�?%s9��V{f��!Wk����=h�t�0B��G�P��a�?������/q����d�W
~��|�Q��)	�1����ʐ�{�����Y����j��Z�������7��w�s���aX�����r�_n�]���PU�g)��������\��-�(���O��o��r�'<¦iCI�b�d	��}�H�'p&@�vq�Q�!֧���u1�a0�:�B������/$]������ �eJ���-sjư���S�m�m+[,�Fi�5yq��1��t�V�֕�FwGѽdMq=�o{;�cF��sh}�
��A~
ӻ�N���r���)�2�Q_��,6��y����bw�����8��������������/�V��U
�~�Z�k�/�/��t;u��+T��6r��j������>�Ӆ��tl'��W��u�P7q�^#�ȕ�H&��3�r;M�e�/��Jj���8]�oxp��*�7�_��k�:��OOL�t�}��_4B_��uJ+nd/���lR�rk=��v�vU�\W+��¯�z�'�}_�8W4�����'�ծ��i�����$��v坺`/6������KNu��֧����ڞ.��fiGŨp훻ʠ����p;r���}eX��hluuA�E��!��:7�o�*]���!ק�K�}���F�+|;��������>w�z��8N����Q��E�g_nl��ߓ�o���7��d�y�,�3�^����o���:b��"{�a�%o�� ��w[/��������i]��Wv7�~Z���<���ϫ��g￟��c��_m�\T{X����q:�.�o�~��q���8��8K]8��'�PY?�n��v��&>ф�D����8���S�n�>*���~~ˇ#������NY��c������	d��
�8��!�"v�7�h�<.��#��:����M��3B�+�Ʒ�r��
��$����N�t��ϖ�u�p��>����6�u�L������v��v��!�����:���(u�8�8N�|'Ku��8v'�����
H�H��E��@��?*@�_�����E���u�в[��8vO2If2��m)>W��������>���眓�B���}x{��`��l�:���r��JH�<D
��T:E'b2_f;�Yc�\.����ƒQZۺv�@u�$�b��}ͦȤ�u�fZL�2�n�`�@��b^��ɼ<��-�9��CL��NWW]uUQ��!v��_�51\��@Pk�A.�ce2�aإ@���:bׄoX"�2r��P7�6�MU�����N3���%���)�g<��Ot�B���2,���NK�o��:�S���qμ	W�샙�f��9���9�XFBlQ���<���F�j_4�W���Bi5^�2V5Q;5���훳��)�b��{c��*yݢ�:@��S�,p�6����NKpJ�-��������OVwZ�h5�ή�������$]�uj�z�Q�Cx7�{�:�4:����9���u�M��Lڄŉ*>�z�����#���#
fOgt�|6܏/H@Y����x��x�P��J�DC��Y�)?�2meq��P����%��������3�3���E����u�&�i-P��Q���J|��oX7�{<KB�N_m�BK2��#x���\;���z�b6[�5F1���+�|�ȹ���>I���h�cI
ZG"b�L��e	��:� l��boKb�1���u�'�B69w�oK���>T�5������ӷ;[����:����w�t��j@?�}Z�C�y�(�{}���8�Oޠ�ƆǺ�W����xqs����?��������O�I�4(m]ع���?}�{w��U�Ɠ�X���<�S��ؾփA�K��y�~�~�^��Q��0����0�OD\��#W��}�+?�ϧ������?.�������g�a�;�c�����@8�u7�8��#/<��k�M���א/\C>wm��W.�@j�����xqWZ"0��9n�``s����GⲐb�m&l�5H��x�s��&Y��'�y�Y�����o��Æ�dO ���V�J�F�}ԛHU�ro�[B��0G{�B�S���cN(u�v	c���"YaX��}Ќ�t�<.�D�Yl�g�9��-����G���نn�J���|��? è�Z����!�0����dG�Ā��a��	������.K�\6?j��n�,y�R���|q�H�V�(�50�f�)!�}#���*�������#b��g􌆦��f%T�G�C�|�a�:LX�	�	���1�9a�s�zB��7��D�����R {O͍�u�PJ��lC�Ǽd0�:�I�C���ߥB�U��Tѡ���Am��x�H�R7�i$�@{
N˹(�oy�ŔB��N��47�qY,[͠\�T���D�'��%d="� ;V���d/���#|�+��i��W5��/7��d�f�6O4?و�@�qZV��ZC�7��l;n���d�RKJ<Ǒ�f$$�ر�h���='eY�낲�ys������j%8tF�QЛj	h�+�%�XPx9�	�x��Q�}�k�b�(g:r�	�����k�@�)T�Q����)�)l�(+L���2u��,��d��d������Ze��>2(�l`LSF_L����
A��^,��}�d��I�R�Ѹ^.��>�aa�I�A����A���)y(�5��^[eI�R��
e�,��%�'"�`�^M(�4��@J1��ScoZꍍva�D�Ѡ��YDH��Z�����q�Z�-� �F����S@MyO�,Q9�P����PUi��x����aK�rDxAv��p�]�?�`��CV���FyvP6ZOI>�e�%���-E?P��օ.��R�7�c���Wc�(���˽w��������m3�m�i�7�.鍮�Ȼ�k[w";�r	���u������v&�!7�}�\�m��|��;�ʊ|�TU���9�w����.r?r7�����[�p��E�sPFU�y ��G
��uIE���y<@Mb
Y���뫆�l�Uu/ψ�g�G��l#��ECUT[��Z�k�E�-��-���3�Ʈ>�˾M��9W�+[oB����[��/lR ��ҨY-Gފ����\yv��2��2��������eR�`_L*|�:�s��X�~��:�����3q#W wY���g��cl�A�C>r�$���m�����n��8/�<w��=Yx0m/<�vhJk�j}��B�N�����/-<(���:R2k����`4?4�E�a��þ2�t��ʑg�8낃�V�Әo֜AD����`)1m�X�B{cfWi˴_��1���J��s�h��g�Z�1�Ib��Hs���
K�2F	t���"tn�M6m�@�<�X�g�rdb&��&���a�G�XXʚ���ǐ�fIk�03á�D���=*��'s��Q�4;�1�r�͵=��Y�X<8&��dP�;.�$�a�#x�ͦ[����㽐8d	)ܑ�=���"�C��-�E��Ѽ�"��0ʃlBD�5�c�q8�q��9��A��ʷ�9��Mh����L��l��Q�!(��\�{��v�C�w�ayO���ۿbv�o���=,�m�H�'��� ����J��ƪ-R�\�I����@&*�op�p�X@��ZTn�"�<(B.Ef1p֠ȬU`�o֜e�������b0���Z��3�AR��ae��3$&w3��w<!��h=g�b��a	$�Z�F[���z������h���JF������!Gc!����XU��Q���B�5�J[��}���W��T���pQ��v��U��I�8���L�L�j�T�<h�Ka�0�D�ڞZ�x�㆜�SH���.O�F�Y)���~��4�Z:vi�=,�8��{3�Sy?�ň�FN���N�B�B_��6���Za����!7:R����nO���[��9��iD���t�0D��}��>�-~lO%I�� ���rq���w@p�^yd)�j6	>�����ͽ	lf�/?��:?{����Ͼ�����{����=�=�~ ��U���5��I�i�D�s��D�'�?��G���?oK��W��_�z��������ч��/?�|���<�?/|��ٯ�߹~��$�R|1	����;M���������t�F�A��.��;����?���-����q�_��O����0�%���z���37��"���ӡv:�N�&��j������	H;i���P;j��9>���yj��m��8�rh\����"4ŷEy�*B�,�9C�-�z���Y#�y������KsԄ�g�u�����|Jux�q8������<k�v�l�륹i6�<-gΌmu��8��iΜ�8�sf�0��S`n�̜��;EhmS��K=G2�y�K��wL�9�INr��^���>�  