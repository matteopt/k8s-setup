mkdir node_base
./virtc.sh node_base/alpine1.raw 10.0.1.101
./virtc.sh node_base/alpine2.raw 10.0.1.102
./virtc.sh node_base/alpine3.raw 10.0.1.103
./virtc.sh node_base/alpine4.raw 10.0.1.104
mkdir nodes
cp node_base/* nodes
