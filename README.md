mbed Device Connector integration bridge image importer for IBM IoTF

Date: January 22, 2016

Bridge source: https://github.com/ARMmbed/connector-bridge.git

Prerequisites (Ubuntu 14.04 LTS only):
- IBM Bluemix Account created and setup
- Understanding if your default Bluemix namespace ("dev" used in sample below)
- Understanding of your default Bluemix container namespace ("dev" used in sample below)
- ICE 3.0 Bluemix utilities installed
- IBM Cloud Foundary utilities installed
- Docker installed

To import container image containing the connector-bridge runtime into Bluemix for instantiation:

    ubuntu% ./build_connector_bridge.sh

    Usage: ./build_connector_bridge.sh <bm user> <bm password> <space> <container namespace> <container instance name>

    ubuntu% ./build_connector_bridge.sh myBMUsername myBMPassword dev dev connector-bridge
